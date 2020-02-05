within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL "A sCO2 cycle regression model based on the table provided by Chad Agustine"
	extends Cycle;
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;

equation
	k_w = 0.421643*(T_in/T_in_ref) + 0.934566*load - 0.00124385*T_amb;
	k_q = 0.926722*(T_in/T_in_ref);
end sCO2NREL;
