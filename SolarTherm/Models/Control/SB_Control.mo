within SolarTherm.Models.Control;
model SB_Control
  extends Icons.Control;
  parameter Real T_df_on=1123 "Level of start defocus"; //recv
  parameter Real T_df_off=1098 "Level of stop defocus"; //recv
  parameter Real T_on=1048 "Temp of start discharge"; //PB
  parameter Real T_off=1023 "Temp of stop discharge"; //PB
  
  parameter Real m_flow_PB_des = 100;
  Real PB_load;
  
  
  Modelica.Blocks.Interfaces.RealInput T_stor "Temperature of the HTF in storage"
    annotation (Placement(transformation(extent={{-130,40},{-90,80}})));
    Modelica.Blocks.Interfaces.BooleanOutput defocus(start=false) annotation (Placement(visible = true, transformation(origin = {106,0}, extent = {{-12, -10}, {12, 10}}, rotation = 0), iconTransformation(origin = {106,0}, extent = {{-12, -10}, {12, 10}}, rotation = 0)));
  //parameter SI.Time period = 1.0*3600.0;

  Modelica.Blocks.Interfaces.RealOutput m_flow_PB(start=0.0) "Is the power block on?" annotation (Placement(visible = true, transformation(extent = {{92, 20}, {132, 60}}, rotation = 0), iconTransformation(extent = {{92, 20}, {132, 60}}, rotation = 0))) ;


algorithm
  //Recv
  when T_stor > T_df_on then
    defocus := true;
  end when;
  when T_stor < T_df_off then
    defocus := false;
  end when;
  
  //PB
  when T_stor > T_on then
    PB_load := 1.0;
  end when;
  when T_stor < T_off then
    PB_load := 0.0;
  end when;

equation
  m_flow_PB = PB_load*m_flow_PB_des;

end SB_Control;