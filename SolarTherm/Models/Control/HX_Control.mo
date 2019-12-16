within SolarTherm.Models.Control;
model HX_Control
  extends Icons.Control;
  parameter SI.Temperature T_ref_rec=from_degC(570) "Setpoint of temperature";
  parameter SI.Temperature T_ref_HX=from_degC(570) "Setpoint of temperature";
  
  parameter SI.MassFlowRate m_flow_max_rec=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_rec=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_max_HX=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_HX=0 "Mass flow rate when control off";
  
  parameter Real L_on = 30 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";
  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";

  parameter Real y_start_rec=300 "Initial value of output";
  parameter Real Ti_rec=1 "Integer constant";
  parameter Real Kp_rec=-10 "Proportional constant";
  
  parameter Real y_start_HX=300 "Initial value of output";
  parameter Real Ti_HX=1 "Integer constant";
  parameter Real Kp_HX=-10 "Proportional constant";
  
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=0)
    annotation (Placement(visible = true, transformation(extent = {{6, -46}, {32, -22}}, rotation = 0)));
  
  Modelica.Blocks.Math.Feedback feedback1 
    annotation(Placement(visible = true, transformation(extent = {{-26, 26}, {-6, 6}}, rotation = 0)));
  
  SolarTherm.Models.Control.PID_AW_reset3 PI_rec(
    Tt = 1,
    uMax=m_flow_max_rec,
    uMin=m_flow_min_rec,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=y_start_rec,
    Ti=Ti_rec,
    Kp=Kp_rec)
    annotation (
    Placement(visible = true, transformation(extent = {{14, 6}, {34, 26}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression T_ref_rec_input(y=T_ref_rec)
    annotation (
    Placement(visible = true, transformation(extent = {{-62, 6}, {-42, 26}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (
    Placement(visible = true, transformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0), iconTransformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_rec
    annotation (
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)));
    
    Modelica.Blocks.Interfaces.RealOutput m_flow_HX
    annotation (
    Placement(visible = true, transformation(extent = {{100, 30}, {136, 66}}, rotation = 0), iconTransformation(extent = {{100, 30}, {136, 66}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.BooleanInput sf_on
    annotation (
    Placement(visible = true, transformation(extent = {{-130, -92}, {-90, -52}}, rotation = 0), iconTransformation(extent = {{-130, -92}, {-90, -52}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput T_out_rec
    annotation (
    Placement(visible = true, transformation(extent = {{-130, 18}, {-90, 58}}, rotation = 0), iconTransformation(extent = {{-130, 18}, {-90, 58}}, rotation = 0)));
  
  SolarTherm.Models.Control.Level2Logic hotTankLogic(level_max=30, level_min=L_off)
    annotation (
    Placement(visible = true, transformation(extent = {{-74, -22}, {-54, -2}}, rotation = 0)));
  
  Modelica.Blocks.Logical.And and1
    annotation (
    Placement(visible = true, transformation(extent = {{-34, -34}, {-14, -14}}, rotation = 0)));
  
  SolarTherm.Models.Control.Level2Logic defocus_logic(
    y(start=false),
    level_max=L_df_off,
    level_min=L_df_on)  
    annotation (
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-12, -10}, {12, 10}}, rotation = -90)));
  
  Modelica.Blocks.Logical.Not not1 
    annotation (
    Placement(visible = true, transformation(origin = {0, -86}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.BooleanOutput defocus  
   annotation (
   Placement(visible = true, transformation(origin = {0, -126}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, -126}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Modelica.Blocks.Math.Feedback feedback2 
    annotation(
    Placement(visible = true, transformation(extent = {{-26, 70}, {-6, 50}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput T_out_HX 
    annotation(
    Placement(visible = true, transformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0), iconTransformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression T_ref_HX_input(y=T_ref_HX) 
   annotation(
    Placement(visible = true, transformation(extent = {{-64, 50}, {-44, 70}}, rotation = 0)));
  
  SolarTherm.Models.Control.PID_AW_reset3 PID(
    Kp = Kp_HX, 
    Ti = Ti_HX, 
    Tt = 1, 
    initType = Modelica.Blocks.Types.InitPID.InitialOutput, 
    uMax = m_flow_max_HX, 
    uMin = m_flow_min_HX, 
    y_start = y_start_HX)  
   annotation(
    Placement(visible = true, transformation(extent = {{14, 50}, {34, 70}}, rotation = 0)));
  
  SolarTherm.Models.Control.Switch2 switch 
   annotation(
    Placement(visible = true, transformation(origin = {64, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(PID.y, switch.in2) annotation(
    Line(points = {{36, 60}, {44, 60}, {44, 6}, {52, 6}, {52, 9}}, color = {0, 0, 127}));
  connect(PI_rec.y, switch.in1) annotation(
    Line(points = {{36, 16}, {38, 16}, {38, 4}, {52, 4}}, color = {0, 0, 127}));
  connect(m_flow_off_input.y, switch.u3) annotation(
    Line(points = {{34, -34}, {42, -34}, {42, -6}, {52, -6}}, color = {0, 0, 127}));
  connect(switch.y2, m_flow_HX) annotation(
    Line(points = {{75, 5}, {82, 5}, {82, 48}, {118, 48}}, color = {0, 0, 127}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{-12, -24}, {-4, -24}, {-4, -1}, {52, -1}}, color = {255, 0, 255}));
  connect(switch.y1, m_flow_rec) annotation(
    Line(points = {{75, -1}, {82, -1}, {82, -50}, {118, -50}}, color = {0, 0, 127}));
  connect(and1.y, PID.reset) annotation(
    Line(points = {{-12, -24}, {-4, -24}, {-4, -4}, {2, -4}, {2, 52}, {12, 52}, {12, 52}}, color = {255, 0, 255}));
  connect(and1.y, PI_rec.reset) annotation(
    Line(points = {{-12, -24}, {-4, -24}, {-4, -4}, {2, -4}, {2, 8}, {12, 8}, {12, 8}}, color = {255, 0, 255}));
  connect(feedback1.y, PI_rec.u) annotation(
    Line(points = {{-6, 16}, {12, 16}, {12, 16}, {12, 16}}, color = {0, 0, 127}));
  connect(T_ref_HX_input.y, feedback2.u1) annotation(
    Line(points = {{-42, 60}, {-26, 60}, {-26, 60}, {-24, 60}}, color = {0, 0, 127}));
  connect(T_out_HX, feedback2.u2) annotation(
    Line(points = {{-112, 92}, {-16, 92}, {-16, 68}, {-16, 68}}, color = {0, 0, 127}));
  connect(T_out_rec, feedback1.u2) annotation(
    Line(points = {{-110, 38}, {-16, 38}, {-16, 24}, {-16, 24}}, color = {0, 0, 127}));
  connect(T_ref_rec_input.y, feedback1.u1) annotation(
    Line(points = {{-40, 16}, {-26, 16}, {-26, 16}, {-24, 16}}, color = {0, 0, 127}));
  connect(feedback1.y, PID.u) annotation(
    Line(points = {{-7, 60}, {11, 60}}, color = {0, 0, 127}));
  connect(L_mea, hotTankLogic.level_ref) annotation(
    Line(points = {{-110, -12}, {-74, -12}}, color = {0, 0, 127}));
  connect(not1.y, defocus) annotation(
    Line(points = {{0, -92.6}, {0, -126}}, color = {255, 0, 255}));
  connect(not1.u, defocus_logic.y) annotation(
    Line(points = {{0, -78.8}, {0, -76}, {-1.33227e-15, -76}, {-1.33227e-15, -72.96}}, color = {255, 0, 255}));
  connect(and1.u2, sf_on) annotation(
    Line(points = {{-36, -32}, {-64, -32}, {-64, -72}, {-110, -72}}, color = {255, 0, 255}));
  connect(defocus_logic.level_ref, hotTankLogic.level_ref) annotation(
    Line(points = {{0, -48}, {0, -42}, {-80, -42}, {-80, -12}, {-74, -12}}, color = {0, 0, 127}));
  connect(hotTankLogic.y, and1.u1) annotation(
    Line(points = {{-53.2, -12}, {-44, -12}, {-44, -24}, {-36, -24}}, color = {255, 0, 255}));
  
  annotation (
  Documentation(revisions="<html> 
  <ul>
  <li>Salvatore Guccione:<br>Released first version. </li>
  </ul>
  </html>"));
end HX_Control;