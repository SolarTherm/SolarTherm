within SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_utilities;
function T_h_der "Derivative of temperature of Chloride Salt w.r.t. time"
	import SolarTherm.Media.SolidParticles.CarboHSP_utilities.*;
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	input Real der_h "Derivative of specific enthalpy w.r.t. time";
	output Real der_T "Derivative of Temperature w.r.t. time";
algorithm
	der_T := dT_dh_h(h) * der_h;
end T_h_der;
