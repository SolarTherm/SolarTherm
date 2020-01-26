within SolarTherm.Models.Analysis.EnergyPrice;
partial model EnergyPrice
  output SolarTherm.Types.EnergyPrice_MWh price
    "Energy price in dollars per mega Watt hour";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EnergyPrice;
