within SolarTherm.Utilities;
package Finances

type Money = Real(unit="$");
type EnergyPrice = Real(unit="$/J");
type PowerPrice = Real(unit="$/W");

// For each component should have a capital cost and a maintenance cost
// per year.

function lcoe
	import SI = Modelica.SIunits;
	input Money C_cap "Capital investment";
	input Money C_main "Maintenance cost (per year)";
	input SI.Energy E_prod "Energy produced";
	input Real r(min=0, max=1) "Discount factor";
	input Integer t(min=1) "Number of years";
	output EnergyPrice price "LCOE";
protected
	input Money nu "Numerator";
	input Energy de "Denominator";
algorithm
	nu := 0;
	de := 0;

	nu := nu + C_cap/(1 + r)^1;
	for i in 1:t loop
		nu := nu + C_main/((1 + r)^i);
		de := de + E_prod/((1 + r)^i);
	end for;

	price := nu/de;
end lcoe;

function capacity_factor
	import SI = Modelica.SIunits;
	input SI.Energy E_prod "Energy produced";
	input SI.Energy E_rate "Energy produced if at rated output";
	output Real factor;
algorithm
	factor := E_prod/E_rate;
end capacity_factor;

block SpotPriceTable "Spot market electricity price table"
	extends Modelica.Blocks.Sources.CombiTimeTable(verboseRead=false,
		tableOnFile=true, tableName="price",
		smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
		columns=2:2
		);
	PowerPrice price "Spot market electricity price";
equation
	price = y[1];
end SpotPriceTable;

end Finances;
