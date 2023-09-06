within SolarTherm.Models.Sources;
model GridInput
  parameter String pv_ref = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_pv.motab");
  parameter String wind_ref = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_wind.motab");
  parameter Modelica.SIunits.Power Q_start = 1e-3;
  parameter Modelica.SIunits.Power Q_stop = 1e-3;
  parameter Modelica.SIunits.Power max_input = 100e6 "Maximum renewable energy input";
  parameter Modelica.SIunits.Efficiency pv_fraction = 0.5 "PV fraction of renewable input at design";
  parameter Modelica.SIunits.Power pv_ref_size = 50e6 "PV farm reference size";
  parameter Modelica.SIunits.Power wind_ref_size = 50e6 "Wind farm reference size";
  parameter Modelica.SIunits.Efficiency heater_efficiency = 0.99 "Electric to thermal efficiency";
  final parameter Modelica.SIunits.Power pv_max = pv_fraction*max_input "Maximum PV capacity";
  final parameter Modelica.SIunits.Power wind_max = (1-pv_fraction)*max_input "Maximum Wind farm capacity";
  Modelica.SIunits.Power CurtaimentPower;
  Modelica.Blocks.Sources.CombiTimeTable pv_input_ref(fileName = pv_ref, tableName = "Power", tableOnFile = true);
  Modelica.Blocks.Sources.CombiTimeTable wind_input_ref(fileName = wind_ref, tableName = "Power", tableOnFile = true);
  Modelica.Blocks.Sources.RealExpression renewable_input(y = RenewableInput) annotation(
    Placement(visible = true, transformation(origin = {-50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression curtailment(y = CurtaimentPower) annotation(
    Placement(visible = true, transformation(origin = {-50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput defocus annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput electricity annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput on_pv annotation (
    Placement(transformation(extent={{20,-20},{-20,20}},rotation=90,origin={0,-114})));
  Integer state_con(start = 1);
  Modelica.SIunits.HeatFlowRate RenewableInput;
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression efficiency(y = heater_efficiency) annotation(
    Placement(visible = true, transformation(origin = {24, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  when state_con == 1 and RenewableInput > Q_start then
    state_con := 2;
  elsewhen state_con == 2 and RenewableInput < Q_stop then
    state_con := 1;
  end when;
equation
  RenewableInput = min(pv_max/pv_ref_size*pv_input_ref.y[1] + wind_max/wind_ref_size*wind_input_ref.y[1] , max_input);
  if state_con == 1 then
    on_pv = false;
  else
    on_pv = true;
  end if;
  connect(curtailment.y, switch1.u1) annotation(
    Line(points = {{-39, -30}, {-25.5, -30}, {-25.5, -8}, {-12, -8}}, color = {0, 0, 127}));
  connect(defocus, switch1.u2) annotation(
    Line(points = {{-100, 0}, {-12, 0}}, color = {255, 0, 255}));
  connect(renewable_input.y, switch1.u3) annotation(
    Line(points = {{-38, 30}, {-26, 30}, {-26, 8}, {-12, 8}}, color = {0, 0, 127}));
  connect(switch1.y, product.u1) annotation(
    Line(points = {{12, 0}, {22, 0}, {22, 6}, {46, 6}}, color = {0, 0, 127}));
  connect(product.y, electricity) annotation(
    Line(points = {{70, 0}, {100, 0}}, color = {0, 0, 127}));
  connect(efficiency.y, product.u2) annotation(
    Line(points = {{36, -34}, {40, -34}, {40, -6}, {46, -6}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Line(points = {{40, 20}, {-40, -20}, {-40, 20}, {40, -20}, {40, 20}}, thickness = 0.5), Line(origin = {0, -100}, points = {{-80, 0}, {80, 0}}, thickness = 0.5), Line(origin = {0, -60.17}, points = {{-80, -40}, {-40, 40}, {40, 40}, {80, -40}}, thickness = 0.5), Line(points = {{-40, -20}, {60, -60}, {-60, -60}, {40, -20}}, thickness = 0.5), Line(points = {{-60, -60}, {80, -100}}, thickness = 0.5), Line(points = {{60, -60}, {-80, -100}}, thickness = 0.5), Line(origin = {0.17, 39.78}, points = {{-40.1708, -19.7764}, {39.8292, -19.7764}, {39.8292, 20.2236}, {-40.1708, -19.7764}, {-40.1708, 20.2236}, {39.8292, -19.7764}}, thickness = 0.5), Line(origin = {0, 80}, points = {{-40, -20}, {0, 20}, {40, -20}, {-40, -20}}, thickness = 0.5), Line(origin = {-70, 40}, points = {{30, -20}, {-30, 0}, {30, 20}}, thickness = 0.5), Line(origin = {70, 40}, points = {{-30, 20}, {30, 0}, {-30, -20}}, thickness = 0.5), Text(origin = {-10, 254}, lineColor = {0, 0, 255}, extent = {{-149, -114}, {151, -154}}, textString = "%name")}));
end GridInput;