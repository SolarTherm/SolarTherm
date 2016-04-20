within SolarTherm.PowerBlocks;
model GenericParasitics "Generic parasitics model"
 import SI = Modelica.SIunits;

 parameter SI.Power P_par_des "Parasitic power at design";
 parameter SI.Power P_gross_des "Gross power at design";
 parameter SI.Temperature T_amb_des "Design point ambient temperature";

 parameter Real cf[:] "Fraction operation factor coefficients";
 parameter Real ca[:] "Ambient temperature factor coefficients";

 input SI.Power P_gen "Gross power generated";
 input SolarTherm.Interfaces.WeatherBus wbus;
 output SI.Power P_par "Electrical parasitic losses";
protected
 SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
 SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
equation
 fac_fra.x = P_gen/P_gross_des;
 fac_amb.x = wbus.Tdry - T_amb_des;
 P_par = P_par_des*fac_fra.y*fac_amb.y;
end GenericParasitics;
