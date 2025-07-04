within SolarTherm.Calculators;

model Interpolate_ThermalConductivity
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;

  //This script was written to linearly interpolate the thermal conductivity of 0% porosity sintered mullite 3Al2O3.2SiO2

  
  parameter SI.Temperature T_data_3[8] = {373.15, 473.15, 673.15, 873.15, 1073.15, 1273.15, 1473.15, 1673.15};
  
  parameter SI.ThermalConductivity k_data_3[8] = {6.0668, 5.4392, 4.6024, 4.184, 3.9748, 3.7656, 3.7656, 3.7656};


  
  SI.Temperature T(start=298.15);
  SI.ThermalConductivity k;

  
equation
  T = max(298.15,290.0+time*10.0);
  k = (1.0-0.00)*Modelica.Math.Vectors.interpolate(T_data_3,k_data_3,T);
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 141, StartTime = 0, Tolerance = 1.0e-5, Interval = 1, maxStepSize = 1, initialStepSize = 1));
end Interpolate_ThermalConductivity;