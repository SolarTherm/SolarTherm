within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function Haynes230_BaseProperties
  import SI = Modelica.SIunits;
  
  input SI.Temperature T "HX operating Temperature";
  output SI.ThermalConductivity k_wall "Tube Thermal Conductivity";
  output SI.Density rho_wall "HX material density";
  output Real YY(unit="GPa") "Young's Modulus";
  output SI.SpecificHeatCapacity cp_H230 "Specific Heat";
  
algorithm
  k_wall:= 0.01996*T + 2.981; //Interpolated from datasheet table in the temperature range 20-1000 °C
  rho_wall:=8970;
  YY:=0.0000000000005663*T^5 - 0.000000002271*T^4 + 0.000003446*T^3 - 0.002469*T^2 + 0.768*T + 124.8; //Interpolated from datasheet table in the temperature range 20-1000 °C
  cp_H230:=0.00000000000001913*T^6 - 0.0000000000899*T^5 + 0.000000167*T^4 - 0.0001557*T^3 + 0.07654*T^2 - 18.57*T + 2137; //Interpolated from datasheet table in the temperature range 20-1000 °C
  
end Haynes230_BaseProperties;
