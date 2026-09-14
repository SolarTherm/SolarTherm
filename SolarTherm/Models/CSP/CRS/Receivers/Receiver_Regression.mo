within SolarTherm.Models.CSP.CRS.Receivers;
model Receiver_Regression
  extends Interfaces.Models.ReceiverFluid;
  import CN = Modelica.Constants;
  //Medium.BaseProperties medium;
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out(start=h_out_des);

  //Receiver parameters
  parameter SI.Area A_recv = 164.7657 "Receiver aperture area (m2)";
  parameter SI.MassFlowRate m_flow_des = 357.1 "Receiver design mass flow rate (kg/s)";
  parameter Real f_flow_min = 0.20;
  parameter Real f_flow_max = 1.10;
  
  parameter SI.Temperature T_in_des = 416.2 + 273.15;
  parameter SI.Temperature T_out_des = 872.6 + 273.15;
  
  parameter SI.MassFlowRate m_flow_min = f_flow_min*m_flow_des;
  parameter SI.MassFlowRate m_flow_max = f_flow_max*m_flow_des;
  
  parameter SI.HeatFlowRate Q_flow_helio_max = 220.0e6 "Heliostat output heat rate can not exceed this amount (J/s)";
  
  //Regression variable
  Real refl_recv;
  SI.Temperature T_recv;
  SI.CoefficientOfHeatTransfer h_conv;
  
  SI.HeatFlowRate Q_flow_helio_raw = heat.Q_flow "Raw heliostat output heat rate before curtailment (J/s)";
  SI.HeatFlowRate Q_flow_helio_out "Heliostat output heat rate after curtailment (J/s)";
  
  SI.HeatFlowRate Q_flow_loss "Receiver heat losses calculated after (J/s)";
  SI.HeatFlowRate Q_flow_recv "Receiver output heat rate (J/s)";
  Modelica.Blocks.Interfaces.RealInput T_amb annotation (Placement(
        visible = true,transformation(
        
        origin={0,84},extent={{-12,-12},{12,12}},
        rotation=-90), iconTransformation(
        
        origin={0,84},extent={{-6,-6},{6,6}},
        rotation=-90)));
        
  Modelica.Blocks.Interfaces.RealInput Q_curtail "Required curtailment heat-rate signal from the system controller" annotation (Placement(
        visible = true,transformation(
        
        origin={44,84},extent={{-12,-12},{12,12}},
        rotation=-90), iconTransformation(
        
        origin={-40, 72},extent={{6, -6}, {-6, 6}},
        rotation=180)));

  Modelica.Blocks.Interfaces.BooleanInput curtail "Does the heater output need to be curtailed based on system controller?" annotation (Placement(
        visible = true,transformation(extent = {{-126, -88}, {-86, -48}}, rotation = 0),iconTransformation(origin = {-18, 84}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));


  parameter Medium.ThermodynamicState state_in_des=Medium.setState_pTX(1e5,T_in_des);
  parameter Medium.ThermodynamicState state_out_des=Medium.setState_pTX(1e5,T_out_des);
  parameter SI.SpecificEnthalpy h_in_des=Medium.specificEnthalpy(state_in_des);
  parameter SI.SpecificEnthalpy h_out_des=Medium.specificEnthalpy(state_out_des);

  SI.MassFlowRate m_dot = fluid_a.m_flow "Mass flow rate used in the regression calculations (kg/s)";
  Real em_recv = 1.0 - refl_recv "Receiver emissivity";
  
  Real eff_recv_test;
  Real mu_recv_test = m_dot/m_flow_des;
  
protected
  //Regression coefficients
  /*
  constant Real r0 = 0.209;
  constant Real r1 = -0.001906;
  constant Real r2 = 1.007e-5;
  constant Real r3 = -2.41e-8;
  constant Real r4 = 2.142e-11;
  
  constant Real t0 = 1028.0;
  constant Real t1 = -1.568;
  constant Real t2 = 0.01504;
  constant Real t3 = -2.589e-5;
  constant Real t4 = 2.342e-8;
  
  constant Real h0 = 120.4;
  constant Real h1 = 0.4002;
  constant Real h2 = -0.001664;
  constant Real h3 = 3.422e-6;
  constant Real h4 = -2.786e-09; 
  */
equation
  //Regression calculations
  /*
  refl_recv = r0 + r1*m_dot + r2*(m_dot^2.0) + r3*(m_dot^3.0) + r4*(m_dot^4.0);
  T_recv = t0 + t1*m_dot + t2*(m_dot^2.0) + t3*(m_dot^3.0) + t4*(m_dot^4.0);
  h_conv = h0 + h1*m_dot + h2*(m_dot^2.0) + h3*(m_dot^3.0) + h4*(m_dot^4.0);
  */
  refl_recv = SolarTherm.Systems.H2DRI_Applications.recv_refl(m_dot);
  T_recv = SolarTherm.Systems.H2DRI_Applications.recv_T(m_dot);
  h_conv = SolarTherm.Systems.H2DRI_Applications.recv_h(m_dot);
  
  if m_dot > 1e-8 then
    Q_flow_recv = (1.0-refl_recv)*Q_flow_helio_out - Q_flow_loss;
    Q_flow_loss = A_recv*(em_recv*CN.sigma*((T_recv^4.0)-(T_amb^4.0))+h_conv*(T_recv-T_amb));
    h_out = h_in + Q_flow_recv/m_dot;
    eff_recv_test = Q_flow_recv/Q_flow_helio_out;
  else
    Q_flow_recv = 0.0;
    Q_flow_loss = 0.0; 
    h_out = h_out_des;
    eff_recv_test = 0.0;
  end if;
  
  if curtail then
    Q_flow_helio_out = min(Q_flow_helio_raw,Q_curtail);
  else
    Q_flow_helio_out = min(Q_flow_helio_raw,Q_flow_helio_max);
  end if;
  
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=max(h_in_des,h_out);
  fluid_a.h_outflow=0.0;

  heat.T=T_recv;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=fluid_b.p;


  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Receiver_Regression;