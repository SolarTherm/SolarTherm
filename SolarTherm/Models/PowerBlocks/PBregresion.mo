within SolarTherm.Models.PowerBlocks;
model PBregresion
  extends Interfaces.Models.PowerBlock;
  parameter SI.Temperature T_in_ref=from_degC(574)
    "HTF inlet temperature (design)";
  parameter SI.Temperature T_out_ref=from_degC(290)
    "HTF outlet temperature (design)";
  parameter SI.AbsolutePressure p_bo=10e5 "Boiler operating pressure";
  parameter SI.HeatFlowRate Q_flow_ref=294.118e6 "Design thermal power";
  parameter SI.HeatFlowRate W_des=111e6 "Design turbine gross output";
  parameter Real nu_min=0.25 "Minimum turbine operation";
  SI.HeatFlowRate Q_flow( final start=0)
                                        "Cycle heat addition";
//protected
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
  SI.Temperature T_in=Medium.temperature(state_in);
  SI.Temperature T_out=Medium.temperature(state_out);
  Boolean logic;
  parameter SI.MassFlowRate m_flow_min= Q_flow_ref*nu_min/(h_in_ref-h_out_ref);
equation

  logic=fluid_a.m_flow>m_flow_min;
  T_ND=(T_in-Tsat_ref)/(T_in_ref-Tsat_ref);
  h_in=inStream(fluid_a.h_outflow);
  h_out=fluid_b.h_outflow;
  h_out=fluid_a.h_outflow;
  fluid_a.m_flow+fluid_b.m_flow=0;
  fluid_a.p=fluid_b.p;
  ///Q_flow=-fluid_a.m_flow*(h_out-h_in);
  if logic then
    Q_flow/Q_flow_ref=-0.054078*T_ND^2+1.060131*T_ND-0.006011;
    W_cy/W_des=-0.007885*T_ND^2+1.036423*T_ND-0.027262;
    Q_flow=-fluid_a.m_flow*(h_out-h_in);
  else
    Q_flow/Q_flow_ref=0;
    W_cy/W_des=0;
    h_out=h_out_ref;
  end if;



end PBregresion;
