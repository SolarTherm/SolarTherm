within SolarTherm.Calculators;

model Plot_Material_Properties2
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;
  
  //Inputs
  package Filler_Package = SolarTherm.Materials.Examples.PCM1050_Broad40K "Declare Filler Package"; //SolarTherm.Materials.Aluminium
  parameter SI.Temperature T_min = 25.0 + 273.15 "Starting temperature (K)"; //25 + 273.15
  parameter SI.Temperature T_max = 1500.0 + 273.15 "Ending temperature (K)"; //1100 + 273.15
  //parameter Integer N = 1000 "Number of enthalpy divisions to sweep (-)";
  
  //Test h_Tf and rho_Tf calculation functions"
  parameter SI.Temperature T_sample = 1050 "Sample-point temperature (K)"; //933.47
  parameter Real f_sample = 0.75 "Mass liquid fraction of sample (-)";
  
  //Derived parameters
  parameter SI.SpecificEnthalpy h_min = Filler_Package.h_Tf(T_min,0.0) "Starting enthalpy (J/kg)";
  parameter SI.SpecificEnthalpy h_max = Filler_Package.h_Tf(T_max,1.0) "Ending enthalpy (J/kg)";
  parameter SI.SpecificEnthalpy der_h = (h_max-h_min) "Enthalpy range (J/kg)";
  
  //Parameter values used to check h_Tf and rho_Tf
  parameter SI.SpecificEnthalpy h_sample = Filler_Package.h_Tf(T_sample, f_sample);
  parameter SI.Density rho_sample = Filler_Package.rho_Tf(T_sample, f_sample);
  
  //Unit Cost at year 2022
  //parameter Real unit_cost = Filler_Package.cost;
  //parameter Real filler_year = Filler_Package.year;
  parameter Real unit_cost_2022 = SolarTherm.Utilities.Finances.r_CEPCI(2022,Filler_Package.year)*Filler_Package.cost;
  
  parameter Real unit_cost_2022_AUD = unit_cost_2022*SolarTherm.Utilities.Finances.Currency.USD_to_AUD_rate(2022);
  
  //Initialise Filler State Model
  Filler_Package.State filler; 
  SI.SpecificEnthalpy h(start = h_min);
  
initial equation
  filler.h = h_min;
  
equation
  filler.h = h;

  der(h) = der_h;
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 1, StartTime = 0, Tolerance = 1.0e-5, Interval = 0.001, maxStepSize = 1, initialStepSize = 1));
end Plot_Material_Properties2;