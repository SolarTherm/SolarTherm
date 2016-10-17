within SolarTherm.Interfaces.Models;
partial model PowerBlock
  extends Icons.PowerBlock;
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-54,22},{-34,42}}),  iconTransformation(extent={{-48,30},
            {-40,38}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-74,-60},{-54,-40}}),iconTransformation(extent={{-62,-48},
            {-54,-40}})));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_base
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  Modelica.Blocks.Interfaces.RealOutput W_net(
    quantity="Power",
    unit="W",
    displayUnit="MW") "Net electric power output" annotation (Placement(
        transformation(extent={{44,-24},{64,-4}}), iconTransformation(extent={{
            46,-10},{56,0}})));
end PowerBlock;
