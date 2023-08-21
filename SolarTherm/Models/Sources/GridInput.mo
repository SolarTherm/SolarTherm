within SolarTherm.Models.Sources;
model GridInput
  parameter String elec_input = "/home/arfontalvo/solartherm-master/examples/pv_electricity.motab";
  parameter Modelica.SIunits.Efficiency W_curtailment = 40e6 "";
  Modelica.SIunits.Efficiency Q_defocus_y;
  Modelica.Blocks.Sources.CombiTimeTable grid_input(fileName = elec_input, tableName = "p_pelec", tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression curtailment(y = Q_defocus_y) annotation(
    Placement(visible = true, transformation(origin = {-50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput defocus annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput electricity annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  Q_defocus_y = min(grid_input.y[1], W_curtailment);
  connect(curtailment.y, switch1.u1) annotation(
    Line(points = {{-38, -30}, {-28, -30}, {-28, -8}, {-12, -8}}, color = {0, 0, 127}));
  connect(grid_input.y[1], switch1.u3) annotation(
    Line(points = {{-38, 30}, {-28, 30}, {-28, 8}, {-12, 8}}, color = {0, 0, 127}));
  connect(defocus, switch1.u2) annotation(
    Line(points = {{-100, 0}, {-12, 0}}, color = {255, 0, 255}));
  connect(switch1.y, electricity) annotation(
    Line(points = {{12, 0}, {100, 0}}, color = {0, 0, 127}));
end GridInput;