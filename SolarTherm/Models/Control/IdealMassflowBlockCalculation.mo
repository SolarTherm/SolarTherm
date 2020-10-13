within SolarTherm.Models.Control;
model IdealMassflowBlockCalculation
    
  import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
  import SI = Modelica.SIunits;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities; 
  parameter Real y_start = 500;
  Boolean on (start=false);

  outer parameter Real eta_rec (start = 0, fixed =false);
  
  //Simulation parameters
  parameter Boolean feedforward = true;
  parameter Boolean feedforward_NN = false;
  
  //General parameters
  parameter Real eta_rec_th_des; 
  parameter Real Q_input_limit_low = 280e6;
  parameter Real Q_input_limit_high = Q_input_limit_low + 1e6;
  parameter Real H_drop = sqrt(2000);
  parameter SI.Temperature T_hot_set = 1073.15;
  
  //Neural network parameters
  parameter Integer inputsize = 5;
  parameter String saved_model_dir = Modelica.Utilities.Files.loadResource(
                                    "modelica://SolarTherm/Resources/Include/neural-network/trained-model/surrogate_PID_v1"
                                    );
  parameter Real X_max[inputsize] = {4.99840230e+01, 9.99735880e+08, 8.73149421e+02, 1.27313074e+03, 3.18143363e+02};
  parameter Real X_min[inputsize] = {5.00281700e+00, 1.03123836e+06, 7.98173320e+02, 1.02328492e+03, 2.63159811e+02};
  parameter Real out_max = 4800.818978;
  parameter Real out_min = -1;
  
  // Neural network variables
  STNeuralNetwork session = STNeuralNetwork(saved_model_dir) "Initialise the neural network session";
  Real raw_input[5];
  
  //General variables
  Real Tamb;
  Real eta_rec_discrete (start = eta_rec_th_des);
  

  Modelica.Blocks.Interfaces.RealInput Q_input annotation (Placement(visible = true, transformation(origin = {-116, 80},extent = {{-24, 12}, {24, -12}}, rotation = 0), iconTransformation(origin = {-116, 80},extent = {{-24, 12}, {24, -12}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput T_mea
    annotation (Placement(visible = true,transformation(extent = {{-140, -40}, {-90, 0}}, rotation = 0),
        iconTransformation(extent = {{-120, -20}, {-80, 20}}, rotation = 0)));    
        
  Modelica.Blocks.Interfaces.RealOutput m_flow (start = y_start) annotation(
    Placement(visible = true, transformation(extent = {{94, -18}, {130, 18}}, rotation = 0), iconTransformation(extent = {{94, -18}, {130, 18}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput T_ref annotation (Placement(visible = true, transformation(origin = {0, -108},extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -108},extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  
  Modelica.Blocks.Interfaces.RealInput T_out_receiver annotation(
    Placement(visible = true, transformation(origin = {-2, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-2, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput eta_rec_in annotation(
    Placement(visible = true, transformation(origin = {50, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {50, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  
  algorithm
  //Feed forward is valid for Q_input > 280e6, H_drop_receiver >= 23m and <= 40m
  if feedforward == true then
    if on == true then
      m_flow := max(
                Q_input/1e6 * 3.051917 + 
                0.142194 * Tamb + 
                Modelica.Math.log10(Q_input/1e6) * 215.784613 + 
                0.003562 * T_mea^2 - 0.203024 * H_drop^2 - 2938.106877,0);
    else
      m_flow:=0;
    end if; 
    
  // Neural Network based on PID controller
  elseif feedforward_NN == true then
    raw_input := {H_drop,Q_input,T_mea,T_hot_set,Tamb};
    if on == true then
      m_flow := predict(
                session, 
                raw_input, 
                inputsize,
                X_max,
                X_min,
                out_max,
                out_min
                );
    else
      m_flow:=0;
    end if; 
  else
    if Q_input <= 1e-6 then
      m_flow := 0;
    elseif Q_input > 1e-6 then
      if pre(eta_rec)< 1e-20 then 
        m_flow := Q_input * eta_rec_discrete  / abs(Util.h_T(T_ref) - Util.h_T(T_mea)) "Start-up condition";
      else
        m_flow := Q_input * eta_rec / abs(Util.h_T(T_ref) - Util.h_T(T_mea));
        eta_rec_discrete := eta_rec "updating eta_rec_discrete";
      end if;    
    end if;
  end if;
end IdealMassflowBlockCalculation;