within SolarTherm.Models.Control;
model SB_PowerBlockControl
  extends Icons.Control;
  //replaceable package HTF = SolarTherm.Media.Sodium.Sodium_ph;
  parameter Real T_df_on=1123 "Level of start defocus"; //recv
  parameter Real T_df_off=1098 "Level of stop defocus"; //recv
  parameter Real T_on=1048 "Temp of start discharge"; //PB
  parameter Real T_off=1023 "Temp of stop discharge"; //PB
  
  parameter Real m_flow_ref = 10.0 "Design heat flow rate into power block";
  Real h_fg;
  Real PB_load;
  
  Modelica.Blocks.Interfaces.RealInput T_stor(start=1023) "Temperature of the HTF in storage"
    annotation (Placement(visible = true, transformation(extent = {{-126, -20}, {-86, 20}}, rotation = 0), iconTransformation(extent = {{-126, -20}, {-86, 20}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealOutput m_flow_PB(start=0.0) "Power block mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, -20}, {130, 20}}, rotation = 0), iconTransformation(extent = {{90, -20}, {130, 20}}, rotation = 0))) ;


algorithm

  //PB
  when T_stor > T_on then
    PB_load := 1.0;
  end when;
  when T_stor < T_off then
    PB_load := 0.0;
  end when;

equation
  h_fg = SolarTherm.Media.Sodium.Sodium_utilities.h_fg_T(T_stor);
  m_flow_PB = PB_load*(m_flow_ref);

end SB_PowerBlockControl;