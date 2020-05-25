within SolarTherm.SolarPaces2019;

partial model PowerBlockHeat
  extends Icons.PowerBlock;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat_a annotation (Placement(
        transformation(extent={{-54,22},{-34,42}}),  iconTransformation(extent={{-48,30},
            {-40,38}})));
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  Modelica.Blocks.Interfaces.RealOutput W_net(
    quantity="Power",
    unit="W",
    displayUnit="MW") "Net electric power output" annotation (Placement(
        transformation(extent={{44,-24},{64,-4}}), iconTransformation(extent={{
            46,-10},{56,0}})));
end PowerBlockHeat;