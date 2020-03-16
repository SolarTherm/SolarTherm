within SolarTherm.Models.Control;
model SimpleReceiverControl
  extends Icons.Control;
  parameter SI.Temperature T_ref=from_degC(800) "Setpoint of temperature";
  parameter SI.MassFlowRate m_flow_max=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min=0 "Mass flow rate when control off";
  
  parameter Real L_on = 30 "Level of start discharge";
  parameter Real L_off=10 "Level of stop discharge";
  parameter Real L_df_on=99 "Level of start defocus";
  parameter Real L_df_off=96 "Level of stop defocus";
  parameter Real eta_rec_th_des = 0.856;

  parameter Real y_start=500 "Initial value of output";
  Boolean intermediate_on_y (start=false);

  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(visible = true, transformation(extent = {{72, -6}, {84, 6}}, rotation = 0)));
    
  Modelica.Blocks.Sources.RealExpression m_flow_off_input(y=0)
    annotation (Placement(transformation(extent={{6,-34},{32,-10}})));
    
  Modelica.Blocks.Sources.RealExpression T_ref_input(y=T_ref)
    annotation (Placement(visible = true, transformation(extent = {{-68, 16}, {-48, 36}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput L_mea
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
    
  Modelica.Blocks.Interfaces.BooleanInput sf_on
    annotation (Placement(transformation(extent={{-130,-80},{-90,-40}})));
    
  Modelica.Blocks.Interfaces.RealInput T_mea
    annotation (Placement(visible = true, transformation(extent = {{-128, 28}, {-88, 68}}, rotation = 0), iconTransformation(extent = {{-128, 28}, {-88, 68}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput Q_in
    annotation (Placement(visible = true, transformation(origin = {-116, 86},extent = {{-20, 10}, {20, -10}}, rotation = 0), iconTransformation(origin = {-116, 86},extent = {{-20, 10}, {20, -10}}, rotation = 0)));
    
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-34,-22},{-14,-2}})));
    
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,-74})));
        
  Modelica.Blocks.Interfaces.BooleanOutput defocus annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-114})));
    

 
  SolarTherm.Models.Control.Level2Logic hotTank  (level_max=L_on, level_min=L_off)
  annotation(Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
    
  SolarTherm.Models.Control.Level2Logic defocusLogic (
    y(start=false),
    level_max=L_df_off,
    level_min=L_df_on
    ) 
   annotation(Placement(visible = true, transformation(origin = {0, -46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
   
  Modelica.Blocks.Nonlinear.Limiter limiter (uMax = m_flow_max, uMin = m_flow_min)
   annotation (Placement(visible = true, transformation(origin = {46, 58}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
   
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation(
    Placement(visible = true, transformation(extent = {{94, -18}, {130, 18}}, rotation = 0), iconTransformation(extent = {{94, -18}, {130, 18}}, rotation = 0)));
  SolarTherm.Models.Control.IdealMassflowBlockCalculation idealMassflowBlockCalculation (eta_rec_th_des = eta_rec_th_des, y_start =y_start) annotation(
    Placement(visible = true, transformation(origin = {-4, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput T_out_receiver annotation(
    Placement(visible = true, transformation(origin = {0, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 112}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput on_y annotation(
    Placement(visible = true, transformation(origin = {-38, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-38, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
algorithm
  if L_mea > L_on then
    intermediate_on_y:=true;
  elseif L_mea<L_off then  
    intermediate_on_y:=false;
  else 
    intermediate_on_y := false;
  end if;
  on_y := intermediate_on_y;
equation

  connect(m_flow_off_input.y, switch.u3) annotation(
    Line(points = {{33.3, -22}, {44, -22}, {44, -5}, {71, -5}}, color = {0, 0, 127}));
  connect(and1.u2, sf_on) annotation(
    Line(points = {{-36, -20}, {-64, -20}, {-64, -60}, {-110, -60}}, color = {255, 0, 255}));
  connect(not1.y, defocus) annotation(
    Line(points = {{0, -80.6}, {0, -114}}, color = {255, 0, 255}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{-13, -12}, {-6, -12}, {-6, 0}, {71, 0}}, color = {255, 0, 255}));
  connect(L_mea, hotTank.level_ref) annotation(
    Line(points = {{-108, 0}, {-74, 0}, {-74, 0}, {-72, 0}}, color = {0, 0, 127}));
  connect(hotTank.y, and1.u1) annotation(
    Line(points = {{-52, 0}, {-42, 0}, {-42, -12}, {-36, -12}, {-36, -12}, {-36, -12}}, color = {255, 0, 255}));
  connect(defocusLogic.y, not1.u) annotation(
    Line(points = {{0, -56}, {0, -56}, {0, -66}, {0, -66}}, color = {255, 0, 255}));
  connect(L_mea, defocusLogic.level_ref) annotation(
    Line(points = {{-108, 0}, {-88, 0}, {-88, -26}, {0, -26}, {0, -36}, {0, -36}}, color = {0, 0, 127}));
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{53, 58}, {62, 58}, {62, 4}, {70, 4}}, color = {0, 0, 127}));
  connect(switch.y, m_flow) annotation(
    Line(points = {{84, 0}, {96, 0}, {96, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(Q_in, idealMassflowBlockCalculation.Q_input) annotation(
    Line(points = {{-116, 86}, {-16, 86}, {-16, 62}}, color = {0, 0, 127}));
  connect(T_mea, idealMassflowBlockCalculation.T_mea) annotation(
    Line(points = {{-108, 48}, {-24, 48}, {-24, 68}, {-24, 68}}, color = {0, 0, 127}));
  connect(idealMassflowBlockCalculation.m_flow, limiter.u) annotation(
    Line(points = {{22, 68}, {38, 68}, {38, 58}, {38, 58}}, color = {0, 0, 127}));
  connect(Q_in, idealMassflowBlockCalculation.Q_input) annotation(
    Line(points = {{-116, 86}, {-16, 86}, {-16, 62}}, color = {0, 0, 127}));
  connect(T_mea, idealMassflowBlockCalculation.T_mea) annotation(
    Line(points = {{-108, 48}, {-16, 48}, {-16, 54}, {-14, 54}}, color = {0, 0, 127}));
  connect(T_ref_input.y, idealMassflowBlockCalculation.T_ref) annotation(
    Line(points = {{-46, 26}, {-4, 26}, {-4, 44}, {-4, 44}}, color = {0, 0, 127}));
  connect(idealMassflowBlockCalculation.m_flow, limiter.u) annotation(
    Line(points = {{8, 54}, {38, 54}, {38, 58}, {38, 58}}, color = {0, 0, 127}));
  connect(T_out_receiver, idealMassflowBlockCalculation.T_out_receiver) annotation(
    Line(points = {{0, 112}, {0, 112}, {0, 80}, {-4, 80}, {-4, 66}, {-4, 66}}, color = {0, 0, 127}));  protected
  annotation (Documentation(revisions = "<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"),
    Diagram);
end SimpleReceiverControl;