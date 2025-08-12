within SolarTherm.Media.DowthermA.DowthermA_ph_utilities;

function s_T "Specific entropy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.Temperature T "Temperature (K)";
	output Modelica.SIunits.SpecificEntropy s "Specific entropy (J/kgK)";
  algorithm
	s := Modelica.Math.Vectors.interpolate(T_table,s_table,T);
  end s_T;