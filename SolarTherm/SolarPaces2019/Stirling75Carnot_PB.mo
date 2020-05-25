within SolarTherm.SolarPaces2019;

model Stirling75Carnot_PB
  extends SolarTherm.SolarPaces2019.PowerBlockHeat;
  // Vary these parameters
  parameter Real startup_fraction = 0.5;
  parameter Boolean use_startup = false;
  parameter Real N = 40 "Number of Stirling Engines";
  parameter Boolean Fixed_TH = false "fixed expansion temperature or set";
  parameter Boolean Fixed_TC = false "fixed compression temperature or set";
  parameter SI.Temperature TH_set = 1073.0 "a set temperature which is optional";
  parameter SI.Temperature TC_set = 323.0 "a set temperature which is optional";
  parameter SI.TemperatureDifference delta_T = 0.0 "temperature difference between compression space and ambient";
  // OK Stop here
  parameter SI.HeatFlowRate W_net_des = N*25e3 "Maximum total net output of the engine array, anything above this will be curtailed";
  parameter SI.HeatFlowRate Q_des_each = 54.1266e3 "Design heat input when fully on, this is fixed" annotation(
    Dialog(group = "Design")); //Note for max power, 80989.1 Wth -> 27257.2 We (~24531.48 We,net); and for max efficiency 68503.7 Wth -> 24520.8 We (~22070 We,net)
  parameter Real W_base = 0.0055 * (W_net_des/0.9) "Power consumed at all times" annotation(
    Dialog(group = "Parasities energy losses"));

  //parameter Real B0 = 4.247e-2 "Beale 0' Coefficient";
  //parameter Real B1 = 1.682e-5 "Beale 1' Coefficient";
  //parameter Real B2 = -5.105e-10 "Beale 2' Coefficient";
  //parameter Real B3 = 7.07260e-15 "Beale 3' Coefficient";
  //parameter Real B4 = -3.586e-20 "Beale 4' Coefficient";

  //parameter Real p0 = 6.58769e-1 "Pressure 0' Coefficient";
  //parameter Real p1 = 2.34963e-4 "Pressure 1' Coefficient";

  //parameter SI.Volume V_swept = 3.8e-4 "Total volume swept by the piston(s)";
  //parameter SI.Frequency frequency = 30 "frequency of the engine, 1800 rpm is 30Hz";



  //Inputs
  Modelica.Blocks.Interfaces.RealInput load annotation(
    Placement(visible = true,transformation( origin = {-50, -30},extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation( origin = {-56, -40},extent = {{-6, -6}, {6, 6}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanInput startup annotation(
    Placement(visible = true,transformation( origin = {-50, -50},extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation( origin = {-56, -60},extent = {{-6, -6}, {6, 6}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput T_amb if enable_losses annotation(
    Placement(visible = true,transformation( origin = {68, 36},extent = {{-12, -12}, {12, 12}}, rotation = 180), iconTransformation( origin = {-20, 60},extent = {{-6, -6}, {6, 6}}, rotation = -90)));

  //Modelica.Blocks.Interfaces.RealInput TH "Temperature of the inlet" annotation(
    //Placement(visible = true,transformation( origin = {68, 36},extent = {{-12, -12}, {12, 12}}, rotation = 180), iconTransformation( origin = {-20, 60},extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  parameter Boolean enable_losses = false "= true enable thermal losses with environment" annotation(
    Dialog(group = "Assumptions"),
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));

  parameter Boolean external_parasities = false "= true enable parasities as an input" annotation(
    Dialog(group = "Parasities energy losses"),
    Evaluate = true,
    HideResult = true,
    choices(checkBox = true));
  parameter Real nu_net = 0.9 "Estimated gross to net conversion factor at the power block" annotation(
    Dialog(group = "Parasities energy losses"));



  //Heat calculations
  SI.HeatFlowRate Q_flow(min = 0, start = 0) "Heat input to the cycle";
  SI.HeatFlowRate Q_flow_each(min = 0, start = 0) "Heat input to each stirling engine";

  SI.HeatFlowRate W_loss "Parasitic losses power";

  //Beale Correlation Calculations
  SI.HeatFlowRate W_gross "Instantaneous gross power";
  //Real Beale (min = 0) "Beale Number";
  //Real p_engine (min = 0)"Engine pressure";
  Real nu_cycle (min = 0) "instantaneous cycle efficiency";

  //SI.HeatFlowRate W_net "Estimated net output at design";
  SI.Energy E_gross(final start = 0, fixed = true, displayUnit = "MWh");
  SI.Energy E_net(final start = 0, fixed = true, displayUnit = "MWh");
  Real pb_efficiency;
  Real cycle_efficiency;

  //Optional
  SI.Temperature TH;
  SI.HeatFlowRate W_gross_each "Gross power output of each engimne";
  SI.Temperature TH_internal;
  SI.Temperature TC_internal;
  //Boolean logic;
  Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, 82}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
protected
  Modelica.Blocks.Interfaces.RealInput parasities_internal;
  SI.Energy E_in;
  Modelica.Blocks.Interfaces.RealInput T_amb_internal;
  parameter Real nu_eps = 0.1;
  Boolean startup_internal;


equation
  if use_startup then
	connect(startup_internal,startup);
  else
	startup_internal = false;
  end if;
  if enable_losses then
    connect(T_amb_internal, T_amb);
  else
    T_amb_internal = T_des;
  end if;
  if external_parasities then
    connect(parasities_internal, parasities);
  else
    parasities_internal = 0;
  end if;
  if Fixed_TH then //fix the hot temperature
    TH_internal = TH_set;
  else
    TH_internal = TH;
  end if;
  if Fixed_TC then //fix the cold temperature
    TC_internal = TC_set + delta_T;
  else
    TC_internal = T_amb + delta_T;
  end if;

  //W_gross_each = Beale * p_engine * V_swept * frequency * (1.0-(TC_internal/TH_internal)^0.5); //Calculate gross work output
  //Beale = B0 + B1*(Q_flow_each) + B2*(Q_flow_each^2) + B3*(Q_flow_each^3) + B4*(Q_flow_each^4); //Calculate the Beale Number
  //p_engine = 1.0e6*(p0 + p1*Q_flow_each); //Calculate Mean engine pressure

  //W_gross_each = Q_flow_each*load*(1.0-(TC_internal/TH_internal)^0.5);
  

if startup == false then
  W_gross_each = Q_flow_each*(1.0-(TC_internal/TH_internal))*0.75;
  Q_flow_each = Q_des_each*load; //Heat input to each engine is at design point at 100% load
  Q_flow = N*Q_flow_each; //Total heat input to the engine array is number of engines x heat into each engine
  heat_a.Q_flow = Q_flow; //Matches the heat taken out of storage
  heat_a.T = TH; //Matches the temperature of storage

  if load > 0.1 then
    nu_cycle = W_gross_each/Q_flow_each; //determine efficiency
  else
    nu_cycle = 0.0;
  end if;
  
  W_gross = N*W_gross_each; //Total gross work output of the N engines
else
  W_gross_each = 0;
  Q_flow_each = Q_des_each*load*startup_fraction;
  Q_flow = N*Q_flow_each;
  heat_a.Q_flow = Q_flow; //Matches the heat taken out of storage
  heat_a.T = TH; //Matches the temperature of storage
  nu_cycle = 0.0;
  W_gross = 0.0; //Total gross work output of the N engines
end if;

  W_loss = (1 - nu_net) * W_gross + W_base + parasities_internal; //Losses are generator efficiency, base consumption and internal parasitics
  W_net = min(W_gross - W_loss,W_net_des); //Curtails anything above the design net rating to avoid CapF < 100%
  //Analytics
  der(E_in) = Q_flow;
  der(E_gross) = W_gross;
  der(E_net) = W_net;

  if E_in > 0 then
    pb_efficiency = max(0.0, E_net / E_in);
    cycle_efficiency = max(0.0, E_gross / E_in);
  else
    pb_efficiency = 0.0;
    cycle_efficiency = 0.0;
  end if;
  annotation(
    Dialog(group = "Design"));
end Stirling75Carnot_PB;