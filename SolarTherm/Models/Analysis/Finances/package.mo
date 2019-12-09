within SolarTherm.Models.Analysis;
package Finances 

// For each component should have a capital cost and a maintenance cost
// per year.

//block AverageEnergy "Average energy produced per year"
//	import SI = Modelica.SIunits;
//	input SI.Power P "Power produced";
//	output EnergyPerYear epy "Energy per year";
//protected
//	SI.Energy E "Energy produced";
//	parameter SI.Time t_start(fixed=false) "Start time";
//	//SI.Time t_end "End time";
//	// There are terminal() and initial() events
//initial equation
//	E = 0;
//	t_start = time;
//equation
//	der(E) = P;
//	epy = (365*24*3600)*E/(time - t_start);
//end AverageEnergy;
//
//model LCOE
//	import SI = Modelica.SIunits;
//	parameter Money C_cap "Capital investment";
//	parameter Money C_main "Maintenance cost (per year)";
//	parameter Real r(min=0, max=1) "Discount factor";
//	parameter Integer t(min=1, unit="year") "Number of years";
//	input EnergyPerYear epy "Energy produced per year";
//	output EnergyPrice price "LCOE";
//protected
//	Money nu "Numerator";
//	SI.Energy de "Denominator";
//algorithm
//	nu := 0;
//	de := 0;
//
//	nu := nu + C_cap/(1 + r)^1;
//	for i in 1:t loop
//		nu := nu + C_main/((1 + r)^i);
//		de := de + epy/((1 + r)^i);
//	end for;
//
//	price := nu/de;
//end LCOE;
//
//model CapacityFactor
//	import SI = Modelica.SIunits;
//	parameter SI.Power P_rate "Rated Power";
//	input EnergyPerYear epy "Power output";
//	output Real factor;
//equation
//	factor = epy/(P_rate*365*24*3600);
//end CapacityFactor;

end Finances;
