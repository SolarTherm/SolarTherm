within SolarTherm.Models.Fluid.HeatExchangers;

model HeatExchanger_ParticleGasIndirect_BU
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
import MedGas = Modelica.Media.IdealGases.Common.Functions;

  function LMTD
    input SI.Temperature T_hot_in;
    input SI.Temperature T_hot_out;
    input SI.Temperature T_cold_in;
    input SI.Temperature T_cold_out;
    output Real LMTD;
  protected
    Real delta_T1 = T_hot_in - T_cold_out;
    Real delta_T2 = T_hot_out - T_cold_in;
  algorithm
    LMTD := (delta_T1 - delta_T2) / Modelica.Math.log(delta_T1 / delta_T2);
  end LMTD;

  import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
  /*Neural Network*/
  parameter String saved_model_dir = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/SurrogateModels/IndirectParticleGasHX/H2/surrogate_model");
  parameter Boolean use_neural_network = true;
  parameter Integer inputsize = 14;
  parameter Integer outputsize = 1;
  parameter Real[inputsize] X_max = {353.1470666728751, 973.136415157254, 9.99989300901777, 1073.135375340895, 823.1488443601027, 0.0049982434608095, 0.0599889501544534, 0.0099985253043193, 0.9999758193269492, 9.999433304010232, 1073.140341535585, 353.1499808634883, 1016.8881815988534, 1072.2531304063823};
  parameter Real[inputsize] X_min = {343.1507218714416, 823.1631592504178, 0.50046924794229, 1023.1510490314196, 773.1502816172183, 0.0001003545952207, 0.0020011338910917, 0.000500120796042, 0.050052042052682, 0.5005396146048189, 973.1794965849724, 353.0500167803593, 353.05006906450353, 359.18953610315253};
  parameter Real out_max = 99.99579509501083;
  parameter Real out_min = 1.008158779023168;
  STNeuralNetwork session = STNeuralNetwork(saved_model_dir) if use_neural_network == true "Initialise neural network session if use_neural_network == true";
  /*Pcl properties*/
  replaceable package PCL = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  replaceable package Med_PCL = SolarTherm.Media.SolidParticles.CarboHSP_ph;
  /*Gas properties*/
  replaceable package MedGas2 = Modelica.Media.IdealGases.Common.SingleGasNasa(data = Modelica.Media.IdealGases.Common.SingleGasesData.O2, mediumName = "Hydrogen", fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.O2});
  parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.O2;
  /*Controller parameters*/
  parameter Real level_on = 20;
  parameter Real level_off = 5;
  /*Particle thermophysical properties*/
  parameter SI.Length D_particle = 5e-3 "Particle diameter in m";
  parameter SI.Efficiency eta_particle = 0.403 * (D_particle * 100) ^ 0.14 "Particle volume fraction as a function of DP (source: P45 report)";
  parameter SI.Volume V_particle = 4 / 3 * CN.pi * (D_particle / 2) ^ 3 "Particle volume m3";
  parameter SI.Volume A_particle = 4 * CN.pi * (D_particle / 2) ^ 2 "Particle surface area m2";
  parameter SI.MassFlowRate m_dot_pcl_dp =500;
  
  /*On-design parameters*/
  parameter SI.Temperature T_in_gas_DP = 80 + 273.15 "Design inlet temperature of the gas [K]";
  parameter SI.Temperature T_out_gas_DP = 600 + 273.15 "Design outlet temperature of the gas [K]";
  parameter SI.MassFlowRate m_dot_gas_DP = 0.46 "Design mass flow rate of the gas [kg/s]";
  parameter SI.Temperature T_in_pcl_DP = 800 + 273.15 "Design inlet temperature of the particle [K]";
  parameter SI.Temperature T_out_pcl_DP = 550 + 273.15 "Design outlet temperature of the pcl [K]";
  parameter SI.Length d_gas_pipe = 0.5e-3;
  parameter SI.Length w_ch = 6e-3;
  parameter SI.Length th_wall = 1e-3;
  parameter SI.Area A_plate = 0.1;
  
  /*Off-design conditions*/
  parameter SI.MassFlowRate m_dot_gas_off = m_dot_gas_DP "Mass flow rate of the gas at operational condition [kg/s]";
  SI.Temperature T_in_pcl_off "Inlet temperature of the particle [K]";
  parameter SI.Temperature T_in_gas_off = 80 + 273.15 "Design inlet temperature of the gas [K]";
  parameter SI.Temperature T_out_pcl_off = 550 + 273.15 "Outlet temperature of the particle [K]";
  parameter SI.Temperature T_out_gas_off = T_out_gas_DP "Design inlet temperature of the gas [K]";
  parameter SI.Area A_HX(fixed = false) "A HX [m2]";
   
  
  /*Calculated parameters*/
  SolarTherm.Models.Fluid.HeatExchangers.HeatExchanger_IndirectParticleGas designPoint(
      replaceable package MedGas2 = MedGas2, 
      gas_data = gas_data, 
      T_in_gas_DP = T_in_gas_DP, 
      T_out_gas_DP = T_out_gas_DP, 
      m_dot_gas_DP = m_dot_gas_DP, 
      T_in_pcl_DP = T_in_pcl_DP, 
      T_out_pcl_DP = T_out_pcl_DP, 
      d_gas_pipe = d_gas_pipe, 
      w_ch = w_ch, th_wall = 
      th_wall, 
      A_plate
  );
  
  parameter SI.Power Q_HX_DP = m_dot_gas_DP * (MedGas.h_T(gas_data, T_out_gas_DP) - MedGas.h_T(gas_data, T_in_gas_DP));
    
  parameter SI.MassFlowRate m_dot_pcl_DP = Q_HX_DP / (PCL.h_T(T_in_pcl_DP) - PCL.h_T(T_out_pcl_DP)) "Particles mass flow rate at design point (kg/s)";

  SI.SpecificEnthalpy h_pcl_in;
  SI.SpecificEnthalpy h_pcl_out;
  SI.SpecificEnthalpy h_gas_in;
  SI.SpecificEnthalpy h_gas_out;
  SI.Temperature T_pcl_in;
  SI.Temperature T_pcl_out;
  SI.Power Q_HX "Heat duty HX";
  Real[inputsize] X "input to neural network";
  SI.MassFlowRate m_dot_pcl "mass flow rate of pcl at operation";
  
  Boolean on;
  
  /*Fluid Connection*/
  Modelica.Fluid.Interfaces.FluidPort_a particle_port_in(redeclare package Medium = Med_PCL) annotation(
    Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b particle_port_out(redeclare package Medium = Med_PCL) annotation(
    Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput L_hot_tank annotation(
    Placement(visible = true, transformation(origin = {23, 45}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {23, 45}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {-23, 45}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-23, 45}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput gas_in annotation(
    Placement(visible = true, transformation(origin = {74, -30}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {74, -30}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput gas_out annotation(
    Placement(visible = true, transformation(origin = {-80, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-80, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
initial equation
  /*
    DESIGN POINT CALCULATION
  */
  A_HX = designPoint.A_HX;
equation
  /*
    OFF DESIGN CALCULATION
  */
  when L_hot_tank > level_on then
    on = true;
  elsewhen L_hot_tank < level_off then
    on = false;
  end when;
  h_pcl_in = inStream(particle_port_in.h_outflow);
  T_pcl_in = PCL.T_h(h_pcl_in);
  
  h_gas_in = MedGas.h_T(gas_data, T_in_gas_DP);
  h_gas_out =  MedGas.h_T(gas_data, T_out_gas_DP);
  
  Q_HX = m_dot_gas_DP * (h_gas_out - h_gas_in);
  
  if use_neural_network then
    X = {
        T_in_gas_DP,T_out_gas_DP,
        m_dot_gas_DP, T_in_pcl_DP,
        T_out_pcl_DP, d_gas_pipe,
        w_ch, th_wall,
        A_plate, gas_in,
        T_in_pcl_off,T_in_gas_off,
        T_out_pcl_off, T_out_gas_off
    };
  else
    X = fill(0, inputsize);
  end if;
  
  gas_out = gas_in;
  
  
  if on then
      if use_neural_network then
        m_dot_pcl = predict(session, X, inputsize, X_max, X_min, out_max, out_min);
      else
        m_dot_pcl = m_dot_pcl_DP "Mass flow rate of particle at design point";
      end if;
      
      h_pcl_out = h_pcl_in - Q_HX / particle_port_in.m_flow;
  else
      m_dot_pcl = 0 "Shut down the HX";
      h_pcl_out = PCL.h_T(T_in_pcl_DP);
  end if;
  T_pcl_out = PCL.T_h(h_pcl_out);
  
/*Connection equations*/
  particle_port_in.m_flow = m_dot_pcl;
  particle_port_in.p = particle_port_out.p;
  particle_port_in.m_flow + particle_port_out.m_flow = 0 "Mass balance";
  particle_port_in.h_outflow = inStream(particle_port_out.h_outflow);
  particle_port_out.h_outflow = h_pcl_out;
  
  annotation(
    Diagram(graphics = {Rectangle(origin = {-1, 9}, extent = {{-59, 31}, {61, -49}}), Text(origin = {1, 1}, extent = {{-53, -17}, {51, 17}}, textString = "Indirect Gas Pcl"), Line(origin = {0, -30}, points = {{70, 0}, {-70, 0}, {-70, 0}}), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {0, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-57, 49}, {63, -31}}), Text(origin = {0, 1}, extent = {{-48, -15}, {48, 15}}, textString = "RECUPERATOR"), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {-2, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html>
		<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
<p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
		
		</html>"));
end HeatExchanger_ParticleGasIndirect_BU;