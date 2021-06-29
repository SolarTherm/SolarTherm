within SolarTherm.Interfaces.Models;
partial model HeatTransferFluid_3PCMs
  extends SolarTherm.Icons.Cascade3PCMModel;
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{-10, 70}, {10, 90}}, rotation = 0), iconTransformation(origin = {0, 104}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{-10, -90}, {10, -70}}, rotation = 0), iconTransformation(origin = {0, -112}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  annotation(
    Icon(graphics = {Line(origin = {-9.79445, 83.9401}, rotation = -90, points = {{-20, 10}, {0, 10}, {-4, 10}}), Line(origin = {0.0742052, -79.9067}, points = {{0, -30}, {0, -10}, {0, -10}})}, coordinateSystem(initialScale = 0.1)));
end HeatTransferFluid_3PCMs;
