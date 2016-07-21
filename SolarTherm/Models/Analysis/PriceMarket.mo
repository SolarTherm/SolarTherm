within SolarTherm.Models.Analysis;
model PriceMarket
  extends Icons.Price;
  Modelica.Blocks.Interfaces.RealInput W_el
    annotation (Placement(transformation(extent={{-120,-22},{-80,18}})));
  parameter Real nu_net=0.9 "Estimated gross to net conversion factor";
  parameter SolarTherm.Types.EnergyPrice_MWh price=80;
  SolarTherm.Types.Money profit;
  SI.HeatFlowRate W_net "Estimated net output at design";
equation
  W_net=nu_net*W_el;
  der(profit)=W_el*SolarTherm.Types.from_dollarperMWh(price);
end PriceMarket;
