within SolarTherm.Interfaces.Models;
partial model HeatTransferFluid_PCM
  extends SolarTherm.Icons.PCMModel;
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{-10, 70}, {10, 90}}, rotation = 0), iconTransformation(origin = {-94, -2}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{-10, -90}, {10, -70}}, rotation = 0), iconTransformation(origin = {90,0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  annotation(
    Icon(graphics = {Line(origin = {-89.5485, -12.1739}, points = {{26, 10}, {0, 10}, {0, 10}}), Line(origin = {56.1873, 9.01338}, points = {{32, -10}, {0, -10}, {0, -10}})}, coordinateSystem(initialScale = 0.1)));
end HeatTransferFluid_PCM;
