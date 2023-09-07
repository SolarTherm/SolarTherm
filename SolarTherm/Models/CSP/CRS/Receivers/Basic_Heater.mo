within SolarTherm.Models.CSP.CRS.Receivers;
model Basic_Heater
  extends Interfaces.Models.Electric_Heater;
  //Medium.BaseProperties medium;
  //Medium.BaseProperties medium_out;
  //Medium.BaseProperties medium_in; //new
  parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290);
  parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565);
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold fluid thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Cold fluid thermodynamic state at design";
  parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold fluid specific enthalpy at design";  
  parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Cold fluid specific enthalpy at design";
  
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out(start=h_hot_set);
  //SI.MassFlowRate m_flow;

  //parameter SI.HeatFlowRate Q_des_blk = 200.0e6 "Power block design heat input rate, also defocus power";
  //SI.HeatFlowRate Q_loss;
  //SI.HeatFlowRate Q_rad;
  //SI.HeatFlowRate Q_conv;
  
  //New
  //SI.Temperature T_4avg "Power 4 average of inlet and outlet (K)";
  //SI.Temperature T_avg "Linear average of inlet and outlet (K)";
  //End New
  
  SI.HeatFlowRate Q_in "Heating rate after curtailment";
  SI.HeatFlowRate Q_in_raw "Actual heating rate";
        
  Modelica.Blocks.Interfaces.RealInput Q_curtail "Required defocus heat rate" annotation (Placement(
        visible = true,transformation(
        
        origin={44,84},extent={{-12,-12},{12,12}},
        rotation=-90), iconTransformation(
        
        origin={-112, -52},extent={{12, -12}, {-12, 12}},
        rotation=180)));
    
  Modelica.Blocks.Interfaces.RealOutput Q_heater_raw annotation(
    Placement(visible = true, transformation(origin = {108, 2}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {111, 67}, extent = {{11, -11}, {-11, 11}}, rotation = 180)));

  Modelica.Blocks.Interfaces.BooleanInput curtail annotation (Placement(
        visible = true,transformation(extent = {{-126, -88}, {-86, -48}}, rotation = 0),iconTransformation(extent = {{-124, -94}, {-100, -70}}, rotation = 0)));
        
  //parameter SI.Area A_recv "Area of receiver";
  //parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
  //parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  //parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
  //parameter SI.Temperature T_max=from_degC(700) "Target outlet temperature";
  //parameter SI.CoefficientOfHeatTransfer h_conv=20.0 "Convective loss coefficient (W/m2K)";

  //SI.Temperature T_in;
  //SI.Temperature T_out;
  //parameter SI.SpecificEnthalpy h_out_ref = Medium.specificEnthalpy(Medium.setState_pTX(1e5,T_max));

//algorithm
  //T_4avg := (0.20*(T_in^4 + (T_in^3)*(T_out) + (T_in^2)*(T_out^2) + (T_in)*(T_out^3) + T_out^4))^0.25;
  //T_avg := 0.5*(T_in+T_out);
  
equation
  
  fluid_a.m_flow + fluid_b.m_flow = 0.0;
  fluid_a.p = fluid_b.p;
  //heat.T=0.5*(T_cold_set+T_hot_set);
  
  h_in=inStream(fluid_a.h_outflow);

  fluid_a.h_outflow = h_in;
  fluid_b.h_outflow = h_out;
  
  Q_heater_raw = Q_in_raw;
  Q_in_raw = P_supply;

  if fluid_a.m_flow > 1e-6 then
    Q_in = (if curtail == true then min(Q_in_raw,Q_curtail) else Q_in_raw);
    h_out = h_in + Q_in/fluid_a.m_flow;

  else
    Q_in = 0.0;
    h_out = h_hot_set;

  end if;

  //medium_in.h = h_in;
  //T_in = medium_in.T;
  //T_out = medium_out.T;
  //medium_in.p = fluid_a.p;
  
  //medium.h=0.5*(h_in+h_out);
  
  //New
  //T_4avg = (0.20*(T_in^4 + (T_in^3)*(T_out) + (T_in^2)*(T_out^2) + (T_in)*(T_out^3) + T_out^4))^0.25;
  //T_avg = 0.5*(T_in+T_out);
  //Q_rad = A_recv*sigma*em*((T_4avg^4)-(Tamb^4));
  //Q_conv = A_recv*h_conv*(T_avg-Tamb);
  //End New
  
  //Q_rad = A_recv*sigma*em*((medium.T^4)-(Tamb^4));
  //Q_conv = A_recv*h_conv*(medium.T-Tamb);
  

  
  //Q_rcv_raw = ab*heat.Q_flow-Q_rad-Q_conv; //Theoretical net receiver output before curtailment
  

  
  //medium_out.h = h_out;
  //medium_out.p = medium.p;
  annotation (Documentation(info = "<html>
</html>", revisions = "<html>
<ul>
<li>by Zebedee Kee, Receiver used in Packed Bed Storage Annual System Model. Only Radiative Losses. </li>
</ul>
</html>"),
    Icon(graphics = {Line(origin = {-60, -2}, points = {{-40, 0}, {40, 0}}, thickness = 0.5), Line(origin = {-76, -42}, points = {{-24, -40}, {24, -40}, {24, 40}}, color = {255, 0, 255}, thickness = 0.5), Line(origin = {-76, -27}, points = {{-24, -25}, {24, -25}, {24, 25}}, thickness = 0.5)}));
end Basic_Heater;