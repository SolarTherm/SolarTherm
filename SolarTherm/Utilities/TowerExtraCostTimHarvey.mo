within SolarTherm.Utilities;

model TowerExtraCostTimHarvey
  parameter String fn = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/ExtraCostTowerTimHarvey.motab");
  parameter Real H_tower = 175;
  parameter Real D_inner_tower = 25;
  Modelica.Blocks.Tables.CombiTable2D C_tim(tableOnFile = true, tableName = "extra_cost_structure", smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = fn);
  Real C_extra_structure_cost;
equation
  C_tim.u1 = D_inner_tower-1.83*2;
  C_tim.u2 = H_tower;
  C_extra_structure_cost = max(0, C_tim.y);
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end TowerExtraCostTimHarvey;