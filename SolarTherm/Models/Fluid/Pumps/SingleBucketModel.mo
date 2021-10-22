within SolarTherm.Models.Fluid.Pumps;

model SingleBucketModel
  extends SolarTherm.Interfaces.Models.Lift;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = Media.SolidParticles.CarboHSP_ph;
  //////////////////////////////////////////////////////////////////////////
  parameter SI.Time filling_time = 0.1*traveling_time;
  parameter SI.Time pouring_time = 0.1*traveling_time;
  parameter SI.Time traveling_time = 600;
  parameter SI.MassFlowRate m_hopper_out = -100;
  parameter Real on_level = 30;
  parameter Real packing_factor = 0.7;
  parameter SI.Length H_tower = 200;
  parameter SI.Length H_hopper = 20;
  parameter SI.Length H_total = H_tower + H_hopper;
  parameter SI.Mass m_bucket_max = 14000;
  parameter SI.Density rho_particle = 3300;
  parameter SI.Volume vol_bucket = m_bucket_max / rho_particle / packing_factor;
  parameter SI.Length length_bucket1 = vol_bucket ^ (1 / 3);
  parameter SI.Length length_bucket2 = length_bucket1;
  parameter SI.Length height_bucket1 = length_bucket1;
  parameter SI.Velocity v_bucket = H_total / traveling_time;
  parameter SI.MassFlowRate mdot_filling = m_bucket_max / filling_time;
  parameter SI.MassFlowRate mdot_pouring = -m_bucket_max / pouring_time;
  parameter SI.Area A_bucket = length_bucket1 ^ 2 * 2 + 4 * length_bucket1 * length_bucket1;
  parameter SI.ThermalInsulance U_value = 1;
  parameter Real emissivity = 0.8;
  parameter SI.Power W_rate_motor = m_bucket_max*CN.g_n * v_bucket;
  parameter SI.Power hp_converter = 745.7;
  parameter Real start_up_ratio = if 
  W_rate_motor/hp_converter > 0 and W_rate_motor/hp_converter < hp_converter then 9.99 
      elseif W_rate_motor/hp_converter >= hp_converter   and W_rate_motor/hp_converter < 2* hp_converter  then 9.99
      elseif W_rate_motor/hp_converter >= 2*hp_converter and W_rate_motor/hp_converter < 3* hp_converter  then 8.99
      elseif W_rate_motor/hp_converter >= 3*hp_converter and W_rate_motor/hp_converter < 5* hp_converter  then 7.99
      elseif W_rate_motor/hp_converter >= 5*hp_converter and W_rate_motor/hp_converter < 10*hp_converter  then 7.09
  else 6.29
  "https://www.engineeringtoolbox.com/locked-rotor-code-d_917.html ===> in kVA per HP";
  parameter SI.Power W_start_up_motor = start_up_ratio*(W_rate_motor);
  parameter SI.Time start_up_time = 0.1*traveling_time;
  parameter SI.Time stand_by_time = traveling_time;
  ///////////////////////////////////////////////////////////////////////////
  Real level_1(start = 0);
  Boolean on1(start = false);
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out(start = Util.h_T(from_degC(580)));
  SI.Mass m_bucket;
  SI.HeatFlowRate Q_loss_convection;
  SI.HeatFlowRate Q_loss_radiation;
  SI.Temperature T_out;
  SI.MassFlowRate mdot_in1;
  SI.MassFlowRate mdot_out1;
  SI.Length height_1(start = 1e-10);
  SI.Length position1(start = 0);
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-26, 74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput level_hopper annotation(
    Placement(visible = true, transformation(origin = {30, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {20, 74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  when level_hopper < on_level then
    on1 = true;
  elsewhen level_hopper > 99 then
    on1 = false;
  end when;
  
  if on1 == true then
    if position1 > (-1e-5) and position1 <= 0 then //hysterisis
      if level_1 < 99 then
        mdot_in1 = mdot_filling;
        der(position1) = 0;
        mdot_out1 = 0;
      else
        mdot_in1 = 0;
        der(position1) = v_bucket;
        mdot_out1 = 0;
      end if;
    elseif position1 < H_total then
      if level_1 >= 99 then
        der(position1) = v_bucket;
        mdot_in1 = 0;
        mdot_out1 = 0;
      else
        der(position1) = -v_bucket;
        mdot_in1 = 0;
        mdot_out1 = 0;
      end if;
    elseif position1 > H_total then
      if level_1 > 1e-3 then
        mdot_in1 = 0;
        mdot_out1 = mdot_pouring;
        der(position1) = 0;
      else
        mdot_in1 = 0;
        mdot_out1 = 0;
        der(position1) = -v_bucket;
      end if;
    else
      mdot_in1 = 0;
      mdot_out1 = 0;
      der(position1) = 0;
    end if;
  elseif on1 == false then
    if position1 > 0 then
      mdot_in1 = 0;
      mdot_out1 = 0;
      der(position1) = -v_bucket;
    elseif position1 == 0 then
      mdot_in1 = 0;
      mdot_out1 = 0;
      der(position1) = 0;
    else
      mdot_in1 = 0;
      mdot_out1 = 0;
      der(position1) = 0;
    end if;
  else
    mdot_in1 = 0;
    mdot_out1 = 0;
    der(position1) = -v_bucket;
  end if;

  m_bucket = rho_particle * (length_bucket1 ^ 2 * height_1 * packing_factor);
  (mdot_in1 + mdot_out1) * h_out + der(h_out) * abs(m_bucket) = mdot_in1 * h_in + mdot_out1 * h_out - Q_loss_convection-Q_loss_radiation;
  Q_loss_convection = U_value * A_bucket * (T_out - T_amb);
  Q_loss_radiation = CN.sigma * emissivity * (T_out^4-T_amb^4);
  T_out = Util.T_h(h_out);
  h_in = inStream(fluid_a.h_outflow);
  rho_particle * length_bucket1 ^ 2 * der(height_1) * packing_factor = mdot_in1 + mdot_out1;
  level_1 = height_1 / height_bucket1 * 100;
  /////////////////////////////////////////////////////////
  fluid_a.h_outflow=0;
  fluid_b.h_outflow=h_out;
  fluid_a.m_flow = mdot_in1;
  fluid_b.m_flow = mdot_out1;
  //////////////////////////////////////////////////////////
  annotation(
    experiment(StartTime = 0, StopTime = 5000, Tolerance = 0.001, Interval = 1));
end SingleBucketModel;