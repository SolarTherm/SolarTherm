within SolarTherm.Models.Analysis;
model PriceMarket
  extends Icons.Price;
  Modelica.Blocks.Interfaces.RealInput W_el
    annotation (Placement(transformation(extent={{-120,-22},{-80,18}})));
  parameter SolarTherm.Types.EnergyPrice_MWh price=80;
  SolarTherm.Types.Money profit;
equation
  der(profit)=W_el*SolarTherm.Types.from_dollarperMWh(price);
end PriceMarket;
