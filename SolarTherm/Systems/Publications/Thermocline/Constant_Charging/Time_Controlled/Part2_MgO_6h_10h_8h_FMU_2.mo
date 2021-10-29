within SolarTherm.Systems.Publications.Thermocline.Constant_Charging.Time_Controlled;

model Part2_MgO_6h_10h_8h_FMU_2
  function sigmoid_temperature
    /*Source: https://stackoverflow.com/questions/43213069/fit-bipolar-sigmoid-python*/
    input Integer N_f "Tank discretisation";
    input Modelica.SIunits.Temperature T_max "Max temperature in the tank";
    input Modelica.SIunits.Temperature T_min "Min temperature in the tank";
    input Real X_offset "The smaller the offset, the more sigmoid moving to the right";
    input Real slope "The smaller the offset, the more sigmoid moving to the right";
    input Real delta_T "Temperature difference between filler and fluid";
    output Modelica.SIunits.Temperature[N_f] T_tank;
  algorithm
    for i in 1:N_f loop
      T_tank[i] := (T_max - T_min) / (1 + Modelica.Math.exp(-1 * slope * (i - X_offset))) + T_min - delta_T;
    end for;
  end sigmoid_temperature;

  //***********************Sampling parameters
  parameter Boolean gather_data = true "If true then change into sampling mode, if false change into constant charging discharging";
  parameter SI.Temperature T_max_sampling = T_min "Maximum temperature at the storage during the sampling";
  parameter SI.Temperature T_min_sampling = T_min "Minimum temperature at the storage during the sampling";
  parameter SI.Temperature T_amb_design = 298.15;
  parameter Real X_offset = 50 "Temperature difference between fluid and filler";
  parameter Real slope = 1 "Temperature difference between fluid and filler";
  parameter SI.TemperatureDifference delta_T = 0 "Temperature difference between fluid and filler";
  parameter Real mdot = -1800.9737199368346;
  parameter SI.MassFlowRate mdot_f(fixed = false);
  // = 1000 "Positive -> discharge, negative -> charge";
  parameter SI.Temperature T_recv_sampling = 720 + 273.15 "Receiver outlet temp";
  parameter SI.Temperature T_PB_sampling = 510 + 273.15 "PB outlet temp";
  parameter Boolean regression_sigmoid = false "If true perform regression by calling python function";
  parameter String ppath = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/Include") "Absolute path to the Python script";
  parameter String pname = "fit_sigmoid" "Name of the Python script";
  parameter String pfunc = "fit" "Name of the Python function";
  //***********************Generate both fluid and filler surface temperature at the initial condition
  parameter Modelica.SIunits.Temperature[N_f] T_fluid_init = sigmoid_temperature(N_f, T_max_sampling, T_min_sampling, X_offset, slope, 0);
  parameter Modelica.SIunits.Temperature[N_f] T_filler_init = sigmoid_temperature(N_f, T_max_sampling, T_min_sampling, X_offset, slope, delta_T);
  //********************** Import important stuffs
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Modelica.Icons.Example;
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_pT "Medium props for molten salt";
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium "Material model for Sodium Chloride PCM";
  //package Medium = SolarTherm.Media.Air.Air_amb_p;
  //Do not change
  //package Fluid_Package = SolarTherm.Materials.Air_Table;
  //Do not change
  package Filler_Package = SolarTherm.Materials.MgO_Constant;
  //Design Parameters
  //Fixed
  parameter Integer Correlation = 3 "3 --> if use sodium, 1 --> if use air";
  parameter SI.Temperature T_max = 720 + 273.15 "Maximum temperature";
  parameter SI.Temperature T_min = 510 + 273.15 "Minimum temperature";
  parameter SI.Temperature T_PB_min = 790 + 273.15 "Minimum tolerated outlet temperature to PB";
  parameter SI.Temperature T_Recv_max = 520 + 273.15 "Maximum tolerated outlet temperature to recv";
  //0.36 if randomly packed, 0.26 for perfect packing.
  //************************** Design parameter of the tank_level
  parameter Integer N_f = 100 "Number of fluid CVs in main tank";
  parameter Integer N_p = 5 "Number of filler CVs  in main tank";
  parameter SI.Power P_name = 120.0e6 "Nameplate power block";
  parameter Real t_storage = 10;
  parameter SI.Energy E_max = 8.64e12;
  //t_storage * 3600 * (P_name / eff_PB) "Storage capacity (J), t_discharge(s), 100MWe, 50% PB efficiency";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.1 "W/m2K";
  parameter Real eff_PB = 0.50 "Power block heat to electricity conversion efficiency";
  parameter SI.Time t_charge = t_storage * 3600.0 "Charging period";
  parameter SI.Time t_discharge = t_storage * 3600.0 "Discharging period";
  parameter SI.Time t_standby = 0;
  //max(0,24.0 * 3600.0 - t_charge - t_discharge) "Standby period between discharge and charge";
  parameter SI.Length d_p = 0.10 "Filler diameter";
  parameter Real eta = 0.26 "Porosity";
  //Optimise
  parameter Real ar = 2.0 "Tank aspect ratio";
  //******************** Stored energy
  parameter SI.Energy E_min = thermocline_Tank.Tank_A.rho_p * (1 / 6) * CN.pi * d_p ^ 3 * (thermocline_Tank.Tank_A.N_spheres_total / N_f) * sum(SolarTherm.Materials.MgO_Constant.h_Tf(fill(T_min, N_f), 0)) "Minimum level of energy stored in the storage tank is when all the filler temp equals to T_min";
  parameter SI.Energy E_init = thermocline_Tank.Tank_A.rho_p * (1 / 6) * CN.pi * d_p ^ 3 * (thermocline_Tank.Tank_A.N_spheres_total / N_f) * sum(SolarTherm.Materials.MgO_Constant.h_Tf(T_filler_init, 0)) - E_min "The stored energy at t = 0, relative to E_min";
  //Derived
  parameter SI.Time t_cycle = t_charge + t_discharge + t_standby;
  parameter SI.SpecificEnthalpy h_f_min = Fluid_Package.h_Tf(T_min, 0.0);
  parameter SI.SpecificEnthalpy h_f_max = Fluid_Package.h_Tf(T_max, 1.0);
  parameter SI.MassFlowRate m_charge = E_max / (t_charge * (h_f_max - h_f_min));
  parameter SI.MassFlowRate m_discharge = E_max / (t_discharge * (h_f_max - h_f_min));
  Modelica.Fluid.Sources.Boundary_pT Recv_outlet(redeclare package Medium = Medium, T = T_max, use_T_in = true, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT PB_outlet(redeclare package Medium = Medium, T = T_min, use_T_in = true, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {92, -60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //Efficiency
  parameter SI.Energy denom = m_charge * t_charge * (h_f_max - h_f_min);
  SI.Energy numer(start = 0.0);
  Real eff_storage(start = 0.0) "Storage efficiency";
  //COntrol
  SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank_Final_for_FMU thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, E_max = E_max, ar = ar, eta = eta, d_p = d_p, U_loss_tank = U_loss_tank, Correlation = Correlation) annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  /*
    SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank_LC_Final thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, E_max = E_max, ar = ar, eta = eta, d_p = d_p, U_loss_tank = U_loss_tank, Correlation = Correlation) annotation(
      Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
    */
  /*SolarTherm.Models.Storage.Thermocline.Thermocline_Spheres_SingleTank_LC_Final_SurrogateModel thermocline_Tank(redeclare package Medium = Medium, redeclare package Fluid_Package = Fluid_Package, redeclare package Filler_Package = Filler_Package, N_f = N_f, N_p = N_p, T_max = T_max, T_min = T_min, E_max = E_max, ar = ar, eta = eta, d_p = d_p, U_loss_tank = U_loss_tank, Correlation = Correlation, E_min=E_min) annotation(
      Placement(visible = true, transformation(origin = {0, -2}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
    */
  SolarTherm.Models.Fluid.Sources.FluidSink Recv_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-120, -36}, extent = {{26, -26}, {-26, 26}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Tamb(y = T_amb_design) annotation(
    Placement(visible = true, transformation(origin = {-38, -2}, extent = {{-12, -18}, {12, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression m_flow_Recv(y = m_Recv_signal) annotation(
    Placement(visible = true, transformation(origin = {-103, 5}, extent = {{-19, -17}, {19, 17}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-56, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 67.5547}, extent = {{-16, 0}, {16, 22.4453}}, rotation = 0)));
  SolarTherm.Models.Fluid.Valves.PBS_TeeJunction thermocline_Splitter2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -36.3493}, extent = {{-14, 0}, {14, 21.6507}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression m_flow_PB(y = m_PB_signal) annotation(
    Placement(visible = true, transformation(origin = {110, 3}, extent = {{20, -19}, {-20, 19}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure3(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Sources.FluidSink PB_Sink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, 44}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression p_amb(y = 101325) annotation(
    Placement(visible = true, transformation(origin = {41, -2}, extent = {{13, -16}, {-13, 16}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple pumpSimple_EqualPressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Fluid.Pumps.PumpSimple_EqualPressure pumpSimple_EqualPressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Temperature_Recv(y = T_recv_sampling) annotation(
    Placement(visible = true, transformation(origin = {-178, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Temperature_PB(y = T_PB_sampling) annotation(
    Placement(visible = true, transformation(origin = {166, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  //Costs
  parameter Real C_fluid = thermocline_Tank.C_fluid;
  parameter Real C_filler = thermocline_Tank.C_filler;
  parameter Real C_tank = thermocline_Tank.C_tank;
  parameter Real C_insulation = thermocline_Tank.C_insulation;
  parameter Real C_total = thermocline_Tank.C_total;
  parameter Real C_encapsulation = thermocline_Tank.C_encapsulation;
  //Energies
  SI.Energy E_charged(start = 0);
  SI.Energy E_discharged(start = 0);
  SI.Energy E_lost(start = 0);
  SI.Energy E_pump(start = 0);
  SI.MassFlowRate m_Recv_signal(start = m_charge);
  //starts in charging state
  SI.MassFlowRate m_PB_signal(start = 0.0);
  Real T_top_degC;
  Real T_bot_degC;
  Real T_outlet_degC;
  //************************** Surrogate variables
  parameter SI.Mass m_filler(fixed = false);
  SI.SpecificEnthalpy h_p_rep "Enthalpy representative of the filler";
  SI.Temperature T_p_rep "Temperature representative of the filler";
  Real epsilon_stg "Effectiveness of the storage";
  Real dummy;
  Real[4] sigmoidParams "Sigmoid function regression parameters";
  Real a, b, c, d "Sigmoid params";
  Real der_a, der_b, der_c, der_d "Derivatives of a,b,c,d";
  SI.Energy E_stored(start = E_init) "The stored energy starts at E_init. E_init = sum(m_p[i] * h_p[i]) for i in 1:N_f - E_min";
  Real tank_level(start = E_init / E_max) "Tank level relative to the minimum level E_min";
  SI.HeatFlowRate Q_loss_lump_sum "Using average fluid temp - T_amb";
  //*************************** Compare ZK
  parameter Real C1(fixed = false);
  parameter Real C2(fixed = false);
initial equation
  mdot_f = mdot "this equation is necessary since mdot is not changeable in the xml file";
  m_filler = thermocline_Tank.Tank_A.rho_p * (1 / 6) * CN.pi * d_p ^ 3 * thermocline_Tank.Tank_A.N_spheres_total "Filler mass total [kg] = m_p * N_spheres_total";
  C1 = thermocline_Tank.Tank_A.eta * thermocline_Tank.Tank_A.rho_f_avg * (thermocline_Tank.Tank_A.h_f_max - thermocline_Tank.Tank_A.h_f_min);
  C2 = (1 - thermocline_Tank.Tank_A.eta) * thermocline_Tank.Tank_A.rho_p * (thermocline_Tank.Tank_A.h_p_max - thermocline_Tank.Tank_A.h_p_min);
algorithm
  when rem(time, t_cycle) > 1e-6 then
    m_Recv_signal := m_charge;
    m_PB_signal := 0.0;
  end when;
  when rem(time, t_cycle) > t_charge + 1e-6 then
    m_Recv_signal := 0.0;
    m_PB_signal := m_discharge;
  end when;
  when rem(time, t_cycle) > t_charge + t_discharge + 1e-6 then
    m_Recv_signal := 0.0;
    m_PB_signal := 0.0;
  end when;
//Remove temperature controls
/*
  when thermocline_Tank.T_bot_measured > T_Recv_max then
  //when thermocline_Tank.fluid_bot.T > T_Recv_max then
    //if rem(time, t_cycle) < t_charge then
      m_Recv_signal := 0.0;
    //end if;
  end when;
  
  when thermocline_Tank.T_top_measured < T_PB_min then
  //when thermocline_Tank.fluid_top.T < T_PB_min then
    //if rem(time, t_cycle) >= t_charge and rem(time, t_cycle) < t_discharge + t_charge then
      m_PB_signal := 0.0;
    //end if;
  end when;
  */
equation
/************************************************************************************************
  ***************************************** PG Part************************************************  
  *************************************************************************************************/
//****************** Do the regression by calling Python function via external C-function
  if regression_sigmoid == true then
    sigmoidParams = SolarTherm.Utilities.sigmoid_regression(ppath, pname, pfunc, N_f, thermocline_Tank.Tank_A.T_s[1:N_f], thermocline_Tank.Tank_A.u_flow);
  else
    sigmoidParams = fill(0.0, 4);
  end if;
//******************* Assign the return value from the regression to a,b,c,d
  a = sigmoidParams[1];
  b = sigmoidParams[2];
  c = sigmoidParams[3];
  d = sigmoidParams[4];
//******************* Assign derivative values
  der_a = der(a);
  der_b = der(b);
  der_c = der(c);
  der_d = der(d);
//******************* This is Zeb's part
  T_top_degC = thermocline_Tank.T_top_measured - 273.15;
  T_bot_degC = thermocline_Tank.T_bot_measured - 273.15;
//******************** Calculates the effectiveness of the storage tank
  if thermocline_Tank.Tank_A.m_flow > 1e-3 then
//discharging
    epsilon_stg = (thermocline_Tank.Tank_A.h_out - thermocline_Tank.Tank_A.h_in) / (h_f_max - thermocline_Tank.Tank_A.h_in);
  elseif thermocline_Tank.Tank_A.m_flow < (-1e-3) then
//charging
    epsilon_stg = (thermocline_Tank.Tank_A.h_out - thermocline_Tank.Tank_A.h_in) / (h_f_min - thermocline_Tank.Tank_A.h_in);
  else
//standby
    epsilon_stg = 0;
  end if;
//********** Calculate the stored energy in the storage - Energy balance
  der(E_stored) = abs(thermocline_Tank.Tank_A.m_flow) * (thermocline_Tank.Tank_A.h_in - thermocline_Tank.Tank_A.h_out) - thermocline_Tank.Tank_A.Q_loss_total;
//********** Calculate the tank level
  tank_level = E_stored / E_max;
//********** Calculate the representative enthalpy - E_stored / total filler mass
  h_p_rep = (E_stored + E_min) / m_filler "Since what we want is the absolute temperature, thus E_stored must be added by E_min";
//********** Calculate the representative Temperature of the filler
  (T_p_rep, dummy) = SolarTherm.Materials.MgO_Constant.Tf_h(h_p_rep);
  Q_loss_lump_sum = 2 * U_loss_tank * 0.25 * CN.pi * thermocline_Tank.Tank_A.D_tank ^ 2 * (T_p_rep - thermocline_Tank.Tank_A.T_amb) + U_loss_tank * CN.pi * thermocline_Tank.Tank_A.D_tank * thermocline_Tank.Tank_A.H_tank * (T_p_rep - thermocline_Tank.Tank_A.T_amb);
//Top- and bottom losses
//Wall losses
/********************************************************************************************************
  ***************************************** End of PG Part ************************************************  
  *********************************************************************************************************/
  if thermocline_Tank.Tank_A.m_flow > 1e-3 then
//dicharging
    T_outlet_degC = T_top_degC;
  elseif thermocline_Tank.Tank_A.m_flow < (-1e-3) then
//charging
    T_outlet_degC = T_bot_degC;
  else
    T_outlet_degC = 298.15;
//reference value
  end if;
/*
//controls
  if rem(time, t_cycle) < t_charge and thermocline_Tank.T_bot_measured < T_Recv_max then
//charging
    m_Recv_signal = m_charge;
    m_PB_signal = 0.0;
  elseif rem(time, t_cycle) >= t_charge and rem(time, t_cycle) < t_discharge + t_charge and thermocline_Tank.T_top_measured > T_PB_min then
//discharging
    m_Recv_signal = 0.0;
    m_PB_signal = m_discharge;
  else
    m_Recv_signal = 0.0;
    m_PB_signal = 0.0;
  end if;
*/
//efficiency
  if time > t_cycle * 5.0 and time < t_cycle * 6.0 then
    der(numer) = PB_Sink.port_a.m_flow * (inStream(PB_Sink.port_a.h_outflow) - h_f_min);
    if time < t_cycle * 5.0 + t_charge then
//charging
      der(E_charged) = thermocline_Tank.fluid_a.m_flow * (inStream(thermocline_Tank.fluid_a.h_outflow) - thermocline_Tank.fluid_b.h_outflow);
      der(E_discharged) = 0.0;
    elseif time > t_cycle * 5.0 + t_charge and time < t_cycle * 5.0 + t_charge + t_discharge then
      der(E_charged) = 0.0;
      der(E_discharged) = thermocline_Tank.fluid_b.m_flow * (thermocline_Tank.fluid_a.h_outflow - inStream(thermocline_Tank.fluid_b.h_outflow));
    else
      der(E_charged) = 0.0;
      der(E_discharged) = 0.0;
    end if;
    der(E_lost) = thermocline_Tank.Tank_A.Q_loss_total;
    der(E_pump) = thermocline_Tank.Tank_A.W_loss_pump;
  else
    der(numer) = 0.0;
    der(E_charged) = 0.0;
    der(E_discharged) = 0.0;
    der(E_lost) = 0.0;
    der(E_pump) = 0.0;
  end if;
  if time > t_cycle * 5.0 + 100.0 then
//eff_storage = (numer)/denom;
    eff_storage = (numer - E_pump) / denom;
//subtract pumping power
  else
    eff_storage = 0.0;
  end if;
  connect(thermocline_Tank.fluid_b, thermocline_Splitter2.fluid_c) annotation(
    Line(points = {{0, -32}, {0, -46}}, color = {0, 127, 255}));
  connect(thermocline_Splitter2.fluid_b, pumpSimple_EqualPressure2.fluid_a) annotation(
    Line(points = {{-12, -60}, {-34, -60}, {-34, -36}, {-46, -36}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure2.m_flow) annotation(
    Line(points = {{-82, 5}, {-56, 5}, {-56, -27}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure3.fluid_b, thermocline_Splitter2.fluid_a) annotation(
    Line(points = {{30, -60}, {12, -60}}, color = {0, 127, 255}));
  connect(thermocline_Tank.T_amb, Tamb.y) annotation(
    Line(points = {{-17, -2}, {-25, -2}}, color = {0, 0, 127}));
  connect(pumpSimple_EqualPressure.fluid_b, thermocline_Splitter1.fluid_a) annotation(
    Line(points = {{-44, 48}, {-30, 48}, {-30, 92}, {-13, 92}}, color = {0, 127, 255}));
  connect(thermocline_Splitter1.fluid_b, pumpSimple_EqualPressure1.fluid_a) annotation(
    Line(points = {{13, 92}, {22, 92}, {22, 44}, {34, 44}}, color = {0, 127, 255}));
  connect(thermocline_Tank.p_amb, p_amb.y) annotation(
    Line(points = {{17, -2}, {27, -2}}, color = {0, 0, 127}));
  connect(Recv_outlet.ports[1], pumpSimple_EqualPressure.fluid_a) annotation(
    Line(points = {{-96, 48}, {-64, 48}}, color = {0, 127, 255}));
  connect(PB_outlet.ports[1], pumpSimple_EqualPressure3.fluid_a) annotation(
    Line(points = {{76, -60}, {50, -60}}, color = {0, 127, 255}));
  connect(m_flow_Recv.y, pumpSimple_EqualPressure.m_flow) annotation(
    Line(points = {{-82, 5}, {-74, 5}, {-74, 72}, {-54, 72}, {-54, 56}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure1.m_flow) annotation(
    Line(points = {{88, 3}, {70, 3}, {70, 70}, {44, 70}, {44, 52}}, color = {0, 0, 127}));
  connect(m_flow_PB.y, pumpSimple_EqualPressure3.m_flow) annotation(
    Line(points = {{88, 3}, {70, 3}, {70, -30}, {40, -30}, {40, -52}}, color = {0, 0, 127}));
  connect(Recv_Sink.port_a, pumpSimple_EqualPressure2.fluid_b) annotation(
    Line(points = {{-94, -36}, {-66, -36}, {-66, -36}, {-66, -36}}, color = {0, 127, 255}));
  connect(PB_Sink.port_a, pumpSimple_EqualPressure1.fluid_b) annotation(
    Line(points = {{78, 44}, {54, 44}, {54, 44}, {54, 44}}, color = {0, 127, 255}));
  connect(Temperature_Recv.y, Recv_outlet.T_in) annotation(
    Line(points = {{-167, 54}, {-132, 54}}, color = {0, 0, 127}));
  connect(Temperature_PB.y, PB_outlet.T_in) annotation(
    Line(points = {{154, -70}, {140, -70}, {140, -52}, {112, -52}, {112, -54}}, color = {0, 0, 127}));
  connect(thermocline_Splitter1.fluid_c, thermocline_Tank.fluid_a) annotation(
    Line(points = {{0, 74}, {0, 74}, {0, 28}, {0, 28}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 518400, StartTime = 0, Tolerance = 1e-03, Interval = 30));
end Part2_MgO_6h_10h_8h_FMU_2;