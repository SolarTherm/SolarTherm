within SolarTherm.Models.Control;

model Generic_Thermocline_Control
  extends Icons.Control;
  
  //Define the HTF media
  replaceable package Medium = SolarTherm.Media.Air.Air_amb_p;
  
  //Input threshold parameters
  parameter SI.Temperature T_heater_out_des = 450.0 + 273.15 "Design heater outlet temperature (K)";
  parameter SI.Temperature T_top_dis_start = 425.0 + 273.15 "TES hot temperature whereby discharge can be started (K)";
  parameter SI.Temperature T_output_des = 400.0 + 273.15 "Design output temperature of the system, blended down to this temperature if needed (K)";
  parameter SI.Temperature T_bot_chg_max = 200.0 + 273.15 "TES bottom temperature whereby charging is stopped (K)";
  parameter SI.Temperature T_bot_chg_start = 175.0 + 273.15 "TES bottom temperature whereby charging can be started (K)";
  parameter SI.Temperature T_return_des = 50.0 + 273.15 "Cold return temperature back into the system (K)";
  //Boiler design parameters
  parameter SI.MassFlowRate m_flow_output_des = 100.0 "Reference HTF mass flow rate to the boiler at the target enthalpy";
  parameter SI.Pressure p_des = 101325.0 "Design pressure (Pa)";
  
  //Derived Parameters
  parameter SI.SpecificEnthalpy h_return_des = Medium.specificEnthalpy(Medium.setState_pTX(p_des, T_return_des)) "Specific enthalpy of the cold return fluid stream (J/kg)";
  parameter SI.SpecificEnthalpy h_heater_out_des = Medium.specificEnthalpy(Medium.setState_pTX(p_des, T_heater_out_des)) "Specific enthalpy of the heater output at design temperature (J/kg)";
  parameter SI.SpecificEnthalpy h_output_des = Medium.specificEnthalpy(Medium.setState_pTX(p_des, T_output_des)) "Specific enthalpy of the system output at design temperature (J/kg)";
  
  parameter SI.HeatFlowRate Q_flow_output_des = m_flow_output_des*(h_output_des-h_return_des) "System design output heat flow rate (J/s)";
  
  //Mass flow rate parameters
  parameter SI.MassFlowRate m_flow_0 = 1e-8 "Minimum mass flow rate through any pipe";
  parameter SI.MassFlowRate m_flow_min = 1e-8 "minimum mass flow rate to start";
  //used to be 1e-7 for both
  parameter SI.MassFlowRate m_flow_tol = 0.001 * m_flow_output_des "Hysteresis tolerance of 0.1% of design PB mass flow rate used for the controller";
  //Storage control parameters
  parameter SI.Energy E_max = 12.0 * 3600.0 * 800.0e6 "Ideal storage capacity (J)";
  parameter SI.Time t_stor_cap = E_max / Q_flow_output_des "Just the ideal storage capacity in terms of seconds (s)";
  parameter Real level_mid = 0.50 "Midpoint storage level determined via component-level analysis.";
  parameter Real util_storage_des = 0.50 "Storage utilisation determined via component-level analysis.";
  parameter SI.Time t_stor_start_dis = 0.25 * 3600.0 "Minimum effective storage seconds accumulated that is needed to start discharge (s).";
  parameter Real L_start_dis = t_stor_start_dis / t_stor_cap + level_mid - 0.5 * util_storage_des "Tank level that corresponds to t_stor_start_dis being available";
  //Boiler timer. It needs to wait t_wait number of seconds before being turned on again
  parameter SI.Time t_wait = 1.0 * 3600 "Waiting time between turning off PB and being able to turn on";
  SI.Time t_threshold(start = 0.0) "if time passes this value, PB := true";
  //Relative flow magnitude State
  SI.MassFlowRate m_flow_heater_raw(start = 0.0) "Required mass flow rate of the heater assuming it is on and not curtailed.";
  SI.MassFlowRate m_flow_output_dem = m_flow_output_des * Q_flow_demand / Q_flow_output_des "Instantaneous boiler demand mass flow rate at design enthalpy (kg/s)";
  SI.MassFlowRate m_flow_output_def = m_flow_output_dem * (h_output_des - h_return_des)/(h_heater_out_des - h_return_des) "Instantaneous boiler demand mass flow rate if it was fed directly from the heater (kg/s)";
  Integer Flow_State(start = 0) "Representation of uncurtailed heater output"; //0 if heater < 0, 1 if heater between 0 and boiler, 2 if heater greater than boiler.
  Integer Control_State(start = 6) "1-6 Determines which pumps are operational and whether curtailment is on";
  Boolean Chg(start = true) "Can the storage be charged?";
  Boolean Dis(start = false) "Can the storage be discharged based on temperature?";
  Boolean Output(start = true) "Is the system allowed to supply output heat?";
  Modelica.Blocks.Interfaces.RealInput Level "Tank Storage Level 0-100" annotation(
    Placement(visible = true, transformation(extent = {{-124, 24}, {-84, 64}}, rotation = 0), iconTransformation(extent = {{-126, 6}, {-86, 46}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_tank_top "Temperature of the top of HTF in storage (K)" annotation(
    Placement(visible = true, transformation(extent = {{-124, -4}, {-84, 36}}, rotation = 0), iconTransformation(extent = {{-126, -36}, {-86, 4}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_tank_bot "Temperature of the bottom of HTF in storage (K)" annotation(
    Placement(visible = true, transformation(extent = {{-124, -30}, {-84, 10}}, rotation = 0), iconTransformation(extent = {{-126, -78}, {-86, -38}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_output_signal(start = 1.0e-8) "Signal output to the boiler loop pump (kg/s)." annotation(
    Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, -12}, {130, 28}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_heater_signal(start = 1.0e-8) "Signal output to the heater loop pump (kg/s)." annotation(
    Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, 38}, {130, 78}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_curtail(start = Q_flow_output_des) "Signal output to the heater stating the required curtailed heating rate (W)" annotation(
    Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(origin = {-108, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.BooleanOutput curtail(start = false) "Signal output to the heater stating the need for curtailment." annotation(
    Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, -60}, {130, -20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_flow_heater_raw "Input signal from the heater stating the available heating rate (W)" annotation(
    Placement(visible = true, transformation(extent = {{-124, 52}, {-84, 92}}, rotation = 0), iconTransformation(extent = {{-126, 48}, {-86, 88}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Q_flow_demand "Input signal from the scheduler stating the heat-rate demanded by the boiler (W)" annotation(
    Placement(visible = true, transformation(extent = {{-124, -102}, {-84, -62}}, rotation = 0), iconTransformation(origin = {70, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput h_demand_outlet "Cold outlet enthalpy from the boiler (J/kg)" annotation(
    Placement(visible = true, transformation(extent = {{-124, -54}, {-84, -14}}, rotation = 0), iconTransformation(origin = {14, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput h_tank_bot "Enthalpy of the HTF coming out of bottom of tank (J/kg)" annotation(
    Placement(visible = true, transformation(extent = {{-124, -78}, {-84, -38}}, rotation = 0), iconTransformation(origin = {-40, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput h_tank_top "Enthalpy of the HTF coming out of top of tank (J/kg)" annotation(
    Placement(visible = true, transformation(extent = {{-124, 80}, {-84, 120}}, rotation = 0), iconTransformation(origin = {-90, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
initial algorithm
//Just determine if the storage can be discharged right at the start of simulation.
  if Level <= L_start_dis then
    Dis := false;
  else
    Dis := true;
  end if;
  if m_flow_heater_raw > m_flow_tol then
    if m_flow_heater_raw < m_flow_output_dem + m_flow_tol then
      Flow_State := 1;
    else
      Flow_State := 2;
    end if;
  else
    Flow_State := 0;
  end if;
//no overshoot
//overshot
algorithm
//Discharge Control
  when Level > L_start_dis then
    if T_tank_top > T_top_dis_start then
      Dis := true;
    end if;
  end when;
  when T_tank_top > T_top_dis_start then
    if Level > L_start_dis then
      Dis := true;
    end if;
  end when;
  when T_tank_top < T_output_des then
    Dis := false;
  end when;
//Charge Control
  when T_tank_bot > T_bot_chg_max then
    Chg := false;
  elsewhen T_tank_bot < T_bot_chg_start then
    Chg := true;
  end when;
//Boiler Timer Control
  when m_flow_output_signal < 0.1 * m_flow_output_des then
    Output := false;
    t_threshold := time + t_wait;
  end when;
//take this as shutdown
//start the cooldown
  when time > t_threshold then
    Output := true;
  end when;
//System Flow State Control
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
//no overshoot
equation
  if Q_flow_heater_raw >= Q_flow_demand then
    m_flow_heater_raw = (Q_flow_heater_raw + m_flow_output_def * (h_demand_outlet - h_tank_bot)) / (h_heater_out_des - h_tank_bot);
  else
    m_flow_heater_raw = Q_flow_heater_raw / (h_heater_out_des - h_demand_outlet);
  end if;
  if Flow_State == 0 then
    if Dis == true then
      if Output == true then
        Control_State = 2;
      else
        Control_State = 6;
      end if;
    else
      Control_State = 6;
    end if;
  elseif Flow_State == 1 then
    if Dis == true then
      if Output == true then
        Control_State = 4;
      else
        Control_State = 1;
      end if;
    else
      if Chg == true then
        Control_State = 1;
      else
        Control_State = 6;
      end if;
    end if;
  else
//Flow_State == 2
    if Chg == true then
      if Output == true then
        Control_State = 5;
      else
        Control_State = 1;
      end if;
    else
      if Output == true then
        Control_State = 3;
      else
        Control_State = 6;
      end if;
    end if;
  end if;
  if Control_State == 1 then
    m_flow_heater_signal = max(m_flow_0, Q_flow_heater_raw / (h_heater_out_des - h_tank_bot));
    m_flow_output_signal = m_flow_0;
    curtail = false;
    Q_flow_curtail = Q_flow_output_des;
//Not used anyway
  elseif Control_State == 2 then
    m_flow_heater_signal = m_flow_0;
    m_flow_output_signal = max(m_flow_0, m_flow_output_def * (h_heater_out_des - h_demand_outlet) / (h_tank_top - h_demand_outlet));
    curtail = false;
    Q_flow_curtail = Q_flow_output_des;
//Not used anyway
  elseif Control_State == 3 then
    m_flow_heater_signal = max(m_flow_0, m_flow_output_def);
    m_flow_output_signal = max(m_flow_0, m_flow_output_def);
    curtail = true;
    Q_flow_curtail = m_flow_output_def * (h_heater_out_des - h_demand_outlet);
  elseif Control_State == 4 then
    m_flow_heater_signal = max(m_flow_0, Q_flow_heater_raw / (h_heater_out_des - h_demand_outlet));
    m_flow_output_signal = max(m_flow_0, (m_flow_heater_signal * (h_tank_top - h_heater_out_des) + m_flow_output_def * (h_heater_out_des - h_demand_outlet)) / (h_tank_top - h_demand_outlet));
    curtail = false;
    Q_flow_curtail = Q_flow_output_des;
//Not used anyway
  elseif Control_State == 5 then
    m_flow_heater_signal = max(m_flow_0, (Q_flow_heater_raw + m_flow_output_def * (h_demand_outlet - h_tank_bot)) / (h_heater_out_des - h_tank_bot));
    m_flow_output_signal = max(m_flow_0, m_flow_output_def);
    curtail = false;
    Q_flow_curtail = Q_flow_output_des;
//Not used anyway
  else
    m_flow_heater_signal = m_flow_0;
    m_flow_output_signal = m_flow_0;
    curtail = false;
    Q_flow_curtail = Q_flow_output_des;
//Not used anyway
  end if;
//Additional info about control states:
//1 = Recv is on, only charges the storage. PB is off.
//2 = PB is on, and only run by discharging the Storage. Recv is off.
//3 = PB is run only from receiver, storage is completely bypassed, receiver is defocused to exactly balance mass flows of recv and PB, obeying also the target receiver outlet temperature.
//4 = PB is on, and run by combining receiver outlet with a Storage discharge stream.
//5 = Receiver is on, and its outlet stream splits to charge the Storage and run the PB.
//6 = Everything is off.
  annotation(
    Documentation(revisions = "<html>
		<p>By Zebedee Kee on 03/12/2020</p>
		</html>", info = "<html>
		<p>This component determines the mass flow rates of both the receiver and power block mass flow rates. The variable m_flow_heater_raw calculates the required receiver mass flow to achieve target outlet temperature T_heater_out_des based on inlet enthalpy from either storage bottom outlet, PB outlet or a combination of both. Depending on whether the storage is allowed to charge, discharge and relative size of m_flow_heater_raw wrt minimum flowrate and PB design flowrate, one of the 6 operating states is chosen.</p>
		</html>"),
    Icon(graphics = {Text(origin = {-4, 8}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name")}));
end Generic_Thermocline_Control;