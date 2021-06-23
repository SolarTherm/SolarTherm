within SolarTherm.Models.Storage;
model eNTU
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;

  // Storage
  parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Storage/Thermocline.motab");
  Modelica.Blocks.Tables.CombiTable1Ds Table_Charging (tableOnFile=true, tableName="table_charging", columns=2:2, fileName=table_file);
  Modelica.Blocks.Tables.CombiTable1Ds Table_Discharging (tableOnFile=true, tableName="table_discharging", columns=2:2, fileName=table_file);

  //replaceable package Storage = SolarTherm.Materials.Graphite "the storage medium";
  parameter Modelica.SIunits.Temperature T_min = 500 + 273.15 "start temperature of the storage medium";
  parameter Modelica.SIunits.Temperature T_max = 720 + 273.15 "the maximum temperature of the storage medium";

  //parameter Modelica.SIunits.Mass m_st=E_max/(h_max - h_0) "total mass of the storage medium";
  parameter Modelica.SIunits.Energy E_max;
  // HTF
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "heat transfer medium";
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium_Table "fluid material package";

  parameter Modelica.SIunits.Temperature h_max = Fluid_Package.h_Tf(T_max, 1.0) "the maximum enthalpy of the storage medium";
  parameter Modelica.SIunits.Temperature h_min = Fluid_Package.h_Tf(T_min, 0.0) "the initial enthalpy of the storage medium";


  Modelica.SIunits.Temperature T_in;
  Modelica.SIunits.Temperature T_out;
  Modelica.SIunits.SpecificEnthalpy h_in;
  Modelica.SIunits.SpecificEnthalpy h_out;
  Fluid_Package.State fluid_in "Property calculation of inlet";
  Fluid_Package.State fluid_out "Property calculation of outlet";
  // energy balance
 Modelica.SIunits.MassFlowRate m_flow "mass flow with respect to height direction";
  Modelica.SIunits.Energy E_stored(start = L_start * E_max);
  //Modelica.SIunits.Power Q_st "the rate of energy that is stored";
  /*Modelica.Blocks.Interfaces.RealOutput flow_dir "flow dirction, 1 charging, -1 discharging" annotation(
    Placement(visible = true, transformation(origin = {-45, 9}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-68, -4.44089e-16}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));*/

  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-35, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput level(start = 0) "level of the storage, level=E/Emax, 0 to 1" annotation(
    Placement(visible = true, transformation(origin = {-45, -9}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-31, 43}, extent = {{7, -7}, {-7, 7}}, rotation = -90)));

  //Regression curve of effectiveness
  parameter Real L_start = 0.1900 "Starting storage level";
  Real L(start = L_start) "Tank Level";
  Real e_out "Nondimensional outlet temperature effectiveness";
  //Real e_top "Nondimensional top temperature effectiveness";
  Real e_bot "Nondimensional bot temperature effectiveness if it were to flow out of bottom";

  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation(
    Placement(visible = true, transformation(origin = {48, 8.88178e-16}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {46, 0}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));

equation
  //Table inputs
  Table_Charging.u = L;
  Table_Discharging.u = L;
  
//Theoretical bottom outlet effectiveness
  e_bot = min(1.0,Table_Charging.y[1]);

//effectiveness calculations
  m_flow = -1.0*fluid_a.m_flow; 
  if m_flow > 0.0 then //flowing upwards so discharge
    h_in = inStream(fluid_b.h_outflow);
    fluid_b.h_outflow = h_in;
    fluid_a.h_outflow = h_out;
    der(E_stored) = m_flow*(inStream(fluid_b.h_outflow)-fluid_a.h_outflow);

    e_out = min(1.0,Table_Discharging.y[1]);

    
    T_out = T_min + e_out*(T_max-T_min);
    h_bot_outlet = h_min;
    //h_bot_outlet = Fluid_Package.h_Tf(T_max - e_bot*(T_max-T_min), 0.0);
  else //fluid flowing downwards so charging
    h_in = inStream(fluid_a.h_outflow);
    fluid_a.h_outflow = h_in;
    fluid_b.h_outflow = h_out;
    der(E_stored) = -1.0*m_flow*(inStream(fluid_a.h_outflow)-fluid_b.h_outflow);
    
    e_out = e_bot;
    
    T_out = T_max - e_out*(T_max-T_min);
    //h_bot_outlet = h_out;
    h_bot_outlet = Fluid_Package.h_Tf(T_out, 0.0);
  end if;
  L = E_stored/E_max;
  level = L;

  fluid_in.h = h_in;
  T_in = fluid_in.T;
  
  fluid_out.T = T_out;
  h_out = fluid_out.h;
  
  fluid_a.m_flow + fluid_b.m_flow = 0;
  
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;

  annotation(
    Icon(graphics = {Text(origin = {1, 4}, extent = {{-27, 32}, {27, -32}}, textString = "Reg")}));

/*
  Modelica.Blocks.Interfaces.RealOutput T_HTF_bot(unit="K") "HTF temperature at the bottom of the storage unit" annotation( 
    Placement(visible = true, transformation(origin = {-43, -35}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-68, -16}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput T_HTF_top(unit="K") "HTF temperature at the top of the storage unit" annotation( 
    Placement(visible = true, transformation(origin = {-41, 33}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-67, 17}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
initial equation
Storage_State.h = h_0;
//T_st=T_0;

equation

  if level < 5 then eff=0.01;
  elseif level >90 then eff=0.01;
  else eff=eff_constant;
  end if;
  //eff=0.83047-17.2411*(m_flow/A)+184.522*(m_flow/A)^2-1038.48*(m_flow/A)^3+3022.2*(m_flow/A)^4-4065.01*(m_flow/A)^5+1717.23*(m_flow/A)^6; 

  state_out=Medium.setState_pTX(p_amb,T_out);
  state_in=Medium.setState_phX(p_amb,h_in);
  T_in=Medium.temperature(state_in);
  h_out=Medium.specificEnthalpy(state_out);
  h_bot_outlet = Medium.specificEnthalpy( Medium.setState_pTX(p_amb,T_HTF_bot) );  
  //state_out=Medium.setState_phX(p_amb,h_out);
  //T_out=Medium.temperature(state_out);
  
  h_in= if fluid_a.m_flow>=0 then inStream(fluid_a.h_outflow) else inStream(fluid_b.h_outflow); 
  T_HTF_top= if fluid_a.m_flow>=0 then T_in else T_out;
  T_HTF_bot= if fluid_a.m_flow>=0 then T_out else T_in;  
  fluid_a.h_outflow= if fluid_a.m_flow>=0 then h_in else h_out;  
  fluid_b.h_outflow= if fluid_a.m_flow>=0 then h_out else h_in;    
  flow_dir = if fluid_a.m_flow>=0 then 1 else -1; 

  
  fluid_a.m_flow+fluid_b.m_flow=0;
  m_flow=abs(fluid_a.m_flow);
  fluid_a.p=p_amb;
  fluid_b.p=p_amb;

  if fluid_a.m_flow>=0 then //charging
    eff=(T_in-T_out)/(T_in-T_0);
  else
    eff=(T_in-T_out)/(T_in-T_max);
  end if;
  
  fluid_in.h = h_in;
  T_in = fluid_in.T;
  
  fluid_out.T = T_out;
  h_out = fluid_out.h;
  
  fluid_a.m_flow + fluid_b.m_flow = 0;
  
  fluid_a.p = p_amb;
  fluid_b.p = p_amb;

  Storage_State.h = h_st;
  Storage_State.T=T_st;
  */
end eNTU;