within SolarTherm.Models.Fluid.HeatExchangers;

model HeatExchanger_ParticleGasIndirect
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MedGas = Modelica.Media.IdealGases.Common.Functions;
  import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
  
  replaceable package PCL = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  
  replaceable package Med_PCL = SolarTherm.Media.SolidParticles.CarboHSP_ph;
  
  replaceable package MedGas2 = Modelica.Media.IdealGases.Common.SingleGasNasa(
        data = Modelica.Media.IdealGases.Common.SingleGasesData.O2, 
        mediumName = "Hydrogen", fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.O2}
  ); 
  
  parameter Modelica.Media.IdealGases.Common.DataRecord gas_data = Modelica.Media.IdealGases.Common.SingleGasesData.O2;
  
  /*Neural Network*/
  parameter String saved_model_dir = Modelica.Utilities.Files.loadResource(
      "modelica://SolarTherm/Data/SurrogateModels/IndirectParticleGasHX/H2/surrogate_model"
  );
  parameter Boolean use_neural_network = true;
  parameter Integer inputsize = 14;
  parameter Integer outputsize = 1;
  parameter Real[inputsize] X_max = {873.147608736259, 1261.78929155903, 4.99874743580914, 1273.13856914357, 973.140145246266, 0.004999810880909, 0.059989212153262, 0.009999872519837, 0.999594690837943, 4.99848048118983, 1273.12769197071, 873.148855294655, 9528.33599417378, 3344.86768214966};
  parameter Real[inputsize] X_min = {863.152208048605, 883.216016729446, 0.300902007162029, 1023.35331623183, 773.22731757903, 0.000100141721352, 0.002038008911878, 0.000501216437113, 0.050087863490287, 0.301800982674091, 1023.19701709183, 863.151268150423, 34.633804858446, 176.628395023518};
  parameter Real out_max = 99.99579509501083;
  parameter Real out_min = 1.008158779023168;
  STNeuralNetwork session = STNeuralNetwork(saved_model_dir) if use_neural_network == true 
  "Initialise neural network session if use_neural_network == true";
  
  /*On-design parameters*/
  parameter SI.Temperature T_in_gas_DP = 80 + 273.15 "Design inlet temperature of the gas [K]";
  parameter SI.Temperature T_out_gas_DP = 600 + 273.15 "Design outlet temperature of the gas [K]";
  parameter SI.MassFlowRate m_dot_gas_DP = 0.46 "Design mass flow rate of the gas [kg/s]";
  parameter SI.MassFlowRate m_dot_gas_recycle = 1 "Recycled gas to push Fe production";
  parameter SI.Temperature T_in_pcl_DP = 800 + 273.15 "Design inlet temperature of the particle [K]";
  parameter SI.Temperature T_out_pcl_DP = 550 + 273.15 "Design outlet temperature of the pcl [K]";
  parameter SI.Length d_gas_pipe = 0.5e-3;
  parameter SI.Length w_ch = 6e-3;
  parameter SI.Length th_wall = 1e-3;
  parameter SI.Area A_plate = 0.1;
  
  /*Off-design conditions*/
  parameter SI.Temperature T_in_gas_off = 80 + 273.15 "Design inlet temperature of the gas [K]";
  parameter SI.Temperature T_out_pcl_off = 550 + 273.15 "Outlet temperature of the particle [K]";
  parameter SI.Temperature T_out_gas_off = T_out_gas_DP "Design inlet temperature of the gas [K]";
  parameter SI.Area A_HX(fixed = false) "A HX [m2]"; 
  parameter SI.MassFlowRate m_dot_pcl_DP(fixed=false) "HX design heat rating";
  SI.Temperature T_in_pcl_off "Inlet temperature of the particle [K]";
  
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
      w_ch = w_ch, th_wall = th_wall, 
      A_plate = A_plate
  );
  
  SI.MassFlowRate m_dot_pcl "Mass flow rate of the particle predicted by NN [kg/s]";
  Boolean on;
  Real[inputsize] X "input to neural network";
  Modelica.Blocks.Interfaces.BooleanInput on_discharge annotation(
    Placement(visible = true, transformation(origin = {30, 42}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {30, 42}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));  
  
  /*Fluid Connection*/
  Modelica.Fluid.Interfaces.FluidPort_a particle_port_in(redeclare package Medium = Med_PCL) annotation(
      Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b particle_port_out(redeclare package Medium = Med_PCL) annotation(
      Placement(visible = true, transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput gas_in annotation(
    Placement(visible = true, transformation(origin = {74, -30}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {74, -30}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput gas_out annotation(
    Placement(visible = true, transformation(origin = {-80, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-80, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));   


initial equation
  A_HX = designPoint.A_HX;
  m_dot_pcl_DP = designPoint.m_dot_pcl_DP;

equation
  if on_discharge then
    on = true;
  else
    on = false;
  end if;
  
  T_in_pcl_off = PCL.T_h(
      inStream(particle_port_in.h_outflow)
  );
  
  if use_neural_network then
    X = {
        T_in_gas_DP, T_out_gas_DP, m_dot_gas_DP, T_in_pcl_DP, T_out_pcl_DP,
        d_gas_pipe, w_ch, th_wall, A_plate, gas_in,
        T_in_pcl_off, T_in_gas_off,T_out_pcl_off, T_out_gas_off
    };
  else
    X = fill(0, inputsize);
  end if; 
  
  if on then
    m_dot_pcl = predict(session, X, inputsize, X_max, X_min, out_max, out_min);
  else
    m_dot_pcl = 0;
  end if;
  
  particle_port_in.m_flow = m_dot_pcl;
  
  gas_out = gas_in;
  
  particle_port_out.m_flow + particle_port_in.m_flow = 0;
  particle_port_in.p = particle_port_out.p;
  particle_port_in.h_outflow = inStream(particle_port_out.h_outflow);
  particle_port_out.h_outflow = PCL.h_T(T_out_pcl_off);
  
 
  annotation(
    Diagram(graphics = {Rectangle(origin = {-1, 9}, extent = {{-59, 31}, {61, -49}}), Text(origin = {1, 1}, extent = {{-53, -17}, {51, 17}}, textString = "Indirect Gas Pcl"), Line(origin = {0, -30}, points = {{70, 0}, {-70, 0}, {-70, 0}}), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {0, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
    Icon(graphics = {Rectangle(origin = {-3, -9}, extent = {{-57, 49}, {63, -31}}), Text(origin = {0, 1}, extent = {{-48, -15}, {48, 15}}, textString = "RECUPERATOR"), Line(origin = {0, 30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Line(origin = {0, -30}, points = {{-70, 0}, {70, 0}, {70, 0}}), Polygon(origin = {0, 30}, points = {{-4, 4}, {-4, -4}, {4, 0}, {-4, 4}, {-4, 4}}), Polygon(origin = {-2, -30}, points = {{4, 4}, {4, -4}, {-4, 0}, {4, 4}, {4, 4}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html>
		<p>This heat recuperator is a counter-flow HX. Closure equations are based on the equality of m_flow*delta_H for both sides and m_flow*delta_H= UA_i*DTAve_i, DTAve being the average of the temperature difference between the inlet and the outlet of the sub-HX.</p>
<p>The UA_i must be given as parameters from the on-design analysis.&nbsp;</p>
		
		</html>"));
end HeatExchanger_ParticleGasIndirect;