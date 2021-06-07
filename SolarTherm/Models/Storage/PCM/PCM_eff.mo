within SolarTherm.Models.Storage.PCM;
model PCM_eff
  extends SolarTherm.Interfaces.Models.PCMshortInterface;
  
  //Redeclare medium
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT;
    
  //parameter Modelica.SIunits.Area A;
  parameter Modelica.SIunits.Energy E_max;  
  //parameter Modelica.SIunits.Temperature T_0=520+273.15 "start temperature of PCM";
  parameter Modelica.SIunits.Mass m_pcm=E_max/L_pcm;  
  parameter Modelica.SIunits.SpecificEnthalpy L_pcm=Salt.L_melting;
  parameter Modelica.SIunits.Temperature T_melting=Salt.T_melting;

  SolarTherm.Models.Storage.PCM.PCMsalt.Na2CO3_NaCl Salt;
  
  Salt.State salt = Salt.setState_T(T_pcm);

  Modelica.SIunits.Temperature T_out;
  Modelica.SIunits.Temperature T_pcm(final start=520+273.15);
  Modelica.SIunits.Temperature T_in=Medium.temperature(state_in);

  Modelica.SIunits.SpecificEnthalpy h_in;
  Modelica.SIunits.SpecificEnthalpy h_out=Medium.specificEnthalpy(state_out);
  Medium.ThermodynamicState state_in=Medium.setState_phX(p_amb, h_in);
  Medium.ThermodynamicState state_out=Medium.setState_pTX(p_amb,T_out);

  Modelica.SIunits.Power Q_ex "the rate of energy exchanged between the HTF and PCM";
  Modelica.SIunits.MassFlowRate m_flow "mass flow rate of the HTF";
  Modelica.SIunits.Energy E(final start=0) "energy that is stored";
  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation (Placement(
        visible = true,transformation(
        
        origin={48, 8.88178e-16},extent={{10, -10}, {-10, 10}},
        rotation=0), iconTransformation(
        
        origin={66, 0},extent={{6, -6}, {-6, 6}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput level(start=0) "level of storage" annotation (Placement(visible = true, transformation(origin = {-41, -1}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-68, -4.44089e-16}, extent = {{8, -8}, {-8, 8}}, rotation = 0))) ;
  
  
  Modelica.SIunits.SpecificHeatCapacity cp_pcm;
  Real eff "Effectiveness";
  Boolean b_solid "boolean, solid or not";
  Boolean b_melting "boolean, melting or not";
  Boolean b_freezing "boolean, freezing or not";
  Boolean phasechanging "boolean, phase changing or not";
  //Real level=E/E_max "level of energy storage, state of charge";

protected
  parameter Real eps=1e-3;

initial equation
  b_melting=false;
  b_freezing=false;
  
equation
  level=E/E_max;
  h_in= if fluid_a.m_flow>=0 then inStream(fluid_a.h_outflow) else inStream(fluid_b.h_outflow);
  fluid_a.m_flow+fluid_b.m_flow=0;
  m_flow=abs(fluid_a.m_flow);

  fluid_a.p = p_amb;
  fluid_b.p = p_amb;
  
  fluid_a.h_outflow=h_out;
  fluid_b.h_outflow=h_out;

  Q_ex=m_flow*(h_in-h_out);
  eff=(T_in-T_out)/(T_in-T_pcm);
  //eff=0.83047-17.2411*(m_flow/A)+184.522*(m_flow/A)^2-1038.48*(m_flow/A)^3+3022.2*(m_flow/A)^4-4065.01*(m_flow/A)^5+1717.23*(m_flow/A)^6;
  eff=0.85;
  
  b_solid= (T_pcm<T_melting);

  when (abs(T_pcm-T_melting)<=eps) and (Q_ex>=0) then
    b_melting =true;
  elsewhen (E>=E_max) or (Q_ex<=0) then
    b_melting = false;
  end when;

   when (abs(T_pcm-T_melting)<=eps) and (Q_ex<=0) then
     b_freezing = true;
   elsewhen (E<=0) or (Q_ex>=0) then
     b_freezing = false;
   end when;

   phasechanging=b_melting or b_freezing;

   if b_solid then
     cp_pcm=Salt.specificHeat_solid(salt);
   else
     cp_pcm=Salt.specificHeat_liquid(salt);
   end if;

   der(E)=Q_ex;
   
   if phasechanging then
     der(T_pcm)=0;   
   else
     Q_ex=m_pcm*cp_pcm*der(T_pcm);
   end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(origin = {69, 10}, extent = {{-7, 4}, {7, -4}}, textString = "p_amb")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PCM_eff;