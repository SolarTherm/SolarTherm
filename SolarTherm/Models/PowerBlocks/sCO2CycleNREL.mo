within SolarTherm.Models.PowerBlocks;
model sCO2CycleNREL
	extends Interfaces.Models.PowerBlock;

	parameter SI.HeatFlowRate W_des=111e6 "Design turbine gross output" annotation (Dialog(group="Design"));
	parameter SI.Temperature T_in_ref=from_degC(574) "HTF inlet temperature (design)" annotation (Dialog(group="Design"));
	parameter SI.Temperature T_out_ref=from_degC(290) "HTF outlet temperature (design)" annotation (Dialog(group="Design"));
	parameter SI.AbsolutePressure p_bo=10e5 "Boiler operating pressure" annotation (Dialog(group="Design"));
	parameter SI.HeatFlowRate Q_flow_ref=294.118e6 "Design thermal power" annotation (Dialog(group="Design"));
	parameter SI.Power W_cooling_des = 0.02*W_des "Fraction of gross power consumed by cooling system";
	parameter SI.Efficiency nu_sys = 0.04 "System availability loss factor due to system outages and other events";

	parameter Real nu_min=0.25 "Minimum turbine operation" annotation (Dialog(group="Operating strategy"));
	SI.HeatFlowRate Q_flow( final start=0) "Cycle heat addition";
	SI.Temperature T_in=Medium.temperature(state_in);
	SI.Temperature T_out=Medium.temperature(state_out);

	parameter Boolean enable_losses = false "= true enable thermal losses with environment" annotation (Dialog(group="Assumptions"), Evaluate=true, choices(checkBox=true));

	parameter SI.Temperature T_des=from_degC(35) "Ambient temperature at design" annotation (Dialog(group="Assumptions",enable = enable_losses));

	parameter Boolean external_parasities = false 	"= true enable parasities as an input" annotation (Dialog(group="Parasities energy losses"), Evaluate=true, choices(checkBox=true));

	parameter Real nu_net=0.9 "Estimated gross to net conversion factor at the power block" annotation(Dialog(group="Parasities energy losses"));

	parameter Real W_base=0.0055*294.188e6 "Power consumed at all times" annotation(Dialog(group="Parasities energy losses"));

	Modelica.Blocks.Interfaces.RealInput T_amb if enable_losses annotation (Placement(
				transformation(extent={{-12,-12},{12,12}},
				rotation=-90,
				origin={1.77636e-015,80}),									iconTransformation(
				extent={{-6,-6},{6,6}},
				rotation=-90,
				origin={-20,60})));

	replaceable model Cycle =
				SolarTherm.Models.PowerBlocks.Correlation.sCO2NREL constrainedby
				SolarTherm.Models.PowerBlocks.Correlation.Cycle
				annotation (Dialog(group="Regresion"),choicesAllMatching=true);

	Cycle cycle(T_in=T_in,load=load,T_amb=T_amb_internal,final T_in_ref=T_in_ref);

	replaceable model Cooling = 
				SolarTherm.Models.PowerBlocks.Cooling.NREL constrainedby
				SolarTherm.Models.PowerBlocks.Cooling.Cooling
				annotation (Dialog(group="Cooling losses",enable = enable_losses),
				choicesAllMatching=true);

	Cooling cool(T_in=T_in,load=load,T_amb=T_amb_internal);

	Real load;
	Real eff_pb "Power Block Efficiency";

	SI.Power W_gross "Gross power cycle ouput";
	SI.Power W_cooling "Cooling system gross power";	
	SI.Power W_loss "Parasitic losses power";

	SI.Energy E_gross(final start=0, fixed=true, displayUnit="MW.h");
	SI.Energy E_net(final start=0, fixed=true, displayUnit="MW.h");

	Boolean logic;
	//Zeb Ramping
	Modelica.Blocks.Interfaces.RealInput PB_ramp_fraction annotation (Placement(
				visible = true,transformation(
				origin={-72, -4},extent={{-12,-12},{12,12}},
				rotation=0),  iconTransformation(
	
	origin={-52, -4},extent={{-6,-6},{6,6}},
	rotation=0)));
	//End Zeb ramping

	 Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation (Placement(
				visible = true,transformation(
				origin={1.77636e-15,80},extent={{-12,-12},{12,12}},
				rotation=-90),									iconTransformation(
				
				origin={20,60},extent={{-6,-6},{6,6}},
				rotation=-90)));

protected
	Modelica.Blocks.Interfaces.RealInput parasities_internal;
	Real k_q;
	Real k_w;
	SI.SpecificEnthalpy h_in;
	SI.SpecificEnthalpy h_out;
	parameter SI.MassFlowRate m_flow_ref= Q_flow_ref/(h_in_ref-h_out_ref);

	Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,inStream(fluid_a.h_outflow));
	Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_a.p,h_out);
	parameter Medium.ThermodynamicState state_in_ref=Medium.setState_pTX(1e5,T_in_ref);
	parameter Medium.ThermodynamicState state_out_ref=Medium.setState_pTX(1e5,T_out_ref);
	parameter SI.SpecificEnthalpy h_in_ref=Medium.specificEnthalpy(state_in_ref);
	parameter SI.SpecificEnthalpy h_out_ref=Medium.specificEnthalpy(state_out_ref);

	//parameter SI.MassFlowRate m_flow_min= nu_minm_flow_ref*nu_min;

	Modelica.Blocks.Interfaces.RealInput T_amb_internal;

	parameter Real nu_eps=0.1;

equation
	if enable_losses then
		connect(T_amb_internal,T_amb);
	else
		T_amb_internal=T_des;
	end if;
	if external_parasities then
		connect(parasities_internal,parasities);
	else
		parasities_internal=0;
	end if;

	logic=load>nu_min;
	h_in=inStream(fluid_a.h_outflow);
	h_out=fluid_b.h_outflow;
	h_out=fluid_a.h_outflow;
	fluid_a.m_flow+fluid_b.m_flow=0;
	fluid_a.p=fluid_b.p;

	load=max(nu_eps,fluid_a.m_flow/m_flow_ref); //load=1 if it is no able partial load

	if logic then
		k_q=cycle.k_q;
		k_w=cycle.k_w;
		Q_flow=-fluid_a.m_flow*(h_out-h_in);
	else
		k_q=0;
		k_w=0;
		h_out=h_out_ref;
	end if;

	//Zeb ramping
	if PB_ramp_fraction < 1e-6 then
		Q_flow = 0.0;
		W_gross = 0.0;
		W_cooling/W_cooling_des = 0.0;
	elseif noEvent(PB_ramp_fraction > 1.0-1e-6) then
		Q_flow/Q_flow_ref = k_q;
		W_gross/W_des = k_w;
		W_cooling/W_cooling_des = max(0,cool.nu_w);
	else
		Q_flow = PB_ramp_fraction*Q_flow_ref;
		W_gross = 0.0;
		W_cooling/W_cooling_des = max(0,cool.nu_w);
	end if;
	//End Zeb Ramping
	eff_pb = W_gross/max(1,Q_flow);

	der(E_gross)=W_gross;	
	der(E_net)=(1 - nu_sys)*W_net;
	W_loss = W_base + parasities_internal + W_cooling;
	W_net = W_gross - W_loss;

end sCO2CycleNREL;