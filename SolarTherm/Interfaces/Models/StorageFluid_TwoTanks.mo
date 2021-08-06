within SolarTherm.Interfaces.Models;
partial model StorageFluid_TwoTanks
  extends SolarTherm.Icons.StorageModel_TwoTanks;
  Modelica.Fluid.Interfaces.FluidPort_a fluid_ha(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{-110, 40}, {-90, 60}}, rotation = 0), iconTransformation(origin = {-52, 60}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_hb(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{90, 40}, {110, 60}}, rotation = 0), iconTransformation(origin = { 56, 60}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_ca(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{90, -60}, {110, -40}}, rotation = 0), iconTransformation(origin = {56, -38}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_cb(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{-110, -60}, {-90, -40}}, rotation = 0), iconTransformation(origin = {-52, -38}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  annotation(
    Icon(graphics = {Text(origin = {3, 58}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-13, 12}, {15, -8}}, textString = "Hot"), Text(origin = {-1, -30}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-13, 12}, {19, -26}}, textString = "Cold")}));
end StorageFluid_TwoTanks;