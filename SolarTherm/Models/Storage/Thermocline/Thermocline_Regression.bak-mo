within SolarTherm.Models.Storage.Thermocline;

model Thermocline_Regression
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  //Curve-Fit Parameters
  parameter Real L_charge_flat = 0.568378;
  parameter Real L_discharge_flat = 0.638798;
  parameter Real A = 3.9309;
  parameter Real B = -14.2881;
  parameter Real C = 23.3269;
  parameter Real D = -12.7636;
  parameter Real E = 0.3518;
  parameter Real F = 4.1959;
  parameter Real G = -8.9110;
  parameter Real H = 6.1972;
  
  
  
  //parameter Medium.AbsolutePressure p_amb = 101325;
  // Storage
  //replaceable package Storage = SolarTherm.Materials.Graphite "the storage medium";
  parameter Modelica.SIunits.Temperature T_min = 500 + 273.15 "start temperature of the storage medium";
  parameter Modelica.SIunits.Temperature T_max = 720 + 273.15 "the maximum temperature of the storage medium";
  parameter Modelica.SIunits.Temperature h_max = Fluid_Package.h_Tf(T_max, 1.0) "the maximum enthalpy of the storage medium";
  parameter Modelica.SIunits.Temperature h_min = Fluid_Package.h_Tf(T_min, 0.0) "the initial enthalpy of the storage medium";
  //parameter Modelica.SIunits.Mass m_st=E_max/(h_max - h_0) "total mass of the storage medium";
  parameter Modelica.SIunits.Energy E_max;
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation(
    Placement(visible = true, transformation(origin = {48, 8.88178e-16}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {46, 0}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  //Modelica.SIunits.Temperature T_st"tempaerture of the storage medium";
  //Modelica.SIunits.SpecificEnthalpy h_st "enthlpy of the sotrage medium";
  // HTF
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "heat transfer medium";
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium_Table "fluid material package";
  Modelica.SIunits.Temperature T_in;
  Modelica.SIunits.Temperature T_out;
  Modelica.SIunits.SpecificEnthalpy h_in;
  Modelica.SIunits.SpecificEnthalpy h_out;
  Fluid_Package.State fluid_in "Property calculation of inlet";
  Fluid_Package.State fluid_out "Property calculation of outlet";
  // energy balance
  Modelica.SIunits.MassFlowRate m_flow "mass flow with respect to height direction";
  Modelica.SIunits.Energy E_stored(start = L_start * E_max);
  //Real e_out "outlet effectiveness";
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-35, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Level "Storage Level NonDimensional" annotation(
    Placement(visible = true, transformation(origin = {-41, 49}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-48, 0}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  //Regression Modelica
  parameter Real L_start = 0.1900 "Starting storage level";
  Real L(start = L_start) "Tank Level";
  Real e_out "Nondimensional outlet temperature/effectiveness";
  //Real e_top "Nondimensional top temperature/effectiveness";
  Real e_bot "Nondimensional bot temperature/effectiveness if it were to flow out of bottom";
equation
//Theoretical bottom outlet effectiveness
    if L > L_charge_flat then //curve region
      e_bot = min(1.0, A + B*L + C*(L^2) + D*(L^3) );
    else //flat region
      e_bot = 1.00;
    end if;
//effectiveness calculations
  m_flow = -1.0*fluid_a.m_flow; 
  if m_flow > 0.0 then //flowing upwards so discharge
    h_in = inStream(fluid_b.h_outflow);
    fluid_b.h_outflow = h_in;
    fluid_a.h_outflow = h_out;
    der(E_stored) = m_flow*(inStream(fluid_b.h_outflow)-fluid_a.h_outflow);

    //8h discharge
    if L < L_discharge_flat then //curve region
      e_out = min(1.0, E + F*L + G*(L^2) + H*(L^3) );
    else //flat region
      e_out = 1.00;
    end if;
    
    T_out = T_min + e_out*(T_max-T_min);
    h_bot_outlet = h_min;
    //h_bot_outlet = Fluid_Package.h_Tf(T_max - e_bot*(T_max-T_min), 0.0);
  else //fluid flowing downwards so charging
    h_in = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = h_in;
    fluid_b.h_outflow = h_out;
    der(E_stored) = -1.0*m_flow*(inStream(fluid_a.h_outflow)-fluid_b.h_outflow);
    
    e_out = e_bot;
    
    T_out = T_max - e_out*(T_max-T_min);
    //h_bot_outlet = h_out;
    h_bot_outlet = Fluid_Package.h_Tf(T_out, 0.0);
  end if;
  //try constant e_out
  //e_out = 0.99;
  
  
  L = E_stored/E_max;
  Level = L;
  
  fluid_in.h = h_in;
  T_in = fluid_in.T;
  
  fluid_out.T = T_out;
  h_out = fluid_out.h;
  
  fluid_a.m_flow + fluid_b.m_flow = 0;
  
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;

  annotation(
    Icon(graphics = {Text(origin = {1, 4}, extent = {{-27, 32}, {27, -32}}, textString = "Reg")}));
end Thermocline_Regression;