within SolarTherm.Models.Storage.Tank;

model Direct_Tank
  extends Interfaces.Models.StorageFluid;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  //Input Parameters
  parameter SI.Volume V_tank = 5500.0 "Tank volume (m3)";
  parameter Real ar = 0.5 "Tank aspect ratio H/D (m/m)";
  parameter SI.CoefficientOfHeatTransfer U_loss = 0.4 "Overall heat loss coefficient of fluid to ambient (W/m2K)";
  parameter SI.Temperature T_des = 574.0 + 273.15 "Design fluid temperature (K)";
  parameter SI.Temperature T_set = 500.0 + 273.15 "Minimum temperature at which auxiliary heater is activated (K)";
  
  parameter SI.Temperature T_start = T_des "Starting temperature of the fluid in the tank (K)";
  parameter SI.Pressure p_start = 101325.0 "Starting pressure of the fluid in the tank (Pa)";
  
  parameter Real Level_start = 0.3 "Starting level of storage, in decimals (-)";

  parameter SI.Power P_heater_max = 30.0e8 "Maximum auxiliary heater electrical power (W)";
  parameter SI.Efficiency eff_heater = 0.99 "Efficiency of the auxiliary heater (-)";
  

  //Derived Parameters
  parameter SI.Length H_tank = (4.0 * V_tank * ar ^ 2.0 / CN.pi) ^ (1.0 / 3.0) "Tank height (m)";
  parameter SI.Length D_tank = (4.0 * V_tank * (ar * CN.pi)) ^ (1.0 / 3.0) "Tank diameter (m)";
  
  parameter SI.SpecificEnthalpy h_f_start = Medium.specificEnthalpy(state_i);
  parameter SI.Density rho_f_start = Medium.density(state_i);
  parameter SI.Mass m_f_start = rho_f_start * V_tank * Level_start;

  //Variables
  Medium.BaseProperties medium; //Property State Model
  parameter Medium.ThermodynamicState state_i = Medium.setState_pTX(p_start, T_start); //Initial state of the fluid
  
  SI.Area A_loss "Total cylindrical heat loss area (m2)";
  SI.Volume V_f "Volume of fluid in the tank (m3)" ;
  SI.Density rho_f "Density of fluid (kg/m3)";
  SI.Mass m_f(start = m_f_start) "Mass of fluid in the tank (kg)";
  SI.SpecificEnthalpy h_f(start = h_f_start) "Specific enthalpy of fluid in the tank (J/kg)";
  SI.HeatFlowRate Q_dot_loss "Heat loss rate from tank (J/s)";
  
  //Inlets and Outlets
  SI.SpecificEnthalpy h_in "Inlet specific enthalpy (J/kg)";
  SI.SpecificEnthalpy h_out "Outlet specific enthalpy (J/kg)";
  
  SI.MassFlowRate m_flow_in "Inlet mass flow rate (kg/s)";
  SI.MassFlowRate m_flow_out "Outlet mass flow rate (kg/s)";
  
  SI.HeatFlowRate der_m_f_h_f "Derivative of the product of mass and specific enthalpy (J/s)";
  
  //Fluid properties
  Modelica.Blocks.Interfaces.RealOutput h_fluid "Enthalpy of fluid" annotation(
    Placement(visible = true, transformation(origin = {107, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {102, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Modelica.Blocks.Interfaces.RealOutput T_measured "Temperature of the fluid in the tank (K)" annotation(
    //Placement(visible = true, transformation(extent = {{40, 50}, {60, 70}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  SI.Power W_dot_heater(start=0.0);
  SI.Power Q_dot_heater;
  
  Modelica.Blocks.Interfaces.RealOutput Level "Tank level in decimals 0-1" annotation(
    Placement(visible = true,transformation(extent = {{96, 44}, {116, 64}}, rotation = 0), iconTransformation(extent = {{92, 22}, {112, 42}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput p_amb annotation(
    Placement(transformation(extent = {{-16, -16}, {16, 16}}, rotation = -90, origin = {0, 108}), iconTransformation(extent = {{-11, -11}, {11, 11}}, rotation = -90, origin = {45, 97})));

  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(transformation(extent = {{-16, -16}, {16, 16}}, rotation = -90, origin = {0, 108}), iconTransformation(extent = {{-11, -11}, {11, 11}}, rotation = -90, origin = {-41, 97})));

algorithm
  der_m_f_h_f := m_flow_in*h_in - m_flow_out*h_out - Q_dot_loss + Q_dot_heater;
  when medium.T < T_set then
    W_dot_heater := P_heater_max;
  elsewhen medium.T > T_set + 1 then
    W_dot_heater := 0;
  end when;
  
equation
  medium.h = h_f;
  medium.p = p_amb;
  h_fluid = h_f;
  rho_f = medium.d;

  //T_measured = medium.T;

  fluid_b.p = p_amb;
  fluid_a.p = p_amb;
  
  h_in = inStream(fluid_a.h_outflow);
  h_out = h_fluid;
  
  m_flow_in = fluid_a.m_flow;
  m_flow_out = -1.0*fluid_b.m_flow;
  
  fluid_a.h_outflow = medium.h;
  fluid_b.h_outflow = medium.h;
  
  //Heat losses
  Q_dot_loss = U_loss*A_loss*(medium.T - T_amb);
  
  //Mass balance
  der(m_f) = m_flow_in - m_flow_out;
  
  //der_m_f_h_f = m_f*der(h_f)+h_f*der(m_f);
  der(m_f*h_f) = der_m_f_h_f;
  
  //Energy balance
  V_f = m_f/rho_f;
  A_loss = CN.pi*D_tank*H_tank*Level;
  
  Level = V_f/V_tank;
  
  Q_dot_heater = eff_heater*W_dot_heater;

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false), graphics = {Text(origin = {2, 10}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
  Documentation(info = "<html><head></head><body>Tank Model for Two-Tank Direct Storage Concept. Based on the Two-tank molten salt storage model in System Advisor Model (SAM) 2025.<div><br></div><div>SAM Settings:</div><div><br></div><div>For a 101.66 MWe (279.1 MWt) plant with 4 hours of storage:</div><div><br></div><div>TES thermal capacity = 1116.5 MWht</div><div>Available HTF volume = 5195 m3</div><div>Tank height = 12 m</div><div>Tank diameter = 24.5 m</div><div>Aspect ratio &nbsp;= 0.4898 (at 4 hours of storage)</div><div>Tank fluid min height = 1 m</div><div>Total HTF Volume = 5667 m3</div><div><br></div><div>Initial hot HTF percent = 30.0%</div><div>Wetted Loss Coefficient = 0.4 W/m2K</div><div>Estimated heat loss = 0.47 MWt</div><div><br></div><div>Hot Tank:</div><div>HTF hot temperature = 574.0 degC</div><div>HTF setpoint temperature = 500 degC</div><div>Hot tank heater capacity = 30 MWe</div><div><br></div><div>Cold Tank:</div><div>HTF cold temperature = 290.0 degC</div><div>HTF setpoint temperature = 280.0 degC</div><div>Cold tank heater capacity = 15 MWe</div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div></body></html>"));
end Direct_Tank;