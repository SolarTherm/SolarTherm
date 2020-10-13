within SolarTherm.Models.PowerBlocks;

model SurrogatesCO2PB

   /*                                               DEFINITION                                                                         */
  //          Cooling power belongs to parasities which makes during the sizing process, cooling power is not included                //
  //                W_gross is the power output before parasities i.e. heliostat, lift and cooling power consumption                  //
  
  extends SolarTherm.Media.CO2.PropCO2;
  import SI = Modelica.SIunits;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Utilities.SurrogateModelsMultiOutput.*;
  replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
  replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
  extends Icons.PowerBlock;
 
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MedRec) annotation(
    Placement(visible = true, transformation(origin = {-74, 52}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{-48, 30}, {-40, 38}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MedRec) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{-62, -48}, {-54, -40}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput W_net(quantity = "Power", unit = "W", displayUnit = "MW") "Net electric power output" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{46, -10}, {56, 0}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput ramping annotation(
    Placement(visible = true, transformation(origin = {-68, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-2.22045e-16, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
 
  Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation(
    Placement(visible = true, transformation(origin = {82, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  
  //Parameters
  parameter Real nu_min = 0.5;
  parameter SI.Power P_net = 100e6;
  parameter SI.Temperature T_in_ref_blk = 1073.15;
  parameter SI.Temperature T_cold_set = 823.15;
  parameter SI.AbsolutePressure p_high = 250 * 10^5 "high pressure of the cycle";
  parameter Real PR = 2.85 "Pressure ratio";
  parameter SI.TemperatureDifference pinch_PHX = 17.92;
  parameter SI.TemperatureDifference dTemp_HTF_PHX = 200 "T_in_ref_blk - T_cold_set";
  parameter SI.MassFlowRate m_HTF_des = 1000;
  parameter SI.Power Q_HX_des = 300e8;
  parameter Real f_fixed_load = 0.005;
  parameter Boolean external_parasities = true;
  parameter Boolean test_mode = true;
  parameter Integer inputsize = 9;
  parameter Integer outputsize = 2;
  
  
  parameter MedRec.ThermodynamicState state_in_ref=MedRec.setState_pTX(1e5,T_in_ref_blk);
  parameter MedRec.ThermodynamicState state_out_ref=MedRec.setState_pTX(1e5,T_cold_set);
  parameter SI.SpecificEnthalpy h_in_ref=MedRec.specificEnthalpy(state_in_ref);
  parameter SI.SpecificEnthalpy h_out_ref=MedRec.specificEnthalpy(state_out_ref);
  
  parameter Real[inputsize] X_max = {
    1.49954700e+08, 1.27315000e+03, 
    2.49995866e+07, 3.00000000e+00, 
    8.53110000e+02, 9.99900000e+01, 
    1.05000000e+00, 1.24450000e+03, 
    3.18150000e+02
    };
    
  parameter Real[inputsize] X_min = { 
    1.01053953e+07, 1.02319000e+03, 
    2.40000109e+07, 2.74000000e+00, 
    7.98170000e+02, 2.00800000e+01, 
    5.00000000e-01, 9.15560000e+02, 
    2.63150000e+02
    };
    
  parameter Real out_max[outputsize] = {
    1.40015826, 3.26043832
    };
    
  parameter Real out_min[outputsize] = {
    0, 1.36126842e-20
    };
    
  parameter String saved_model_dir = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/small-data/surrogate_model_0";
  parameter Real eta_motor = 1;
  
  //Initialisation of the session class
  STNeuralNetwork session = STNeuralNetwork(saved_model_dir);
  
  //Results
  Real out[outputsize];
  Real[inputsize] raw_input;
  Boolean m_sup "Disconnect the production of electricity when the outlet pressure of the turbine is close to the critical pressure";
  Real load "mass flow fraction of the exchanger compared to design condition";
  
  SI.Efficiency eta_gross;
  SI.Efficiency eta_Q;
  SI.Efficiency eta_cycle_net;
  SI.Power Q_HX;
  SI.Power W_gross;
  SI.Energy E_net(final start = 0, fixed = true, displayUnit = "MW.h");
  
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  SI.MassFlowRate mdot;

  equation
  fluid_a.p = fluid_b.p;
  fluid_a.m_flow + fluid_b.m_flow = 0;
  fluid_a.h_outflow = 0;  
  
  mdot = fluid_a.m_flow;
  
  h_in = inStream(fluid_a.h_outflow);
  h_out = fluid_b.h_outflow;
  
  if test_mode == true then
      m_sup = true;
  else
      when mdot >= m_HTF_des * nu_min then
        m_sup = true;
      elsewhen mdot< 0.99 * m_HTF_des*nu_min then
        m_sup = false;
      end when;
  end if;
  
  out = predict(
      session, 
      raw_input, 
      inputsize, 
      outputsize, 
      X_max, 
      X_min, 
      out_max, 
      out_min
    );
     
  load = mdot / m_HTF_des;

  if m_sup then
    eta_Q = out[2];
    eta_gross = out[1] * 1.03;
    Q_HX=-fluid_a.m_flow*(h_out-h_in);
    eta_cycle_net = W_net / Q_HX;
  else
    eta_Q=0;
    eta_gross=0;
    h_out=h_out_ref;
    eta_cycle_net=0;
  end if;
  
  Q_HX = eta_Q * Q_HX_des;
  W_gross = eta_gross * Q_HX;
  
  if ramping then
    W_net = 0;
  else
    W_net = W_gross * eta_motor * (1-f_fixed_load) - parasities;
  end if;
  
  
  der(E_net) = W_net;

  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram);

end SurrogatesCO2PB;