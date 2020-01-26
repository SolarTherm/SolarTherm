within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function dT_dh_h "Derivative of temperature of Chloride Salt w.r.t specific enthalpy"
	extends Modelica.Icons.Function;
	import SolarTherm.Media.SolidParticles.CarboHSP_utilities.*;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Real dT "Derivative of temperature w.r.t specific enthalpy";
protected
	Modelica.SIunits.Temperature T;
algorithm
	T:=T_h(h);
	dT := 1 / dh_dT_T(T);
end dT_dh_h;
