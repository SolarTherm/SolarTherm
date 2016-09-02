within SolarTherm.Models.PowerBlocks;
model PowerBlockModel
  extends Interfaces.Models.PowerBlock;

  parameter SI.HeatFlowRate W_des=111e6 "Design turbine gross output" annotation (Dialog(group="Design"));
  parameter SI.Temperature T_in_ref=from_degC(574) "HTF inlet temperature (design)" annotation (Dialog(group="Design"));
  parameter SI.Temperature T_out_ref=from_degC(290) "HTF outlet temperature (design)"
                                                                                     annotation (Dialog(group="Design"));
  parameter SI.AbsolutePressure p_bo=10e5 "Boiler operating pressure" annotation (Dialog(group="Design"));
  parameter SI.HeatFlowRate Q_flow_ref=294.118e6 "Design thermal power" annotation (Dialog(group="Design"));

  parameter Real nu_min=0.25 "Minimum turbine operation" annotation (Dialog(group="Operating strategy"));
  SI.HeatFlowRate Q_flow( final start=0) "Cycle heat addition";
  SI.Temperature T_in=Medium.temperature(state_in);
  SI.Temperature T_out=Medium.temperature(state_out);


  parameter Boolean enable_losses = false
    "= true enable thermal losses with environment"
      annotation (Dialog(group="Assumptions"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter SI.Temperature T_des=from_degC(43) "Ambient temperature at design" annotation (Dialog(group="Assumptions",enable = enable_losses));

  Modelica.Blocks.Interfaces.RealInput T_amb if enable_losses annotation (Placement(
        transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={1.77636e-015,80}),                  iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,60})));

  replaceable model Cycle =
     SolarTherm.Models.PowerBlocks.Correlation.Rankine constrainedby
    SolarTherm.Models.PowerBlocks.Correlation.Cycle
    annotation (Dialog(group="Regresion"),choicesAllMatching=true);
    Cycle cycle;
protected
  parameter SI.Temperature Tsat_ref=Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_bo);
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  Real T_ND;
  Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,inStream(fluid_a.h_outflow));
  Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_a.p,h_out);
  parameter Medium.ThermodynamicState state_in_ref=Medium.setState_pTX(1e5,T_in_ref);
  parameter Medium.ThermodynamicState state_out_ref=Medium.setState_pTX(1e5,T_out_ref);
  parameter SI.SpecificEnthalpy h_in_ref=Medium.specificEnthalpy(state_in_ref);
  parameter SI.SpecificEnthalpy h_out_ref=Medium.specificEnthalpy(state_out_ref);
  Boolean logic;
  parameter SI.MassFlowRate m_flow_min= Q_flow_ref*nu_min/(h_in_ref-h_out_ref);
  Real nu_cool;
  Real k_q;
  Real k_w;

  Modelica.Blocks.Interfaces.RealInput T_amb_internal;
equation
  if enable_losses then
    connect(T_amb_internal,T_amb);
  else
    T_amb_internal=T_des;
  end if;
  cycle.T_ND=T_ND;

  logic=fluid_a.m_flow>m_flow_min;
  T_ND=(T_in-Tsat_ref)/(T_in_ref-Tsat_ref);
  h_in=inStream(fluid_a.h_outflow);
  h_out=fluid_b.h_outflow;
  h_out=fluid_a.h_outflow;
  fluid_a.m_flow+fluid_b.m_flow=0;
  fluid_a.p=fluid_b.p;
  nu_cool=1+0.075*(T_des-T_amb_internal)/20;

  if logic then
    k_q=cycle.k_q;
    k_w=cycle.k_w;
    Q_flow=-fluid_a.m_flow*(h_out-h_in);
  else
    k_q=0;
    k_w=0;
    h_out=h_out_ref;
  end if;

    Q_flow/Q_flow_ref=k_q;
    W_cy/(nu_cool*W_des)=k_w;

end PowerBlockModel;
