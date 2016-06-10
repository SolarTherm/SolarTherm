within SolarTherm.Models.PowerBlocks;
model PBregresion
  extends Interfaces.Models.PowerBlock;
  parameter SI.Temperature T_in_ref=from_degC(574)
    "HTF inlet temperature (design)";
  parameter SI.Temperature T_out_ref=from_degC(290)
    "HTF outlet temperature (design)";
  parameter SI.AbsolutePressure p_bo=10e5 "Boiler operating pressure";
  parameter SI.HeatFlowRate Q_flow_ref=294.118e6 "Design thermal power";
  parameter SI.HeatFlowRate W_des=100e6 "Estimated net output at design ";
  SI.HeatFlowRate Q_flow(start=0) "Cycle heat addition";
//protected
  parameter SI.Temperature Tsat_ref=Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p_bo);
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  Real T_ND;
  Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,inStream(fluid_a.h_outflow));
  SI.Temperature T_in=Medium.temperature(state_in);
  Boolean logic=fluid_a.m_flow>10;
equation
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
    h_out=h_in;
  end if;
end PBregresion;
