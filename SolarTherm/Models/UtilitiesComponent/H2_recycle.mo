within SolarTherm.Models.UtilitiesComponent;

model H2_recycle
  import SI = Modelica.SIunits;
  parameter SI.MassFlowRate H2_mdot_recycle = 1;
  Real H2_feedstock_des = 1;
  Modelica.Blocks.Interfaces.BooleanInput on annotation(
    Placement(visible = true, transformation(origin = {-8, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-8, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput out annotation(
    Placement(visible = true, transformation(origin = {-106, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-106, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput H2_feedstock annotation(
    Placement(visible = true, transformation(origin = {100, 12}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {100, 12}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
equation
  if on then 
      out = H2_feedstock/H2_feedstock_des *   H2_mdot_recycle "Linear relationship";
  else
      out = 0;
  end if;

end H2_recycle;