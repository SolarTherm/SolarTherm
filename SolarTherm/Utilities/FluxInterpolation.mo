within SolarTherm.Utilities;
function FluxInterpolation
	extends Modelica.Icons.Function;
	input Real nu_52;
	input Real nu_76;
	input Real nu_100;
	input Real nu_124;
	input Real ele;
	input Real dni;
	input Real ele_min;
	output Real result;

protected
	Real cons1 = 0.56;
	Real cons2 = 0.87;
	Real cons3 = 1.0;
	Real cons4 = 1.39;
	Real x = 1;
	Real dni_clear = 1;
	
algorithm
	if ele > ele_min then
		dni_clear:=1363*0.7^((1./cos(0.5*pi-ele))^0.678);
		x:=dni/dni_clear;
		if x >= cons4 then
			result := nu_124;
		elseif x >= cons3 and x<cons4 then
			result := nu_100+(x-cons3)/(cons4-cons3)*(nu_124-nu_100);
		elseif x >= cons2 and x<cons3 then
			result := nu_76+(x-cons2)/(cons3-cons2)*(nu_100-nu_76);
		elseif x >= cons1 and x<cons2 then
			result := nu_52+(x-cons1)/(cons2-cons1)*(nu_76-nu_52);
		elseif x < cons1 then
			result := x/cons1*nu_52;
		end if;
	else
		dni_clear:=dni;
		x:=0;
		result := 0;
	end if;
end FluxInterpolation;
