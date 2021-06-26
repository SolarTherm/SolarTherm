within SolarTherm.Models.Storage;
model eNTU
  extends SolarTherm.Interfaces.Models.StorageFluid_Thermocline;
  import SolarTherm.Models.Storage.GenEffectivenessPyFunc;
  
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "heat transfer medium";
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium_Table "fluid material package";
  //replaceable package Storage = SolarTherm.Materials.Graphite "the storage medium";
  
  parameter Real t_storage(unit = "h") = 8.0 "Hours of storage";
  parameter SI.Power P_gross = 100.0e6 "Nameplate power block";
  parameter Real eff_PB = 0.51 "Power block heat to electricity conversion efficiency";
  parameter Modelica.SIunits.Energy E_max;    
  parameter Modelica.SIunits.Temperature T_min = 510 + 273.15 "start temperature of the storage medium";
  parameter Modelica.SIunits.Temperature T_max = 740 + 273.15 "the maximum temperature of the storage medium";  

  // Storage
  //parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Storage/Thermocline.motab");
  parameter String table_file(fixed=false);
  parameter String ppath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Absolute path to the Python script";
  parameter String pname = "run_storage" "Name of the Python script";
  parameter String pfunc = "get_effectiveness" "Name of the Python functiuon"; 
  parameter String psave = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Storage") "the directory for saving the results"; 
  parameter String modelicapath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Models/Storage") ;
  parameter Integer argc =1 "Number of variables to be passed to the C function";

  Modelica.Blocks.Tables.CombiTable1Ds Table_Charging (tableOnFile=true, tableName="table_charging", columns=2:2, fileName=table_file);

  Modelica.Blocks.Tables.CombiTable1Ds Table_Discharging (tableOnFile=true, tableName="table_discharging", columns=2:2, fileName=table_file);
  parameter Real[1] metadata_list = SolarTherm.Utilities.Metadata_reader(table_file);
  parameter Real C_storage = metadata_list[1];
  // HTF
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

  Modelica.Blocks.Interfaces.RealOutput h_bot_outlet "Enthaply at the bottom of the tank as an output signal (K)" annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-35, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput level(start = 0) "level of the storage, level=E/Emax, 0 to 1" annotation(
    Placement(visible = true, transformation(origin = {-45, -9}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {-31, 67}, extent = {{7, -7}, {-7, 7}}, rotation = -90)));

  //Regression curve of effectiveness
  parameter Real L_start = 0.1900 "Starting storage level";
  Real L(start = L_start) "Tank Level";
  Real e_out "Nondimensional outlet temperature effectiveness";
  Real e_bot "Nondimensional bot temperature effectiveness if it were to flow out of bottom";

  Modelica.Blocks.Interfaces.RealInput p_amb "Ambient Pressure" annotation(
    Placement(visible = true, transformation(origin = {48, 8.88178e-16}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {46, 0}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));

initial algorithm
table_file := GenEffectivenessPyFunc(ppath, pname, pfunc, psave, modelicapath, argc, {"t_storage"}, {t_storage}); 

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
    Icon(coordinateSystem(initialScale = 0.1)));

end eNTU;
