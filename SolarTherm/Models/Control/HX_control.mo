within SolarTherm.Models.Control;
model HX_control
  extends Icons.Control;
  parameter SI.Temperature T_ref_rec=from_degC(570) "Setpoint of temperature";
  parameter SI.Temperature T_ref_hs=from_degC(570) "Setpoint of temperature";
  
  parameter SI.MassFlowRate m_flow_max_CS=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_CS=1 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_min_CS_safe=0.3*m_flow_start_CS "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_CS=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_max_Na=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_Na=1 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_min_Na_safe=0.3*m_flow_start_Na "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_Na=0 "Mass flow rate when control off";
  parameter SI.HeatFlowRate Q_flow_rec=0;
  
  parameter Real L_on = 30 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";
  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";
  
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=0)
    annotation (Placement(visible = true, transformation(extent = {{6, -46}, {32, -22}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput T_input_rec 
    annotation(
    Placement(visible = true, transformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0), iconTransformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput T_output_cs
    annotation (
    Placement(visible = true, transformation(extent = {{-130, 18}, {-90, 58}}, rotation = 0), iconTransformation(extent = {{-130, 18}, {-90, 58}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput Q_out_rec(start=Q_flow_rec, nominal=Q_flow_rec)
    annotation (
    Placement(visible = true, transformation(origin = {2, 108},extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {2, 108},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Modelica.Blocks.Sources.RealExpression T_ref_rec_in(y=T_ref_rec)
    annotation (
    Placement(visible = true, transformation(extent = {{-68, 56}, {-48, 76}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression T_ref_hs_in(y=T_ref_hs) 
   annotation(
    Placement(visible = true, transformation(extent = {{-68, 2}, {-48, 22}}, rotation = 0)));
   
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (
    Placement(visible = true, transformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0), iconTransformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_rec
    annotation (
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)));
    
    Modelica.Blocks.Interfaces.RealOutput m_flow_hs(start=m_flow_start_CS, nominal=m_flow_start_CS)
    annotation (Placement(visible = true, transformation(extent = {{100, 30}, {136, 66}}, rotation = 0), iconTransformation(extent = {{100, 30}, {136, 66}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.BooleanInput sf_on
    annotation (
    Placement(visible = true, transformation(extent = {{-130, -92}, {-90, -52}}, rotation = 0), iconTransformation(extent = {{-130, -92}, {-90, -52}}, rotation = 0)));
 
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
   Placement(visible = true, transformation(origin = {0, -116}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, -116}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  SolarTherm.Models.Control.Switch2 switch 
   annotation(
    Placement(visible = true, transformation(origin = {68, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Control.m_flow_calculation m_flow_calculation1(
      m_flow_max_Na=m_flow_max_Na, 
      m_flow_max_CS=m_flow_max_CS, 
      m_flow_start_Na=m_flow_start_Na, 
      m_flow_start_CS=m_flow_start_CS, 
      m_flow_min_CS=m_flow_min_CS, 
      m_flow_min_Na=m_flow_min_Na,
      m_flow_min_Na_safe=m_flow_min_Na_safe,
      m_flow_min_CS_safe=m_flow_min_CS_safe, 
      Q_flow_rec=Q_flow_rec) annotation(
    Placement(visible = true, transformation(origin = {1, 49}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

equation
	connect(Q_out_rec, m_flow_calculation1.Q_out_rec) annotation(
		Line(points = {{2, 108}, {2, 89}, {1, 89}, {1, 65.5}}, color = {0, 0, 127}));
  	connect(m_flow_calculation1.m_flow_rec, switch.in1) annotation(
    		Line(points = {{19, 41.5}, {38, 41.5}, {38, 4}, {56, 4}}, color = {0, 0, 127}));
  	connect(m_flow_calculation1.m_flow_hs, switch.in2) annotation(
		Line(points = {{19, 56}, {48, 56}, {48, 10}, {56, 10}}, color = {0, 0, 127}));
	connect(m_flow_off_input.y, switch.u3) annotation(
		Line(points = {{34, -34}, {42, -34}, {42, -6}, {56, -6}}, color = {0, 0, 127}));
	connect(and1.y, switch.u2) annotation(
		Line(points = {{-12, -24}, {-4, -24}, {-4, -1}, {56, -1}}, color = {255, 0, 255}));
	connect(switch.y1, m_flow_rec) annotation(
		Line(points = {{79, -1}, {82, -1}, {82, -50}, {118, -50}}, color = {0, 0, 127}));
	connect(switch.y2, m_flow_hs) annotation(
		Line(points = {{79, 5}, {82, 5}, {82, 48}, {118, 48}}, color = {0, 0, 127}));
	connect(sf_on, m_flow_calculation1.sf_on) annotation(
		Line(points = {{-110, -72}, {-64, -72}, {-64, -32}, {-40, -32}, {-40, 63}, {-16, 63}}, color = {255, 0, 255}));
	connect(T_output_cs, m_flow_calculation1.T_output_cs) annotation(
		Line(points = {{-110, 38}, {-17, 38}, {-17, 40}}, color = {0, 0, 127}));
	connect(T_ref_hs_in.y, m_flow_calculation1.T_input_hs) annotation(
		Line(points = {{-46, 12}, {-32, 12}, {-32, 46}, {-17, 46}}, color = {0, 0, 127}));
	connect(T_ref_rec_in.y, m_flow_calculation1.T_out_rec_ref) annotation(
		Line(points = {{-46, 66}, {-34, 66}, {-34, 52}, {-17, 52}}, color = {0, 0, 127}));
	connect(T_input_rec, m_flow_calculation1.T_input_rec) annotation(
		Line(points = {{-112, 92}, {-26, 92}, {-26, 58}, {-17, 58}}, color = {0, 0, 127}));
	connect(not1.y, defocus) annotation(
		Line(points = {{-22, -86}, {-22, -86}, {-22, -120}, {-22, -120}}, color = {255, 0, 255}));
	connect(L_mea, hotTankLogic.level_ref) annotation(
		Line(points = {{-110, -12}, {-74, -12}}, color = {0, 0, 127}));
	connect(not1.u, defocus_logic.y) annotation(
		Line(points = {{-22, -73}, {-22, -69}}, color = {255, 0, 255}));
	connect(and1.u2, sf_on) annotation(
		Line(points = {{-36, -32}, {-64, -32}, {-64, -72}, {-110, -72}}, color = {255, 0, 255}));
	connect(defocus_logic.level_ref, hotTankLogic.level_ref) annotation(
    		Line(points = {{-22, -44}, {-22, -42}, {-80, -42}, {-80, -12}, {-74, -12}}, color = {0, 0, 127}));
	connect(hotTankLogic.y, and1.u1) annotation(
    		Line(points = {{-53.2, -12}, {-44, -12}, {-44, -24}, {-36, -24}}, color = {255, 0, 255}));

  annotation (
  Documentation(revisions="<html> 
  <ul>
  <li>Salvatore Guccione:<br>Released first version. </li>
  </ul>
  </html>"));
end HX_control;
