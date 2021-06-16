within SolarTherm.Models.Storage;
model eNTU
  extends SolarTherm.Interfaces.Models.PCMshortInterface;

  //parameter Medium.AbsolutePressure p_amb = 101325;
  
  // Storage
  replaceable package Storage = SolarTherm.Materials.Graphite "the storage medium";   
  parameter Modelica.SIunits.Temperature T_0=500+273.15 "start temperature of the storage medium";
  parameter Modelica.SIunits.Temperature T_max=720+273.15 "the maximum temperature of the storage medium";  
  parameter Modelica.SIunits.Temperature h_max=Storage.h_Tf(T_max*0.80,1.0) "the maximum enthalpy of the storage medium";    
  parameter Modelica.SIunits.Temperature h_0=Storage.h_Tf(T_0,0.0) "the initial enthalpy of the storage medium";     
  parameter Modelica.SIunits.Mass m_st=E_max/(h_max - h_0) "total mass of the storage medium";
  parameter Modelica.SIunits.Energy E_max;  
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

  // energy balance
  Modelica.SIunits.Power Q_st "the rate of energy that is stored";
  Modelica.SIunits.MassFlowRate m_flow;
  Modelica.SIunits.Energy E(final start=0); 
  parameter Real eff_constant = 0.85; 
  Real eff "effectiveness";
  Storage.State PCM_State "PCM state object";
  

  Modelica.Blocks.Interfaces.RealOutput level(start = 0) "level of the storage, level=E/Emax" annotation(
    Placement(visible = true, transformation(origin = {-41, -1}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-68, -4.44089e-16}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
initial equation

PCM_State.h = h_0;
//T_st=T_0;

equation
  eff=eff_constant;
  h_in= if fluid_a.m_flow>0 then inStream(fluid_a.h_outflow) else inStream(fluid_b.h_outflow);
  fluid_a.m_flow+fluid_b.m_flow=0;
  m_flow=abs(fluid_a.m_flow);
  fluid_a.p=p_amb;
  fluid_b.p=p_amb;

  fluid_a.h_outflow=h_out;
  fluid_b.h_outflow=h_out;

  Q_st=m_flow*(h_in-h_out);
  eff=(T_in-T_out)/(T_in-T_st);
  //eff=0.83047-17.2411*(m_flow/A)+184.522*(m_flow/A)^2-1038.48*(m_flow/A)^3+3022.2*(m_flow/A)^4-4065.01*(m_flow/A)^5+1717.23*(m_flow/A)^6;
  
  
  der(E)=Q_st;
  der(h_st)*m_st=Q_st;
  //h_st=Storage.h_Tf(T_st);
  level=E/E_max*100;

  PCM_State.h = h_st;
  T_st = PCM_State.T;
  
end eNTU;
