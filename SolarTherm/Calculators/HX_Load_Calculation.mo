within SolarTherm.Calculators;

model HX_Load_Calculation "Calculates the heat exchanger load and checks temperature profiles"
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Blocks.Math;

  replaceable package Medium_Hot = SolarTherm.Media.MoltenSalt.MoltenSalt_ph; 
  replaceable package Medium_Cold = Modelica.Media.Water.WaterIF97_ph; //Process input fluid

  //Discretisation
  parameter Integer N = 101 "Number of heat exchanger elements";
  
  //Ambient pressure
  parameter SI.Pressure p_amb = 101325.0 "Ambient pressure (Pa)";
   
  //Process Requirements (Cold Stream)
  parameter SI.Temperature T_C_in = Medium_Cold.saturationTemperature(p_C_in) - 1.0 "Process return temperature (K)";
  parameter SI.Temperature T_C_out = 340.0 + 273.15 "Process input requirement temperature (K)";
  
  parameter SI.Pressure p_C_in = p_amb "Process return absolute pressure (Pa)";
  parameter SI.Pressure p_C_out = 105.0e5 "Process input absolute pressure (Pa)";
  
  parameter SI.MassFlowRate m_flow_C = 210.0 * (1000.0/3600.0) "Process required mass flow rate (kg/s)";
  
  //Calculated Process Requirements
  parameter Medium_Cold.ThermodynamicState state_C_in = Medium_Cold.setState_pTX(p_C_in,T_C_in);
  parameter Medium_Cold.ThermodynamicState state_C_out = Medium_Cold.setState_pTX(p_C_out,T_C_out);
  
  parameter SI.SpecificEnthalpy h_C_in = Medium_Cold.specificEnthalpy(state_C_in);
  parameter SI.SpecificEnthalpy h_C_out = Medium_Cold.specificEnthalpy(state_C_out);
  
  parameter SI.HeatFlowRate Q_flow_C = m_flow_C*(h_C_out - h_C_in);
  parameter SI.HeatFlowRate Q_flow_HX = Q_flow_C;
  
  //parameter SI.HeatFlowRate dQ_flow_HX = Q_flow_HX/(N-1);
  
  //Hot Stream Requirements
  parameter SI.Temperature T_H_in = 500.0 + 273.15 "Hot Stream inlet temperature (K)";
  parameter SI.Temperature T_H_out = 290.0 + 273.15 "Hot Stream outlet temperature (K)";
  parameter SI.Pressure p_H_in = p_amb "Process return absolute pressure (Pa)";
  parameter SI.Pressure p_H_out = p_amb "Process input absolute pressure (Pa)";
  
  //Calculated Hot Stream Conditions
  parameter Medium_Hot.ThermodynamicState state_H_in = Medium_Hot.setState_pTX(p_H_in,T_H_in);
  parameter Medium_Hot.ThermodynamicState state_H_out = Medium_Hot.setState_pTX(p_H_out,T_H_out);
  
  parameter SI.SpecificEnthalpy h_H_in = Medium_Hot.specificEnthalpy(state_H_in);
  parameter SI.SpecificEnthalpy h_H_out = Medium_Hot.specificEnthalpy(state_H_out);
  
  parameter SI.MassFlowRate m_flow_H = Q_flow_HX/(h_H_in - h_H_out) "Hot Stream required mass flow rate (kg/s)";
  
equation
  //for 
  //state_C.
    

annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 120, StartTime = 0, Tolerance = 1.0e-5, Interval = 1, maxStepSize = 1, initialStepSize = 1));
end HX_Load_Calculation;