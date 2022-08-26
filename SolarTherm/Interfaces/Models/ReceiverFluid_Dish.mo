within SolarTherm.Interfaces.Models;
partial model ReceiverFluid_Dish
  extends SolarTherm.Interfaces.Models.Receiver_Dish;

  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{10, -100}, {30, -80}}, rotation = 0), iconTransformation(extent = {{56, -108}, {76, -88}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{24, 38}, {44, 58}}, rotation = 0), iconTransformation(extent = {{52, 90}, {72, 110}}, rotation = 0)));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  annotation(
    Icon(graphics = {Line(origin = {65.3381, -8.69117}, points = {{0, -81}, {0, 19}, {0, 19}}, color = {0, 0, 127}, thickness = 1), Line(origin = {32.6, -8.38}, points = {{-22, 19}, {0, 19}, {32, 19}}, color = {0, 0, 127}, thickness = 1, arrow = {Arrow.Filled, Arrow.None}), Line(origin = {52.0558, 46.59}, points = {{10, 43}, {10, 19}, {-20, 19}}, color = {0, 0, 127}, thickness = 1, arrow = {Arrow.Filled, Arrow.None})}, coordinateSystem(initialScale = 0.1)));

end ReceiverFluid_Dish;