within SolarTherm.Models.Analysis;
model Performance "Energy performance calculations"
	import SI = Modelica.SIunits;
	parameter Boolean schedule = false;
	parameter String pri_file = "" "Electricity price file";

	parameter Boolean prices = (pri_file <> "");

	input SI.Power P_elec "Net output electricity";
	input SI.Power P_sch if schedule "Scheduled electricity";

	output SI.Energy E_elec "Generated electricity";
	output SolarTherm.Models.Analysis.Finances.Money R_spot "Spot market revenue";
	output SI.Energy E_sch "Energy scheduled";
	output SI.Energy E_under "Energy under schedule";
	output SI.Energy E_over "Energy over schedule";

	SolarTherm.Models.Analysis.Finances.SpotPriceTable pri(file=pri_file) if
	
		prices;
initial equation
	E_elec = 0;

	if prices then
		R_spot = 0;
	end if;

	if schedule then
		E_sch = 0;
		E_under = 0;
		E_over = 0;
	end if;
equation
	der(E_elec) = P_elec;

	if prices then
		der(R_spot) = P_elec*pri.price;
	else
		R_spot = 0;
	end if;

	if schedule then
	der(E_sch) = P_sch;
	der(E_under) = max(P_sch - P_elec, 0);
	der(E_over) = max(P_elec - P_sch, 0);
	else
		E_sch = 0;
		E_under = 0;
		E_over = 0;
	end if;
end Performance;
