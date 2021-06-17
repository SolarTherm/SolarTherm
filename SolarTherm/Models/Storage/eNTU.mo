within SolarTherm.Models.Storage;
model eNTU
  extends SolarTherm.Interfaces.Models.PCMshortInterface;
	import CN = Modelica.Constants;
  //parameter Medium.AbsolutePressure p_amb = 101325;
  
  // Storage
  replaceable package Storage = SolarTherm.Materials.PCM_550 "the storage medium";   
  parameter Modelica.SIunits.Temperature T_0=500+273.15 "start temperature of the storage medium";
  parameter Modelica.SIunits.Temperature T_max=720+273.15 "the maximum temperature of the storage medium";  
  parameter Modelica.SIunits.SpecificEnthalpy h_max=Storage.h_Tf(T_max,1.0) "the maximum enthalpy of the storage medium";    
  parameter Modelica.SIunits.SpecificEnthalpy h_0=Storage.h_Tf(T_0,0.0) "the initial enthalpy of the storage medium";     
  parameter Modelica.SIunits.Mass m_st=E_max/(h_max - h_0) "total mass of the storage medium";  
  parameter Modelica.SIunits.Energy E_max;  
  //parameter SI.Volume V_max =  m_st/(4200.);
  //parameter Real tank_ar = 20/18.667 "storage aspect ratio";  
  //parameter SI.Length H_storage = ceil(((4*V_max*(tank_ar^2))/(CN.pi))^(1/3)) "Storage tank height";
  //parameter SI.Diameter D_storage = H_storage/tank_ar "Storage tank diameter";
  //parameter Modelica.SIunits.Area A= 2*pi*(D_storage/2)*H_storage;
    Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
        visible = true,transformation(
        
        origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
        rotation=0), iconTransformation(
        
        origin={64, -2},extent={{6, -6}, {-6, 6}},
        rotation=0)));
  Modelica.SIunits.Temperature T_st"tempaerture of the storage medium";
  Modelica.SIunits.SpecificEnthalpy h_st "enthlpy of the sotrage medium";
   
  // HTF
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "heat transfer medium";  

  Modelica.SIunits.SpecificEnthalpy h_in;  
  Medium.ThermodynamicState state_in=Medium.setState_phX(p_amb,h_in);
  Modelica.SIunits.Temperature T_in=Medium.temperature(state_in);
  Modelica.SIunits.Temperature T_out;
  Medium.ThermodynamicState state_out=Medium.setState_pTX(p_amb,T_out);
  Modelica.SIunits.SpecificEnthalpy h_out=Medium.specificEnthalpy(state_out);
  
  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)"
                                          annotation (Placement(visible = true,transformation(
          origin = {-40, -70},extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-39, -39}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));

  // energy balance
  Modelica.SIunits.Power Q_st "the rate of energy that is stored";
  Modelica.SIunits.MassFlowRate m_flow;
  Modelica.SIunits.Energy E(final start=0); 
  parameter Real eff_constant = 0.85; 
  Real eff(start=eff_constant) "effectiveness";
  Storage.State PCM_State "PCM state object";
  
  Modelica.Blocks.Interfaces.RealOutput flow_dir "flow dirction, 1 charging, -1 discharging" annotation(
    Placement(visible = true, transformation(origin = {-45, 9}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-68, -4.44089e-16}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput level(start = 0) "level of the storage, level=E/Emax" annotation(
    Placement(visible = true, transformation(origin = {-45, -9}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-31, 43}, extent = {{7, -7}, {-7, 7}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput T_HTF_bot(unit="K") "HTF temperature at the bottom of the storage unit" annotation( 
    Placement(visible = true, transformation(origin = {-43, -35}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-68, -16}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_HTF_top(unit="K") "HTF temperature at the top of the storage unit" annotation( 
    Placement(visible = true, transformation(origin = {-41, 33}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-67, 17}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));

initial equation
PCM_State.h = h_0;
//T_st=T_0;
equation
 eff=eff_constant;
  /*
  //h_in= if fluid_a.m_flow>0 then inStream(fluid_a.h_outflow) else inStream(fluid_b.h_outflow);
  
  if fluid_a.m_flow>=0 then //charging deletd "="
    h_in=inStream(fluid_a.h_outflow);
    T_HTF_top=T_in;
    T_HTF_bot=T_out;
    
    //T_HTF_top = T_st;
    //T_HTF_bot = (1-eff)*T_max + eff*T_st;
   // T_HTF_top = (1-eff)*T_0 + eff*T_st; //Top outlet if T_min were to be fed at the bottom
  else //discharging
    h_in=inStream(fluid_b.h_outflow);
    T_HTF_top=T_out;
    T_HTF_bot=T_in;
    
    //T_HTF_bot=(1-eff)*T_max + eff*T_st; //Bottom outlet if T_max were to be fed into the top
    //T_HTF_top = (1-eff)*T_0 + eff*T_st; //Top outlet if T_min were to be fed at the bottom
    //T_HTF_bot = T_st;
  end if;  
  */

  h_in= if fluid_a.m_flow>=0 then inStream(fluid_a.h_outflow) else inStream(fluid_b.h_outflow); 
  T_HTF_top= if fluid_a.m_flow>=0 then T_in else T_out;
  T_HTF_bot= if fluid_a.m_flow>=0 then T_out else T_in;  
  fluid_a.h_outflow= if fluid_a.m_flow>=0 then h_in else h_out;  
  fluid_b.h_outflow= if fluid_a.m_flow>=0 then h_out else h_in;    
  flow_dir = if fluid_a.m_flow>=0 then 1 else -1; 
  h_bot_outlet = Medium.specificEnthalpy( Medium.setState_pTX(p_amb,T_HTF_bot) );
  
  fluid_a.m_flow+fluid_b.m_flow=0;
  m_flow=abs(fluid_a.m_flow);
  fluid_a.p=p_amb;
  fluid_b.p=p_amb;

  /*
  fluid_a.h_outflow=h_out;
  fluid_b.h_outflow=h_out;
  */
  /*
  if fluid_a.m_flow>=0 then //charging
    fluid_a.h_outflow =h_in;
    fluid_b.h_outflow=h_out;
  else
    fluid_a.h_outflow = h_out;
    fluid_b.h_outflow = h_in;
  end if;
  */

  if fluid_a.m_flow>=0 then //charging
    eff=(T_in-T_out)/(T_in-T_0);
  else
    eff=(T_in-T_out)/(T_in-T_max);
  end if;
  
  Q_st=m_flow*(h_in-h_out);
  //eff=(T_in-T_out)/(T_in-T_st);
  //eff=0.83047-17.2411*(m_flow/A)+184.522*(m_flow/A)^2-1038.48*(m_flow/A)^3+3022.2*(m_flow/A)^4-4065.01*(m_flow/A)^5+1717.23*(m_flow/A)^6;
  
  
  der(E)=Q_st;
  der(h_st)*m_st=Q_st;
  //h_st=Storage.h_Tf(T_st);
  level=E/E_max*100;

  PCM_State.h = h_st;
  T_st = PCM_State.T;
  
end eNTU;