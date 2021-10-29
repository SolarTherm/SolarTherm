within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function Inconel800H_BaseProperties
  import SI = Modelica.SIunits;
  
  input SI.Temperature T "HX operating Temperature";
  output SI.ThermalConductivity k_wall "Tube Thermal Conductivity";
  output SI.Density rho_wall "HX material density";
  //output Real YY(unit="GPa") "Young's Modulus";
  
algorithm
  k_wall:=-0.000025*T^2 + 0.05816*T - 8.52; //Interpolated from datasheet table in the temperature range 600-800 °C
  rho_wall:=8030;
  //YY:=-0.06952*T+219.7;
  
end Inconel800H_BaseProperties;
