within SolarTherm.Models.Analysis.EnergyPrice;
model Constant "Annual average price"
  extends EnergyPrice;
  parameter SolarTherm.Types.EnergyPrice_MWh price_annual=80
    "Energy price in dollars per mega Watt hour";
equation
  price_annual=price;
end Constant;
