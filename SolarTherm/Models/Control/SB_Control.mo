within SolarTherm.Models.Control;
model SB_Control
  extends Icons.Control;
  parameter Real T_df_on=1123 "Level of start defocus"; //recv
  parameter Real T_df_off=1098 "Level of stop defocus"; //recv
  parameter Real T_on=1048 "Temp of start discharge"; //PB
  parameter Real T_off=1023 "Temp of stop discharge"; //PB
  
  parameter Real m_flow_PB_des = 100;
  Real PB_load;
  
  
  Modelica.Blocks.Interfaces.RealInput T_stor(start=1023) "Temperature of the HTF in storage"
    annotation (Placement(transformation(extent={{-130,40},{-90,80}})));
    Modelica.Blocks.Interfaces.BooleanOutput defocus(start=false) annotation (Placement(visible = true, transformation(origin = {106,0}, extent = {{-12, -10}, {12, 10}}, rotation = 0), iconTransformation(origin = {106,0}, extent = {{-12, -10}, {12, 10}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput m_flow_rec_guess(start=100) "Guess flow rate of receiver"
    annotation (Placement(visible = true, transformation(extent = {{-130, 8}, {-90, 48}}, rotation = 0), iconTransformation(extent = {{-130, 8}, {-90, 48}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.BooleanInput helio_on(start=false) "Is heliostat on?"
    annotation (Placement(visible = true, transformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0), iconTransformation(extent = {{-130, -32}, {-90, 8}}, rotation = 0)));


  Modelica.Blocks.Interfaces.RealOutput m_flow_PB(start=0.0) "Power block mass flow?" annotation (Placement(visible = true, transformation(extent = {{92, 20}, {132, 60}}, rotation = 0), iconTransformation(extent = {{92, 20}, {132, 60}}, rotation = 0))) ;
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_recv(start=0.0) "Receiver mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, 58}, {130, 98}}, rotation = 0), iconTransformation(extent = {{90, 58}, {130, 98}}, rotation = 0))) ;


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
  m_flow_PB := PB_load*m_flow_PB_des;
  
  if helio_on == true then
    m_flow_recv := m_flow_rec_guess;
  else
    m_flow_recv := 0;
  end if;
equation
  

end SB_Control;