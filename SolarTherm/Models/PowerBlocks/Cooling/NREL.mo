within SolarTherm.Models.PowerBlocks.Cooling;
model NREL "sCO2 NREL Nieses SAM"
	extends Cooling;
	import Modelica.SIunits.Conversions.*;
	parameter SI.Temperature T_in_ref=720+273.15 "HTF inlet temperature at design" annotation (Dialog(enable=false,group="Design"));
	input SI.Temperature T_in "HTF inlet temperature";
	input Real load "Load fraction";
	parameter Real a =-0.4497189905;
	parameter Real b =-0.0003170942;
	parameter Real c = 0.606938568;
	parameter Real d = 0.0241420165;

equation
	nu_q=1;
//	nu_w=a + b*to_degC(T_in) + c*load + d*to_degC(T_amb);
	if load < 0.975 then
		nu_w = -0.0009*to_degC(T_in) + 0.9158*load + 0.0166*to_degC(T_amb);
	elseif load > 1.01 then
		nu_w = -0.2137*load + 0.0299*to_degC(T_amb);
	else
		nu_w = 0.0226*to_degC(T_amb);
	end if;

	annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end NREL;
