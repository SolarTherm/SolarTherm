within SolarTherm.Models.Control;
model SB_ReceiverControl
  extends Icons.Control;
  //replaceable package HTF = SolarTherm.Media.Sodium.Sodium_ph;
  parameter Real T_max=1123.0 "Level where receiver is shut down";
  parameter Real T_df_on=1118.0 "Level of start defocus"; //recv
  parameter Real T_df_off=1108.0 "Level of stop defocus"; //recv

  
  parameter Real Q_flow_recv_des = 5.0e6 "Net design heat output from receiver";
  parameter Real m_flow_recv_des = 1.0e2 "Receiver design mass flow rate";
  
  Modelica.Blocks.Interfaces.RealInput T_stor(start=1023) "Temperature of the HTF in storage"
    annotation (Placement(visible = true, transformation(extent = {{-128, -80}, {-88, -40}}, rotation = 0), iconTransformation(extent = {{-128, -80}, {-88, -40}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput Q_recv_in "Heat input to receiver"
    annotation (Placement(visible = true, transformation(extent = {{-128, 40}, {-88, 80}}, rotation = 0), iconTransformation(extent = {{-128, 40}, {-88, 80}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.BooleanInput net_gain "true if receiver will have net gain in energy"
    annotation (Placement(visible = true, transformation(extent = {{-128, -16}, {-88, 24}}, rotation = 0), iconTransformation(extent = {{-128, -16}, {-88, 24}}, rotation = 0)));
    
    
  Modelica.Blocks.Interfaces.BooleanOutput defocus(start=false) annotation (Placement(visible = true, transformation(origin = {116, -60}, extent = {{-24, -20}, {24, 20}}, rotation = 0), iconTransformation(origin = {116, -60}, extent = {{-24, -20}, {24, 20}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_recv(start=0.0) "Receiver mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, 40}, {130, 80}}, rotation = 0), iconTransformation(extent = {{90, 40}, {130, 80}}, rotation = 0))) ;

  Boolean critical_shutdown(start=false);
algorithm
  //Recv
  when T_stor > T_df_on then
    defocus := true;
  end when;
  when T_stor < T_df_off then
    defocus := false;
  end when;

  when T_stor > T_max then
    critical_shutdown := true;
  end when;
  
  when T_stor < T_df_on then
    critical_shutdown := false;
  end when;
  
equation
  if net_gain == true and critical_shutdown == false then
  m_flow_recv = m_flow_recv_des*(Q_recv_in/Q_flow_recv_des); //proportional
  else
  m_flow_recv = 0.0;
  end if;

end SB_ReceiverControl;