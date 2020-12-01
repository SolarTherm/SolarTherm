within SolarTherm.Models.Control;
model PBS_ReceiverControl
  extends Icons.Control;
  replaceable package HTF = SolarTherm.Media.Sodium.Sodium_pT;
  parameter SI.Temperature T_target=740.0+273.15 "Target temperature of receiver outlet";
  parameter SI.Temperature T_stor_on=530.0+273.15 "Temperature of the bottom of storage at which it can start discharging"; 
  parameter SI.Temperature T_stor_off=550.0+273.15 "Temperature of the bottom of storage at which it must stop discharging due to receiver inlet T limits";
  
  parameter SI.SpecificEnthalpy h_target = HTF.specificEnthalpy(HTF.setState_pTX(101323.0, T_target)) "Target specific enthalpy of the receiver outlet";

  Modelica.Blocks.Interfaces.RealInput T_stor(start=520+273.15) "Temperature of the HTF at the bottom of storage"
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
    
  Modelica.Blocks.Interfaces.BooleanOutput defocus(start=true) annotation (Placement(visible = true, transformation(origin = {116, -60}, extent = {{-24, -20}, {24, 20}}, rotation = 0), iconTransformation(origin = {116, -60}, extent = {{-24, -20}, {24, 20}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_recv(start=0.0) "Receiver mass flow?" annotation (Placement(visible = true, transformation(extent = {{90, 40}, {130, 80}}, rotation = 0), iconTransformation(extent = {{90, 40}, {130, 80}}, rotation = 0))) ;

  Boolean storage_on(start=true) "can the storage be fed into the receiver?";
  Boolean pb_on(start=false) "is the power block on?";
algorithm
  //Recv
  when T_stor > T_stor_off then //Storage outlet becomes too hot to be pumped into receiver
    storage_on := false;
    defocus := false;
  end when;
  when T_stor < T_stor_on then
    storage_on := true;
    defocus := true;
  end when;

equation
  pb_on = (m_PB_outlet > 1.1e-4);
  if net_gain == true then
    if storage_on == true then //m_flow_recv must be selected such that the receiver outlet temperature is equal to the target
      if pb_on == true then //two flows may merge into one but how to determine?
        if (Q_recv_in+Q_loss)/(h_target-h_PB_outlet) > m_PB_outlet then
          m_flow_recv = (Q_recv_in + Q_loss)/(h_target-(((m_flow_recv-m_PB_outlet)*(h_tank_outlet)+(m_PB_outlet*h_PB_outlet))/(m_flow_recv)));
        else
          m_flow_recv = (Q_recv_in+Q_loss)/(h_target-h_PB_outlet);
        end if;
      else //can only receive inlet from bottom of storage tank, scale mass flow based on receiver input
        m_flow_recv = (Q_recv_in + Q_loss)/(h_target-h_tank_outlet);
      end if;
  
    else //storage cannot be fed into receiver
      if pb_on == true then //fix the receiver mass flow rate to power block and defocus the receiver
        m_flow_recv = m_PB_outlet;
      else 
        m_flow_recv = m_PB_outlet;
      end if;
    end if;
  else
    m_flow_recv = 1e-4;
  end if;
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
/*
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
*/
end PBS_ReceiverControl;