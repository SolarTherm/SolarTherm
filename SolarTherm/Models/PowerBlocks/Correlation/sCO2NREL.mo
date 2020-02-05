within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL "A sCO2 cycle regression model based on the table provided by Chad Agustine"
	extends Cycle;
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;

	parameter Real kw1 =-0.1513789898;
	parameter Real kw2 =0.0003187353;
	parameter Real kw3 = 0.932326715;
	parameter Real kw4 = -0.0012751285;
	parameter Real kw5 = 0;

	parameter Real kq1 =-0.4497189905;
	parameter Real kq2 =-0.0003170942;
	parameter Real kq3 = 0.606938568;
	parameter Real kq4 = 0.0241420165;
	parameter Real kq5 = 0;

equation
	k_q=kq1 + kq2*to_degC(T_in) + kq3*load + kq4*to_degC(T_amb) + kq5*T_in_ref;
	k_w=kw1 + kw2*to_degC(T_in) + kw3*load + kw4*to_degC(T_amb) + kw5*T_in_ref;
end sCO2NREL;
