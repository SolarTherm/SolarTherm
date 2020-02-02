within SolarTherm.Models.Sources;

model DesignCondition
  extends SolarTherm.Models.Sources;
  import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import Modelica.Math;
  import Modelica.Blocks;
  parameter SI.Power P_gross_des = 100e6;
  parameter SI.Temperature T_amb_des = from_degC(25);
  parameter SI.Temperature T_in_receiver_des = from_degC(580.3);
  parameter SI.Temperature T_out_receiver_des = from_degC(800);
  parameter Real SolarMultiple_des = 2.5;
  parameter Real eff_blk_des = 0.52;
  SI.MassFlowRate mdot_des (fixed = false);
  Modelica.Blocks.Interfaces.RealOutput T_amb_design annotation(
    Placement(visible = true, transformation(origin = {106, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_in_receiver_design annotation(
    Placement(visible = true, transformation(origin = {108, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_out_receiver_design annotation(
    Placement(visible = true, transformation(origin = {108, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput SolarMultiple_design annotation(
    Placement(visible = true, transformation(origin = {106, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput P_gross_design annotation(
    Placement(visible = true, transformation(origin = {106, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput eff_blk_design annotation(
    Placement(visible = true, transformation(origin = {106, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput mdot_design annotation(
    Placement(visible = true, transformation(origin = {102, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  T_amb_design = T_amb_des;
  T_in_receiver_design = T_in_receiver_des;
  T_out_receiver_design = T_in_receiver_des;
  SolarMultiple_design = SolarMultiple_des;
  P_gross_design = P_gross_des;
  eff_blk_design = eff_blk_des;
  mdot_des = P_gross_des / eff_blk_des * SolarMultiple_des / (Util.h_T(T_out_receiver_des) - Util.h_T(T_in_receiver_des));
  mdot_design = mdot;
  annotation(
    uses(Modelica(version = "3.2.2")));
end DesignCondition;