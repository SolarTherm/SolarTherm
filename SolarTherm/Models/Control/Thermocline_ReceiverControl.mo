within SolarTherm.Models.Control;
model Thermocline_ReceiverControl
  extends Icons.Control;
  replaceable package HTF = SolarTherm.Media.Sodium.Sodium_pT;
  parameter Real T_max=630.0+273.15 "Level where receiver is shut down";
  parameter Real T_df_on=720.0+273.15 "Level of start defocus (balance PB and recv flow)"; //recv
  parameter Real T_df_off=710.0+273.15 "Level of stop defocus"; //recv
  
  parameter Real T_target=740.0+273.15 "Target temperature of receiver outlet";
  parameter Real h_target = HTF.specificEnthalpy(HTF.setState_pTX(101323.0, T_target));
  
  //Real h_input=HTF.specificEnthalpy(HTF.setState_pTX(101323.0,T_stor));
  
  parameter Real Q_flow_recv_des = 5.0e6 "Net design heat output from receiver";
  parameter Real m_flow_recv_des = 1.0e2 "Receiver design mass flow rate";
  
  Modelica.Blocks.Interfaces.RealInput T_stor(start=520+273.15) "Temperature of the HTF in storage"
    annotation (Placement(visible = true, transformation(extent = {{-128, -46}, {-88, -6}}, rotation = 0), iconTransformation(extent = {{-128, -46}, {-88, -6}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput h_PB_outlet "Enthalpy of the HTF coming out of PB"
    annotation (Placement(visible = true, transformation(extent = {{-128, -72}, {-88, -32}}, rotation = 0), iconTransformation(extent = {{-128, -72}, {-88, -32}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput h_tank_outlet "Enthalpy of the HTF coming out of bottom of tank"
    annotation (Placement(visible = true, transformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0), iconTransformation(extent = {{-128, -100}, {-88, -60}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput m_PB_outlet "Mass flow of the HTF coming out of PB"
    annotation (Placement(visible = true, transformation(extent = {{-128, -128}, {-88, -88}}, rotation = 0), iconTransformation(extent = {{-128, -128}, {-88, -88}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput Q_recv_in "Heat input to receiver"
    annotation (Placement(visible = true, transformation(extent = {{-128, 54}, {-88, 94}}, rotation = 0), iconTransformation(extent = {{-128, 54}, {-88, 94}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput Q_loss "Heat input to receiver"
    annotation (Placement(visible = true, transformation(extent = {{-128, 22}, {-88, 62}}, rotation = 0), iconTransformation(extent = {{-128, 16}, {-88, 56}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.BooleanInput net_gain "true if receiver will have net gain in energy"
    annotation (Placement(visible = true, transformation(extent = {{-128, -16}, {-88, 24}}, rotation = 0), iconTransformation(extent = {{-128, -30}, {-88, 10}}, rotation = 0)));
    
    
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
  
  when T_stor < T_max-5.0 then
    critical_shutdown := false;
  end when;
  
equation
/*
  if net_gain == true and critical_shutdown == false then
  //m_flow_recv = max(1e-10,(Q_recv_in+Q_loss)/(h_target-h_input)); //exact
    if m_PB_outlet > 1e-6 then
  m_flow_recv = max(((Q_recv_in+Q_loss) + m_PB_outlet*(h_PB_outlet-h_tank_outlet))/(h_target-h_tank_outlet),1e-4);
    else
      m_flow_recv = max(1e-4,(Q_recv_in+Q_loss)/(h_target-h_tank_outlet));
    end if;
  else
  m_flow_recv = 1e-4;
  end if;
*/
  //Defocus Strategy
  if net_gain == true and critical_shutdown == false and defocus == false then
  //m_flow_recv = max(1e-10,(Q_recv_in+Q_loss)/(h_target-h_input)); //exact
    if m_PB_outlet > 1e-6 then
  m_flow_recv = max(((Q_recv_in+Q_loss) + m_PB_outlet*(h_PB_outlet-h_tank_outlet))/(h_target-h_tank_outlet),1e-4);
    else
      m_flow_recv = max(1e-4,(Q_recv_in+Q_loss)/(h_target-h_tank_outlet));
    end if;
  elseif net_gain == true and critical_shutdown == false and defocus == true then
    m_flow_recv = m_PB_outlet;
  else 
  m_flow_recv = 1e-4;
  end if;
end Thermocline_ReceiverControl;