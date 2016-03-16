within SolarTherm.Utilities;
package Performance
import SI = Modelica.SIunits;

//P_sch = sched*P_rate;

model EnergyPerf "Energy performance calculations"
	parameter Boolean schedule = false;
	parameter String priFile = "" "Electricity price file";

	parameter Boolean prices = (priFile <> "");

	input SI.Power P_elec "Net output electricity";
	input SI.Power P_sch if schedule "Scheduled electricity";

	output SI.Energy E_elec "Generated electricity";
	output SolarTherm.Utilities.Finances.Money R_spot "Spot market revenue";
	output SI.Energy E_sch "Energy scheduled";
	output SI.Energy E_under "Energy under schedule";
	output SI.Energy E_over "Energy over schedule";

	SolarTherm.Utilities.Finances.SpotPriceTable pri(
		fileName=priFile
		) if prices;
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
end EnergyPerf;

end Performance;
