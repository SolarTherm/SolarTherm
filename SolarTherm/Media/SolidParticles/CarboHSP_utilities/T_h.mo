within SolarTherm.Media.SolidParticles.CarboHSP_utilities;
function T_h "Temperature of solid CarboHSP 40/70 particle as a function of specific enthalpy"
	extends Modelica.Icons.Function;
	input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
	output Modelica.SIunits.Temperature T "Temperature";
protected
	constant Real a = 148.2;
	constant Real b = 0.3093;
	constant Real c = -196601.368854;

algorithm
	// Based on inverse function of h(T).
	// Philipe Gunawan = Make another function of T as a function of h and I found that T(h) = -e-10 * h^2 + 0.001*h + 310.62, I got it using plot in Excel with deviation calue R of 0.999
	// I bound the function to make it more robust and wont yield invalid root
    if h < c then
    T := 0;    
    else
	T := (((b+1)/a) * (h-c)) ^ (1.0/(b+1));
	//T:=-0.0000000001 * h^2 + 0.001*h + 310.62;
	//T:= 0.001*h + 310.62;
	end if;
	annotation(derivative=T_h_der);
end T_h;
