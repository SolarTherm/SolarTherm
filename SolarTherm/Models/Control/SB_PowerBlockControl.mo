within SolarTherm.Models.Control;
model SB_PowerBlockControl
  extends Icons.Control;
  //replaceable package HTF = SolarTherm.Media.Sodium.Sodium_ph;
  parameter Real T_on=1048 "Temp of start discharge"; //PB
  parameter Real T_off=1023 "Temp of stop discharge"; //PB
  
  parameter Real m_flow_ref = 10.0 "Design heat flow rate into power block";
  Real PB_load;
  
  Modelica.Blocks.Interfaces.RealInput T_stor "Temperature of the HTF in storage"
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
  m_flow_PB = max(PB_load*(m_flow_ref),1e-4);

end SB_PowerBlockControl;