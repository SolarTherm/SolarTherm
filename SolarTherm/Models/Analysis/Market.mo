within SolarTherm.Models.Analysis;
model Market
  extends Icons.Price;
  Modelica.Blocks.Interfaces.RealInput W_net(
    quantity="Power",
    unit="W",
    displayUnit="MW")
    annotation (Placement(transformation(extent={{-120,-22},{-80,18}})));

  replaceable model Price =
      SolarTherm.Models.Analysis.EnergyPrice.Table
  constrainedby SolarTherm.Models.Analysis.EnergyPrice.EnergyPrice
    "Energy price in dollars per mega Watt hour"
    annotation (Dialog(group="Finances",_Dymola_label="Price"), choicesAllMatching=true);

  Price price;
  SolarTherm.Types.Money profit;
equation
  der(profit)=W_net*SolarTherm.Types.from_dollarperMWh(price.price);
  annotation (Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Market;
