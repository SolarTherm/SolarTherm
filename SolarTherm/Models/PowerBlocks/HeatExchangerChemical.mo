within SolarTherm.Models.PowerBlocks;

model HeatExchangerChemical

   /*                                               DEFINITION                                                                         */
  //          Cooling power belongs to parasities which makes during the sizing process, cooling power is not included                //
  //                W_gross is the power output before parasities i.e. heliostat, lift and cooling power consumption                  //
  
  extends SolarTherm.Media.CO2.PropCO2;
  import SI = Modelica.SIunits;
  import FI = SolarTherm.Models.Analysis.Finances;
  replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
  replaceable package Particle_Package = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  extends Icons.PowerBlock;
 
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MedRec) annotation(
    Placement(visible = true, transformation(origin = {-74, 52}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{-48, 30}, {-40, 38}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MedRec) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{-62, -48}, {-54, -40}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput W_net(quantity = "Power", unit = "W", displayUnit = "MW") "Net electric power output" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(extent = {{46, -10}, {56, 0}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput ramping annotation(
    Placement(visible = true, transformation(origin = {-68, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {2, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90))); 
  Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation(
    Placement(visible = true, transformation(origin = {82, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-36, 60}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  
  //******************************** Parameters -- for initalisation of the OTF object
  //******************************** Uni Adelaide reactor parameters
  parameter Boolean external_parasities = true; 
  
  parameter SI.Temperature T_cold_set = 720 + 273.15;
  parameter SI.Temperature T_in_gas_des = 130 + 273.15;
  parameter SI.Temperature T_out_gas_des = 750 + 273.15;
   
  parameter Real delta_H = 1e3 "Enthalpy change expected from the gas";
  parameter SI.HeatFlowRate Q_reactor = 61000 "Wth";
  parameter SI.Efficiency effectiveness = 0.95;
  parameter SI.ThermalConductance Rh(fixed=false);
  
  //************************* Results
  Integer state "1 means PB on, 0 means PB off"; 
    
  SI.SpecificEnthalpy h_in_pcl;
  SI.SpecificEnthalpy h_out_pcl;
    
  SI.MassFlowRate mdot_pcl;
  SI.HeatFlowRate Q_HX "off-design reactor heat";
  
  SI.Temperature T_out_pcl "Off-design outlet pcl temp";
  SI.Temperature T_out_gas "Off-design outlet temp of the gas";
  
  initial equation
  state = 0;
  Rh = Q_reactor / (T_out_gas_des - T_in_gas_des);
  
  algorithm
  when mdot_pcl > 1e-3  then
    state := 1;
  elsewhen mdot_pcl < 0.99*1e-3 then
    state := 0;
  end when;
  
  equation
  fluid_a.p = fluid_b.p;
  fluid_a.m_flow + fluid_b.m_flow = 0;
  fluid_a.h_outflow = 0;  
  
  //*************** Start off-design calc
  mdot_pcl = fluid_a.m_flow;
  
  if state == 1 then
    Q_HX = effectiveness * Q_reactor;
    h_out_pcl = h_in_pcl - Q_HX/mdot_pcl;
    T_out_gas = (Q_reactor / Rh) + T_in_gas_des;
  else// mdot< 0.999 * m_HTF_des*nu_min then
    Q_HX = 1e-8;
    h_out_pcl = h_in_pcl "h_out = h_in";
    T_out_gas = T_amb "No way to make it 0, as such use ambient temp instead";
  end if;
    
  h_in_pcl = inStream(fluid_a.h_outflow);
  h_out_pcl = fluid_b.h_outflow;
  T_out_pcl = Particle_Package.T_h(h_out_pcl);
    
  W_net = 0;

  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram);

end HeatExchangerChemical;