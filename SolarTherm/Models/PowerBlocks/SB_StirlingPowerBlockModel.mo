within SolarTherm.Models.PowerBlocks;
model SB_StirlingPowerBlockModel
  extends Interfaces.Models.PowerBlock;
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_ph;
  parameter SI.HeatFlowRate P_name = 1.0e6 "Nameplate power block" annotation (Dialog(group="Design"));
  parameter Real nu_net=0.9 "Estimated gross to net conversion factor at the power block" annotation(Dialog(group="Parasities energy losses"));
  parameter SI.HeatFlowRate W_des=P_name/nu_net "Design turbine gross output before net losses" annotation (Dialog(group="Design"));
  parameter SI.Temperature T_in_ref=1073.0 "HTF inlet temperature (design)" annotation (Dialog(group="Design"));
  parameter SI.Temperature T_out_ref=1073.0 "HTF outlet temperature (design)" annotation (Dialog(group="Design"));
  parameter SI.Temperature T_cool_des=323.0 "Cold temperature of Stirling (design)" annotation (Dialog(group="Design"));
  parameter Real nu_gross_des = 0.7893*(1.0 - (T_cool_des/T_in_ref)^0.5) "Design gross efficiency of stirling cycle" annotation (Dialog(group="Design"));
  //parameter SI.AbsolutePressure p_bo=10e5 "Boiler operating pressure" annotation (Dialog(group="Design"));
  parameter SI.HeatFlowRate Q_flow_ref=W_des/nu_gross_des "Design thermal power" annotation (Dialog(group="Design"));

  parameter Real nu_min=0.25 "Minimum turbine operation" annotation (Dialog(group="Operating strategy"));
  Real nu_gross "Instantaneous pb gross efficiency";
  SI.HeatFlowRate Q_flow( final start=0) "Cycle heat addition";
  SI.Temperature T_in=Medium.temperature(state_in);
  SI.Temperature T_out=Medium.temperature(state_out);

  parameter Boolean enable_losses = false
    "= true enable thermal losses with environment"
      annotation (Dialog(group="Assumptions"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter SI.Temperature T_des=from_degC(43) "Ambient temperature at design" annotation (Dialog(group="Assumptions",enable = enable_losses));

  parameter Boolean external_parasities = false
    "= true enable parasities as an input"
      annotation (Dialog(group="Parasities energy losses"), Evaluate=true, HideResult=true, choices(checkBox=true));

  parameter Real W_base=0.0055*Q_flow_ref "Power consumed at all times" annotation(Dialog(group="Parasities energy losses"));

  Modelica.Blocks.Interfaces.RealInput T_amb if enable_losses annotation (Placement(
        transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={1.77636e-015,80}),                  iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-20,60})));
  /*replaceable model Cycle =
     SolarTherm.Models.PowerBlocks.Correlation.Rankine constrainedby
    SolarTherm.Models.PowerBlocks.Correlation.Cycle
    annotation (Dialog(group="Regresion"),choicesAllMatching=true);
  Cycle cycle(T_in=T_in,load=load,final T_in_ref=T_in_ref);
  replaceable model Cooling = SolarTherm.Models.PowerBlocks.Cooling.NoCooling constrainedby
    SolarTherm.Models.PowerBlocks.Cooling.Cooling
    annotation (Dialog(group="Cooling losses",enable = enable_losses),
      choicesAllMatching=true);
  Cooling cool(T_amb=T_amb_internal); */
  
  Real load;
  SI.HeatFlowRate W_gross "Gross power output";
  SI.HeatFlowRate W_loss "Parasitic losses power";
  //SI.HeatFlowRate W_net "Estimated net output at design";
  SI.Energy E_gross(final start=0, fixed=true, displayUnit="MW.h");
  SI.Energy E_net(final start=0, fixed=true, displayUnit="MW.h");
  parameter SI.MassFlowRate m_flow_ref= Q_flow_ref/(h_in_ref-h_out_ref);

  Boolean logic;

   Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation (Placement(
        transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={1.77636e-015,80}),                  iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={20,60})));

  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  
protected
  Modelica.Blocks.Interfaces.RealInput parasities_internal;
  //Real k_q;
  //Real k_w;


  Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,inStream(fluid_a.h_outflow));
  Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_a.p,h_out);
  parameter Medium.ThermodynamicState state_in_ref=Medium.setState_pTX(1e5,T_in_ref,{0.0,1.0});
  parameter Medium.ThermodynamicState state_out_ref=Medium.setState_pTX(1e5,T_out_ref,{1.0,0.0});
  parameter SI.SpecificEnthalpy h_in_ref=Medium.specificEnthalpy(state_in_ref);
  parameter SI.SpecificEnthalpy h_out_ref=Medium.specificEnthalpy(state_out_ref);

  //parameter SI.MassFlowRate m_flow_min= nu_minm_flow_ref*nu_min;

  Modelica.Blocks.Interfaces.RealInput T_amb_internal;

  parameter Real nu_eps=0.1;
  
  //ramping time
  parameter SI.Time t_startup = 20*60;
  Real ramp_fraction (start=0);
  SI.Time t_ramp_initial (start=-60);
  SI.Time t_ramp_final (start = 0);
  
algorithm
  when logic == true then
    t_ramp_initial := time;
    t_ramp_final := time + t_startup;
  end when;
equation
  ramp_fraction = min(1.0,(time - t_ramp_initial)/(t_ramp_final-t_ramp_initial));

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
  fluid_a.h_outflow = 0;
  fluid_a.m_flow+fluid_b.m_flow=0;
  fluid_a.p=fluid_b.p;

  load=max(nu_eps,fluid_a.m_flow/m_flow_ref); //load=1 if it is no able partial load

  if logic then
    //k_q=cycle.k_q;
    //k_w=cycle.k_w;
  //if fluid_a.m_flow > 1e-6 then
    nu_gross = 0.7893*(1.0-(T_cool_des/T_in)^0.5);
    Q_flow = W_des/nu_gross;
    h_out = h_in - Q_flow/fluid_a.m_flow;
    //Q_flow=-fluid_a.m_flow*(h_out-h_in);
  else
    //k_q=0;
    //k_w=0;
    h_out=h_in;
    nu_gross = 0;
    Q_flow = 0.0;
  end if;

  W_gross = (Q_flow*nu_gross)*ramp_fraction;
  //Q_flow/(cool.nu_q*Q_flow_ref*load)=k_q;
  //W_gross/(cool.nu_w*W_des*load)=k_w;

  der(E_gross)=W_gross;
  der(E_net)=W_net;
  W_loss=(1-nu_net)*W_gross+W_base+parasities_internal;
  W_net = W_gross - W_loss;

end SB_StirlingPowerBlockModel;