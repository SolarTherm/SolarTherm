within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL "A sCO2 cycle regression model based on the table provided by Chad Agustine"
	extends Cycle;
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;

equation
//	k_w = 0.421643*(T_in/T_in_ref) + 0.934566*load - 0.00124385*T_amb;
//	k_q = 0.000442606*T_amb + 0.844403*load;
	if load > 0.9999 then
		if T_amb < 294.15 then
			k_q = max(0, 1.92783 - 0.945337*(T_in/T_in_ref));
			k_w = max(0, 1.00477*(T_in/T_in_ref));
		else
			k_q = max(0, -0.0295685*T_amb + 0.000236193*T_amb^2 - 4.2183e-7*T_amb^3);
			k_w = max(0, 0.628065*(T_in/T_in_ref) - 0.0520314*T_amb + 0.000370578*T_amb^2 - 6.42937e-7*T_amb^3);
		end if;
	else
		k_q = 0.000442606*T_amb + 0.844403*load;
		k_w = 0.421643*(T_in/T_in_ref) + 0.934566*load - 0.00124385*T_amb;
	end if;
end sCO2NREL;
