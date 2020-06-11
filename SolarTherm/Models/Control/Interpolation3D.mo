within SolarTherm.Models.Control;
  model Interpolation3D
  import SI = Modelica.SIunits;
  import Modelica.SIunits.Conversions.*;
  parameter Integer table_number = 11;
  parameter SI.Temperature T_cold_in_set[table_number] = linspace(730, 830, table_number);
  parameter Real step = T_cold_in_set[2] - T_cold_in_set[1];
  
  // Combitable2D params
  parameter String table_name = "mdot";
  parameter String[table_number] tablefile = {Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_730.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_740.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_750.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_760.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_770.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_780.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_790.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_800.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_810.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_820.motab"), Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/mdot_830.motab")};
  
  // Instantiation of table_number combi table 2Ds
  Modelica.Blocks.Tables.CombiTable2D mdot_730(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[1]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_740(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[2]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_750(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[3]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_760(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[4]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_770(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[5]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_780(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[6]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_790(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[7]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_800(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[8]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_810(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[9]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_820(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[10]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D mdot_830(tableOnFile = true, tableName = table_name, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, fileName = tablefile[11]) annotation(
    Placement(visible = true, transformation(extent = {{-12, -8}, {8, 12}}, rotation = 0)));

  //Interfaces instantiation
  
  Modelica.Blocks.Interfaces.RealInput Q_in annotation(
    Placement(visible = true, transformation(origin = {-50, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-50, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_cold_in annotation(
    Placement(visible = true, transformation(origin = {0, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-122, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {46, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {46, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput mdot annotation(
    Placement(visible = true, transformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Variables
  Integer index[2](start = fill(0, 2));
  Real table_1D[table_number];
  Real weight_table[table_number];
  Real weight_val;
  Real iter_weight;
  Real T_cold_low;
  Real T_cold_high;
  Integer index_1;
  Integer index_2;
algorithm
// Creating a 1-D table for given Q_in and T_amb
  mdot_730.u1 := Q_in;
  mdot_730.u2 := T_amb;
  table_1D[1] := mdot_730.y;
  mdot_740.u1 := Q_in;
  mdot_740.u2 := T_amb;
  table_1D[2] := mdot_740.y;
  mdot_750.u1 := Q_in;
  mdot_750.u2 := T_amb;
  table_1D[3] := mdot_750.y;
  mdot_760.u1 := Q_in;
  mdot_760.u2 := T_amb;
  table_1D[4] := mdot_760.y;
  mdot_770.u1 := Q_in;
  mdot_770.u2 := T_amb;
  table_1D[5] := mdot_770.y;
  mdot_780.u1 := Q_in;
  mdot_780.u2 := T_amb;
  table_1D[6] := mdot_780.y;
  mdot_790.u1 := Q_in;
  mdot_790.u2 := T_amb;
  table_1D[7] := mdot_790.y;
  mdot_800.u1 := Q_in;
  mdot_800.u2 := T_amb;
  table_1D[8] := mdot_800.y;
  mdot_810.u1 := Q_in;
  mdot_810.u2 := T_amb;
  table_1D[9] := mdot_810.y;
  mdot_820.u1 := Q_in;
  mdot_820.u2 := T_amb;
  table_1D[10] := mdot_820.y;
  mdot_830.u1 := Q_in;
  mdot_830.u2 := T_amb;
  table_1D[11] := mdot_830.y;
// Checking in between which index the T_cold_in lies
  for i in 1:table_number loop
    weight_val := abs(T_cold_in - T_cold_in_set[i]) / step;
    if weight_val > 0 and weight_val <= 1 then
      weight_table[i] := weight_val;
    elseif weight_val == 0 then
      weight_table[i] := 1e-2 "make sure there is no 0 in the weight table to avoid confusion of the solver";
    else
      weight_table[i] := -1000;
    end if;
  end for;
// Take the index
  for i in 1:table_number loop
    iter_weight := weight_table[i];
    if iter_weight >= 0 and iter_weight <= 1 then
      if index[1] == 0 then
        index[1] := i;
      elseif index[1] >= 0 then
        index[2] := i;
      end if;
    end if;
  end for;
// Interpolate
  index_1 := index[1];
  index_2 := index[2];
  T_cold_low := if T_cold_in < T_cold_in_set[1] or T_cold_in > T_cold_in_set[end] then T_cold_in_set[1] else T_cold_in_set[index_1];
  T_cold_high := if T_cold_in < T_cold_in_set[1] or T_cold_in > T_cold_in_set[end] then T_cold_in_set[1] else T_cold_in_set[index_2];
  if T_cold_in < T_cold_in_set[1] then
    mdot := table_1D[1] - (table_1D[2] - table_1D[1]) / (T_cold_in_set[2] - T_cold_in_set[1]) * (T_cold_in_set[1] - T_cold_in) "possibility of having extrapolation == linear";
  elseif T_cold_in > T_cold_in_set[table_number] then
    mdot := table_1D[table_number] + (table_1D[end] - table_1D[end - 1]) / (T_cold_in_set[end] - T_cold_in_set[end - 1]) * (T_cold_in - T_cold_in_set[end]) "possibility of having extrapolation == linear";
  else
    mdot := (T_cold_in - T_cold_low) / (step) * (table_1D[index_2] - table_1D[index_1]) + table_1D[index_1];
  end if;
end Interpolation3D;