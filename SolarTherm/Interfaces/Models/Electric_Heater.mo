within SolarTherm.Interfaces.Models;

partial model Electric_Heater
  //extends SolarTherm.Interfaces.Models.Receiver;
  Modelica.Blocks.Interfaces.RealInput P_supply "Supplied electrical power" annotation (Placement(
        visible = true,transformation(
        
        origin={44,84},extent={{-12,-12},{12,12}},
        rotation=-90), iconTransformation(
        
        origin={-112, -2},extent={{12, -12}, {-12, 12}},
        rotation=180)));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{10, -100}, {30, -80}}, rotation = 0), iconTransformation(extent = {{-8, -100}, {12, -80}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{24, 38}, {44, 58}}, rotation = 0), iconTransformation(extent = {{-8, 80}, {12, 100}}, rotation = 0)));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  annotation(
    Icon(graphics = {Rectangle(origin = {-26, -7}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{74, 93}, {-70, -93}}), Rectangle(origin = {-2, 8}, lineThickness = 0.5, extent = {{-18, 36}, {26, -52}}), Line(origin = {2, 63}, points = {{0, 19}, {0, -19}}, thickness = 0.5), Line(origin = {2, -62}, points = {{0, 18}, {0, -18}}, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)));

end Electric_Heater;