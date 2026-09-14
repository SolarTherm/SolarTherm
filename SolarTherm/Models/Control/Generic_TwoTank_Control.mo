within SolarTherm.Models.Control;
model Generic_TwoTank_Control
  extends Icons.Control;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;
  
  //Temperature Threshold Settings
  parameter SI.Temperature T_heater_out_des = 574.0 + 273.15 "Design heater outlet temperature (K)";
  parameter SI.Temperature T_output_des = 495.0 + 273.15 "Design output temperature of the system, blended down to this temperature if needed (K)";
  parameter SI.Temperature T_return_des = 300.0 + 273.15 "Cold return temperature back into the system (K)";
  //Design Mass flow rate of fluid at T_output_des
  parameter SI.MassFlowRate m_flow_output_des = 100.0 "Reference HTF mass flow rate to the boiler at the target enthalpy";
  parameter SI.Pressure p_des = 101325.0 "Design pressure (Pa)";
  
  //Level Thresholds
  parameter Real Level_hot_max = 0.92 "Maximum allowed level of the hot tank, in decimal form (-)";
  parameter Real Level_hot_chg_start = 0.91 "Level of the hot tank below-which charging of the TES can start, in decimal form (-)";
  
  parameter Real Level_hot_dis_start = 0.08 "Level of the hot tank above-which discharging of the TES can start, in decimal form (-)";
  parameter Real Level_hot_min = 0.07 "Minimum allowed level of the hot tank, in decimal form (-)";
  
  
  //Derived Parameters
  parameter SI.SpecificEnthalpy h_return_des = Medium.specificEnthalpy(Medium.setState_pTX(p_des, T_return_des)) "Specific enthalpy of the cold return fluid stream (J/kg)";
  parameter SI.SpecificEnthalpy h_heater_out_des = Medium.specificEnthalpy(Medium.setState_pTX(p_des, T_heater_out_des)) "Specific enthalpy of the heater output at design temperature (J/kg)";
  parameter SI.SpecificEnthalpy h_output_des = Medium.specificEnthalpy(Medium.setState_pTX(p_des, T_output_des)) "Specific enthalpy of the system output at design temperature (J/kg)";
  
  parameter SI.HeatFlowRate Q_flow_output_des = m_flow_output_des*(h_output_des-h_return_des) "System design output heat flow rate (J/s)";
  
  //Integer Flow_State(start = 0) "Representation of uncurtailed heater output"; //0 if heater < 0, 1 if heater between 0 and boiler, 2 if heater greater than boiler.
  Integer Control_State(start = 6) "1-6 Determines which pumps are operational and whether curtailment is on";
  Boolean Chg(start = true) "Can the storage be charged?";
  Boolean Dis(start = true) "Can the storage be discharged based on temperature?";
  Boolean Output(start = true) "Is the system allowed to supply output heat?";

  SI.MassFlowRate m_flow_heater_raw(start=0.0) "Guess required flow rate of recv";
  SI.MassFlowRate m_flow_output_dem = m_flow_output_des * Q_flow_demand / Q_flow_output_des "Instantaneous demand mass flow rate at design enthalpy (kg/s)";
  SI.MassFlowRate m_flow_output_def = m_flow_output_dem * (h_output_des - h_return_des)/(h_tank_hot - h_return_des) "Instantaneous heater mass flow rate if it was constrained to exactly match the system output mass flow rate (kg/s)";
  parameter SI.Time t_wait = 1.0*3600 "Waiting time between turning off Output and being able to turn on";
  SI.Time t_threshold(start=0.0) "if time passes this value, Output := true";

  parameter SI.MassFlowRate m_flow_0 = 1e-8 "Minimum mass flow rate through any pipe";
  parameter SI.MassFlowRate m_flow_min = 1e-8 "minimum mass flow rate to start"; //used to be 1e-7 for both
  parameter SI.MassFlowRate m_flow_tol = 0.001 * m_flow_output_des "Hysteresis tolerance of 0.1% of design Output mass flow rate used for the controller";
  
  Modelica.Blocks.Interfaces.RealInput Level_hot "Storage level of the hot tank"
    annotation (Placement(visible = true, transformation(extent = {{-126, -20}, {-86, 20}}, rotation = 0), iconTransformation(extent = {{-126, -8}, {-86, 32}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput Q_flow_heater_raw "The net receiver heat rate before curtailment"
    annotation (Placement(visible = true, transformation(extent = {{-124, 22}, {-84, 62}}, rotation = 0), iconTransformation(extent = {{-126, 48}, {-86, 88}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput h_tank_hot "Enthalpy of the HTF in the hot tank"
    annotation (Placement(visible = true, transformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0), iconTransformation(origin = {-40, 112},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.RealInput h_tank_cold "Enthalpy of the HTF in the cold tank"
    annotation (Placement(visible = true, transformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0), iconTransformation(origin = {16, 112},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    
  Modelica.Blocks.Interfaces.RealInput Q_flow_demand "Input signal from the scheduler stating the heat-rate demanded by the boiler (W)" annotation(
    Placement(visible = true, transformation(extent = {{-124, -102}, {-84, -62}}, rotation = 0), iconTransformation(origin = {70, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
    
  Modelica.Blocks.Interfaces.RealOutput m_flow_output_signal(start=0.0) "Power block mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, -12}, {130, 28}}, rotation = 0))) ;
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_heater_signal(start=0.0) "Receiver mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, 38}, {130, 78}}, rotation = 0))) ;
  
  Modelica.Blocks.Interfaces.RealOutput Q_flow_curtail(start = Q_flow_output_des) "Required defocus heat" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(origin = {-108, -90},extent = {{-20, -20}, {20, 20}}, rotation = 180))) ;
  
  Modelica.Blocks.Interfaces.BooleanOutput defocus(start=false) "defocus receiver?" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, -60}, {130, -20}}, rotation = 0))) ;
  /*
initial algorithm

  if m_flow_heater_raw > m_flow_tol then
    if m_flow_heater_raw < m_flow_output_dem + m_flow_tol then
      Flow_State := 1;
    else
      Flow_State := 2;
    end if;
  else
    Flow_State := 0;
  end if;
*/
algorithm
  when Level_hot < Level_hot_min then 
    Dis := false;
  elsewhen Level_hot > Level_hot_dis_start then 
    Dis := true;
  end when;
  
  when Level_hot > Level_hot_max then 
    Chg := false;
  elsewhen Level_hot < Level_hot_chg_start then
    Chg := true;
  end when;

  when m_flow_output_signal <= 0.1*m_flow_output_des then //take this as shutdown
    Output := false; //start the cooldown
    t_threshold := time + t_wait;
  end when;
  when time > t_threshold then
    Output := true;
  end when;
  
  //System Flow State Control
  /*
  when m_flow_heater_raw > m_flow_tol then
    if m_flow_heater_raw < m_flow_output_dem + m_flow_tol then
      Flow_State := 1;
    else
      Flow_State := 2;
    end if;
  end when;
//no overshoot
//overshot
  when m_flow_heater_raw < m_flow_min then
    Flow_State := 0;
  end when;
  when m_flow_heater_raw > m_flow_output_def + m_flow_tol then
    Flow_State := 2;
  end when;
  when m_flow_heater_raw < m_flow_output_def then
    if m_flow_heater_raw > m_flow_tol then
      Flow_State := 1;
    else
      Flow_State := 0;
    end if;
  end when;
  */
equation
  //m_flow_heater_raw = Q_flow_heater_raw/(h_heater_out_des-max(h_tank_cold,h_Output_outlet));
  m_flow_heater_raw = Q_flow_heater_raw/(h_heater_out_des-h_tank_cold);
  //if Flow_State == 0 then
  if m_flow_heater_raw <= m_flow_min then
    if Dis == true and Output == true then
      Control_State = 4;
    else
      Control_State = 6;
    end if;
  //elseif Flow_State == 1 then
    elseif m_flow_heater_raw > m_flow_min and m_flow_heater_raw < m_flow_output_def then
    if Dis == true and Output == true then
      Control_State = 2;
    elseif Chg == true and Dis == false then
      Control_State = 5;
    else
      Control_State = 6;
    end if;
  else
    if Chg == true and Output == true then
      Control_State = 1;
    elseif Chg == false and Output == true then
      Control_State = 3;
    else
      Control_State = 6;
    end if;
  end if;

  if Control_State == 1 then
    m_flow_heater_signal = max(m_flow_0,m_flow_heater_raw);
    m_flow_output_signal = m_flow_output_def;
    defocus = false;
    Q_flow_curtail = Q_flow_output_des; //Not used anyway
    
  elseif Control_State == 2 then
    m_flow_heater_signal = max(m_flow_0,m_flow_heater_raw);
    m_flow_output_signal = m_flow_output_def;
    defocus = false;
    Q_flow_curtail = Q_flow_output_des; //Not used anyway

  elseif Control_State == 3 then
    m_flow_heater_signal = m_flow_output_def;
    m_flow_output_signal = m_flow_output_def;
    defocus = true;
    Q_flow_curtail = m_flow_output_def*(h_heater_out_des-h_tank_cold); //Mass flows need to match

  elseif Control_State == 4 then
    m_flow_heater_signal = m_flow_0;//0.0;
    m_flow_output_signal = m_flow_output_def; //whoops I switched these by mistake
    defocus = false;
    Q_flow_curtail = Q_flow_output_des; //Not used anyway

  elseif Control_State == 5 then
    m_flow_heater_signal = max(m_flow_0,m_flow_heater_raw);
    m_flow_output_signal = m_flow_0;//0.0;
    defocus = false;
    Q_flow_curtail = Q_flow_output_des; //Not used anyway

  else
    m_flow_heater_signal = m_flow_0;
    m_flow_output_signal = m_flow_0;
    defocus = false;
    Q_flow_curtail = Q_flow_output_des; //Not used anyway
  end if;
//Additional info about control states:
//1 = Recv is on, only charges the storage. Output is off.
//2 = Output is on, and only run by discharging the Storage. Recv is off.
//3 = Output is run only from receiver, storage is completely bypassed, receiver is defocused to exactly balance mass flows of recv and Output, obeying also the target receiver outlet temperature.
//4 = Output is on, and run by combining receiver outlet with a Storage discharge stream.
//5 = Receiver is on, and its outlet stream splits to charge the Storage and run the Output.
//6 = Everything is off.
  annotation(Documentation(revisions = "<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>", info = "<html>
		<p>This component determines the mass flow rates of both the receiver and power block mass flow rates. The variable m_flow_heater_raw calculates the required receiver mass flow to achieve target outlet temperature T_target based on inlet enthalpy from either storage bottom outlet, system output outlet or a combination of both. Depending on whether the storage is allowed to charge, discharge and relative size of m_flow_heater_raw wrt minimum flowrate and Output design flowrate, one of the 6 operating states is chosen.</p>
		</html>"),
    Icon(graphics = {Text(origin = {-4, 8}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name")}));
end Generic_TwoTank_Control;