within SolarTherm.Models.Chemistry.Property_Tables.Mixtures;

record DowthermA_Liquid "Synthetic organic heat transfer fluid"
  constant Modelica.SIunits.Temperature T_table[7] = {298.15, 300.00, 350.00, 400.00, 450.00, 500.00, 530.25} "Absolute temperature (K)";
  
  constant Modelica.SIunits.SpecificEnthalpy h_table[7] = {0.00, 2940.10, 86099.29, 176340.69, 273588.77, 377789.99, 444192.83} "Specific enthalpy (J/kg)";
  
  constant Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_table[7] = {1586.60, 1591.89, 1734.48, 1875.18, 2014.74, 2153.31, 2236.96} "Specific heat capacity at constant pressure (J/kgK)";
  
  constant Modelica.SIunits.Density rho_table[7] = {1055.54, 1054.07, 1013.92, 971.95, 928.00, 881.31, 851.79} "Density (kg/m3)";
  
  constant Modelica.SIunits.ThermalConductivity k_table[7] = {0.1379, 0.1376, 0.1296, 0.1216, 0.1136, 0.1056, 0.1008} "Thermal conductivity (W/mK)";
  
  constant Modelica.SIunits.DynamicViscosity mu_table[7] = {0.004316, 0.004189, 0.001382, 0.000757, 0.000481, 0.000332, 0.000267} "Dynamic Viscosity (Pa.s)";
  
  constant Modelica.SIunits.SpecificEntropy s_table[7] = {0.00, 9.80, 246.00, 440.85, 607.98, 755.58, 837.70} "Specific Entropy (J/kgK)";

  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html><head></head><body><b>Assumptions:</b><div><br></div><div>Property tables rescaled to 298.15K, 300.00 - 500.0 K at 50 K intervals and 530.25 K via linear interpolation&nbsp;</div><div><br></div><div>The atmospheric boiling point of Dowtherm A is 257.1 degC or 530.25 K.</div><div><br></div><div>Specific enthalpy <i>h</i>&nbsp;is calculated w.r.t. 298.15 K and estimated via trapezium rule of <i>c_p</i>&nbsp;vs. <i>T.</i></div><div><i><br></i></div><div>Specific entropy <i>s</i>&nbsp;is estimated using the formula&nbsp;Δ<i>s</i>&nbsp;=&nbsp;Δ<i>h</i>&nbsp;/ T.<br><div><br></div><div><b>Reference:</b></div><div><br></div><div>https://www.dow.com/en-us/pdp.dowtherm-a-heat-transfer-fluid.238000z.html#tech-content</div></div></body></html>"));
end DowthermA_Liquid;