within SolarTherm.Models.CSP.CRS.Receivers;
model SodiumReceiver_modular "ReceiverSimple with convective losses"
	extends Interfaces.Models.ReceiverFluid;
	import Modelica.Math.log10;
	Medium.BaseProperties medium;
	SI.SpecificEnthalpy h_in(start=h_in_0,nominal=h_in_0);
	SI.SpecificEnthalpy h_out(start=h_out_0,nominal=h_out_0);
	SI.Temperature T_in=Medium.temperature(state_in);
	SI.Temperature T_out=Medium.temperature(state_out);

	parameter Integer n_modules = 1 "Number of cavity receivers" annotation(Dialog(group="Technical data"));
	parameter SI.Length H_rcv=1 "Receiver height" annotation(Dialog(group="Technical data"));
	parameter SI.Diameter D_rcv=1 "Receiver diameter" annotation(Dialog(group="Technical data"));
	parameter Integer N_pa = 1 "Number of panels" annotation(Dialog(group="Technical data"));
	parameter Integer N_fl = 1 "Number of parallel flow-paths" annotation(Dialog(group="Technical data"));
	parameter SI.Diameter D_tb=1 "Tube outer diameter" annotation(Dialog(group="Technical data"));
	parameter SI.Thickness t_tb=1 "Tube wall thickness" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency ab=1 "Coating absortance" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency em=1 "Coating Emitance" annotation(Dialog(group="Technical data"));
	parameter SI.CoefficientOfHeatTransfer alpha=1 "Convective heat transfer coefficient";
	parameter SI.HeatFlowRate Q_rec_des = 1 "Receiver thermal output at the design point";
	parameter SI.Thickness t_insulation = 0.03 "Thickness insulation of the piping network";
	parameter SI.HeatFlowRate Q_network = 1968192.9312*t_insulation^(-0.7381184018);

	parameter Real C1 = 0.9855;
	parameter Real C2 = -3.21e-7;
	parameter Real C3 = -453.49;
	parameter SI.Temperature T_ref = 979.38;

	SI.HeatFlowRate Q_loss;
	SI.HeatFlowRate Q_rcv;

	SI.Efficiency rec_frac "Fraction of design thermal output";
	SI.Efficiency eff "Calculated receiver efficiency";
	SI.Efficiency eta_rec "Receiver efficiency as calculated from correlation";
	SI.Energy E_rec;

	Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
				transformation(
				extent={{-12,-12},{12,12}},
				rotation=-90,
				origin={0,84}), iconTransformation(
				extent={{-6,-6},{6,6}},
				rotation=-90,
				origin={0,78})));

	parameter SI.Temperature T_in_0=from_degC(540) "Start value of inlet temperature";
	parameter SI.Temperature T_out_0=from_degC(740) "Start value of inlet temperature";

	Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
				transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
						-24,-98},{-12,-86}})));

	Modelica.Blocks.Interfaces.RealOutput Q_out annotation (
		Placement(visible = true, transformation(origin = {31, -23}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {31, -23}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));


protected
	parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
	parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
	parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
	parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
	parameter SI.Area A_out=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
	parameter SI.Area A_in=N_pa*N_tb_pa*H_rcv*pi*(D_tb-2*t_tb)/2 "Area";

	parameter Medium.ThermodynamicState state_in_0=Medium.setState_pTX(Medium.p_default,T_in_0);
	parameter Medium.ThermodynamicState state_out_0=Medium.setState_pTX(Medium.p_default,T_out_0);

	parameter SI.SpecificEnthalpy h_in_0=Medium.specificEnthalpy(state_in_0);
	parameter SI.SpecificEnthalpy h_out_0=Medium.specificEnthalpy(state_out_0);

	Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,h_in);
	Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_b.p,h_out);

equation

	medium.h=(h_in+h_out)/2;
	h_in=inStream(fluid_a.h_outflow);
	fluid_b.h_outflow=h_out;
	fluid_a.h_outflow=0;

	heat.T=medium.T;
	fluid_b.m_flow=-fluid_a.m_flow;
	fluid_a.p=medium.p;
	fluid_b.p=medium.p;

	if on then
		Q_loss = -n_modules*heat.Q_flow*(1-eta_rec) - Q_network;
		eta_rec = C1 + C2*(T_ref^4 - Tamb^4)/heat.Q_flow + C3*(T_ref - Tamb)/heat.Q_flow;
	else
		Q_loss = 0;
		eta_rec = 0;
	end if;
	
	0 = n_modules*heat.Q_flow + Q_loss + max(1e-3,fluid_a.m_flow)*(h_in-h_out);
	Q_rcv = fluid_a.m_flow*(h_out-h_in);
	rec_frac = Q_rcv/Q_rec_des;
	eff = Q_rcv/max(1,heat.Q_flow*n_modules);
	Q_out = heat.Q_flow*n_modules*eta_rec;

	der(E_rec) = Q_rcv;

	annotation (Documentation(info="<html>
<h4>Brief description:</h4>
<p>This model simulate an external receiver that is composed by a series of flat panels with the a vertical arragement of tubes. This panels are arranged around the circunference of the solar tower. The coating absortance and emittance of the tubes determine the receiver thermal losses. It assumes a single receiver temperature which is calculated acording the average temperature between the inlet and outlet fluid temperature. In this model a mass flow rate is heated as a function of the concentrated solar power considering thermal losses but neglecting effects due to receiver shape and thermal capacitances. The outlet specific enthaply is calculated in an algebraic way assuming that:</p>
<pre>heat flow rate absorbed = heat flow rate emitted + mass flow rate * (outlet specific enthalpy - inlet specific enthalpy)</pre>
<p>This model allows zero mass flow rate althought the model only guarantees the results at the operating range.</p>
<h4>Inputs:</h4>
<h5>HeatPort:</h5>
<ul>
<li>heat: This connector provides the total concentrated solar power that reachs the receiver and gives the temperature of the receiver.</li>
<h5>FluidPort:</h5>
<li>fluid_a: This connector provides the inlet mass flow rate and specific enthalpy of the system working fluid, the pressure is not used.</li>
</ul>
<h4>Parameters:</h4>
<h5>Working fluid:</h5>
<ul>
<li>Medium: This parameter defines the medium in the component. The thermodynamic properties of the fluid are function of this medium model. All Modelica.Media can be selected and new ones that extend from the Partial Medium</li>
</ul>
<h5>Technical data:</h5>
<ul>
<li>H_rcv: Height of the receiver panels.</li>
<li>D_rcv: Total diameter of the receiver. The double distance between the center of the tower to a center of a receiver panel.</li>
<li>N_pa: Total number of panels.</li>
<li>D_tb: The outer diameter of the panel tubes.</li>
<li>t_tb: The thickness of panel tubes.</li>
<li>ab: The absorptance of the receiver coating.</li>
<li>em: The emissivity of the receiver coating.</li>
</ul>
<h4>Outputs:</h4>
<h5>FluidPort:</h5>
<ul>
<li>fluid_b: This connector provides the outlet mass flow rate and specific enthalpy of the system working fluid, the pressure is not used.</li>
</ul>
</html>"));
end SodiumReceiver_modular;
