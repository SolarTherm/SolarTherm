within SolarTherm.Models.Sources;
model GridInput
  parameter String elec_input = "/home/arfontalvo/solartherm-master/examples/pv_electricity.motab";
  parameter Modelica.SIunits.HeatFlowRate Q_start = 1e-3;
  parameter Modelica.SIunits.HeatFlowRate Q_stop = 1e-3;
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
  Modelica.Blocks.Interfaces.BooleanOutput on_pv annotation (
    Placement(transformation(extent={{20,-20},{-20,20}},rotation=90,origin={0,-114})));
//  Boolean on_pv;
  Integer state_con(start = 1);
algorithm
  when state_con == 1 and grid_input.y[1] > Q_start then
    state_con := 2;
  elsewhen state_con == 2 and grid_input.y[1] < Q_stop then
    state_con := 1;
  end when;
equation
  if state_con == 1 then
    on_pv = false;
  else
    on_pv = true;
  end if;
//  Q_defocus_y = min(grid_input.y[1], W_curtailment);
  connect(curtailment.y, switch1.u1) annotation(
    Line(points = {{-38, -30}, {-28, -30}, {-28, -8}, {-12, -8}}, color = {0, 0, 127}));
  connect(grid_input.y[1], switch1.u3) annotation(
    Line(points = {{-38, 30}, {-28, 30}, {-28, 8}, {-12, 8}}, color = {0, 0, 127}));
  connect(defocus, switch1.u2) annotation(
    Line(points = {{-100, 0}, {-12, 0}}, color = {255, 0, 255}));
  connect(switch1.y, electricity) annotation(
    Line(points = {{12, 0}, {100, 0}}, color = {0, 0, 127}));
annotation(
    Icon(graphics = {Line(points = {{40, 20}, {-40, -20}, {-40, 20}, {40, -20}, {40, 20}}, thickness = 0.5), Line(origin = {0, -100}, points = {{-80, 0}, {80, 0}}, thickness = 0.5), Line(origin = {0, -60.17}, points = {{-80, -40}, {-40, 40}, {40, 40}, {80, -40}}, thickness = 0.5), Line(points = {{-40, -20}, {60, -60}, {-60, -60}, {40, -20}}, thickness = 0.5), Line(points = {{-60, -60}, {80, -100}}, thickness = 0.5), Line(points = {{60, -60}, {-80, -100}}, thickness = 0.5), Line(origin = {0.17, 39.78}, points = {{-40.1708, -19.7764}, {39.8292, -19.7764}, {39.8292, 20.2236}, {-40.1708, -19.7764}, {-40.1708, 20.2236}, {39.8292, -19.7764}}, thickness = 0.5), Line(origin = {0, 80}, points = {{-40, -20}, {0, 20}, {40, -20}, {-40, -20}}, thickness = 0.5), Line(origin = {-70, 40}, points = {{30, -20}, {-30, 0}, {30, 20}}, thickness = 0.5), Line(origin = {70, 40}, points = {{-30, 20}, {30, 0}, {-30, -20}}, thickness = 0.5), Text(origin = {-10, 254}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name")}));
end GridInput;