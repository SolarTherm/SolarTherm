within SolarTherm.Models.Fluid.Pumps;

model DoubleBucketModel
  extends SolarTherm.Interfaces.Models.Lift;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  import Modelica.SIunits.Conversions.*;
  replaceable package Medium = Media.SolidParticles.CarboHSP_ph;
  //////////////////////////////////////////////////////////////////////////
  parameter SI.Time traveling_time = 20;
  parameter SI.Time filling_time = 0.1 * traveling_time;
  parameter SI.Time pouring_time = 0.1 * traveling_time;
  parameter SI.MassFlowRate m_hopper_out = -100;
  parameter Real on_level = 50;
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
  parameter SI.Length height_bucket2 = length_bucket2;
  parameter SI.Velocity v_bucket = H_total / traveling_time;
  parameter SI.MassFlowRate mdot_filling = m_bucket_max / filling_time;
  parameter SI.MassFlowRate mdot_pouring = -m_bucket_max / pouring_time;
  parameter SI.Area A_bucket = length_bucket1 ^ 2 * 2 + 4 * length_bucket1 * length_bucket1;
  parameter SI.ThermalInsulance U_value = 1;
  parameter Real emissivity = 0.8;
  parameter SI.Power W_rate_motor = m_bucket_max * CN.g_n * v_bucket;
  parameter SI.Power hp_converter = 745.7;
  parameter Real start_up_ratio = if W_rate_motor / hp_converter > 0 and W_rate_motor / hp_converter < hp_converter then 9.99 elseif W_rate_motor / hp_converter >= hp_converter and W_rate_motor / hp_converter < 2 * hp_converter then 9.99
   elseif W_rate_motor / hp_converter >= 2 * hp_converter and W_rate_motor / hp_converter < 3 * hp_converter then 8.99
   elseif W_rate_motor / hp_converter >= 3 * hp_converter and W_rate_motor / hp_converter < 5 * hp_converter then 7.99
   elseif W_rate_motor / hp_converter >= 5 * hp_converter and W_rate_motor / hp_converter < 10 * hp_converter then 7.09 else 6.29 "https://www.engineeringtoolbox.com/locked-rotor-code-d_917.html ===> in kVA per HP";
  parameter SI.Power W_start_up_motor = start_up_ratio * W_rate_motor;
  parameter SI.Time start_up_time = 0.1 * traveling_time;
  parameter SI.Time stand_by_time = traveling_time;
  ///////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////
  Real level_1(start = 0);
  Real level_2(start = 99);
  SI.Length height_1(start = 1e-10);
  SI.Length height_2;
  ///////////////////////////////////////////////////////////////////////////
  SI.Length position_1(start = 0);
  SI.Length position_2(start = H_total);
  ///////////////////////////////////////////////////////////////////////////
  Boolean lift_on(start = false);
  ///////////////////////////////////////////////////////////////////////////
  SI.Mass m_bucket_1;
  SI.Mass m_bucket_2;
  ///////////////////////////////////////////////////////////////////////////
  SI.MassFlowRate mdot_in_1;
  SI.MassFlowRate mdot_in_2;
  SI.MassFlowRate mdot_out_1;
  SI.MassFlowRate mdot_out_2;
  ///////////////////////////////////////////////////////////////////////////
  SI.SpecificEnthalpy h_in_1;
  SI.SpecificEnthalpy h_in_2;
  SI.SpecificEnthalpy h_out_1;
  SI.SpecificEnthalpy h_out_2;
  SI.Temperature T_out_1;
  SI.Temperature T_out_2;
  ///////////////////////////////////////////////////////////////////////////
  SI.HeatFlowRate Q_loss_convection_1;
  SI.HeatFlowRate Q_loss_convection_2;
  SI.HeatFlowRate Q_loss_radiation_1;
  SI.HeatFlowRate Q_loss_radiation_2;
  ///////////////////////////////////////////////////////////////////////////
  Modelica.Blocks.Interfaces.RealInput T_amb annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-26, 74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput level_hopper annotation(
    Placement(visible = true, transformation(origin = {30, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {20, 74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  when level_hopper < on_level then
    lift_on = true;
  elsewhen level_hopper > 99 then
    lift_on = false;
  end when;
  if lift_on == true then
    if position_1 > (-1e-5) and position_1 <= 0 then
//hysterisis
      if level_1 < 99 then
        mdot_in_1 = mdot_filling;
        mdot_out_1 = 0;
        der(position_1) = 0;
      else
        mdot_in_1 = 0;
        mdot_out_1 = 0;
        der(position_1) = v_bucket;
      end if;
    elseif position_1 < H_total then
      if level_1 >= 99 then
        mdot_in_1 = 0;
        mdot_out_1 = 0;
        der(position_1) = v_bucket;
      else
        mdot_in_1 = 0;
        mdot_out_1 = 0;
        der(position_1) = -v_bucket;
      end if;
    elseif position_1 > H_total then
      if level_1 > 1e-3 then
        mdot_in_1 = 0;
        mdot_out_1 = mdot_pouring;
        der(position_1) = 0;
      else
        mdot_in_1 = 0;
        mdot_out_1 = 0;
        der(position_1) = -v_bucket;
      end if;
    else
      mdot_in_1 = 0;
      mdot_out_1 = 0;
      der(position_1) = 0;
    end if;
    //////////////////////////////////////////////////////
    if position_2 > (-1e-5) and position_2 <= 0 then//hysterisis
      if level_2 < 99 then
        mdot_in_2 = mdot_filling;
        mdot_out_2 = 0;
        der(position_2) = 0;
      else
        mdot_in_2 = 0;
        mdot_out_2 = 0;
        der(position_2) = v_bucket;
      end if;
    elseif position_2 < H_total then
      if level_2 >= 99 then
        mdot_in_2 = 0;
        mdot_out_2 = 0;
        der(position_2) = v_bucket;
      else
        mdot_in_2 = 0;
        mdot_out_2 = 0;
        der(position_2) = -v_bucket;
      end if;
    elseif position_2 >= H_total then
      if level_2 > 1e-3 then
        mdot_in_2 = 0;
        mdot_out_2 = mdot_pouring;
        der(position_2) = 0;
      else
        mdot_in_2 = 0;
        mdot_out_2 = 0;
        der(position_2) = -v_bucket;
      end if;
    else
      mdot_in_2 = 0;
      mdot_out_2 = 0;
      der(position_2) = 0;
    end if;
////////////////////////////////////////////////////////
  else
//if the lift is off
    mdot_in_1 = 0;
    mdot_out_1 = 0;
    mdot_in_2 = 0;
    mdot_out_2 = 0;
    if level_1 > level_2 then
      if position_1 >= H_total then
        der(position_1) = 0;
        der(position_2) = 0;
      else
        der(position_1) = v_bucket;
        der(position_2) = -v_bucket;
      end if;
    elseif level_1 < level_2 then
      if position_2 >= H_total then
        der(position_1) = 0;
        der(position_2) = 0;
      else
        der(position_1) = -v_bucket;
        der(position_2) = v_bucket;
      end if;
    else
      if position_1 > H_total then
        der(position_1) = 0;
        der(position_2) = 0;
      else
        der(position_1) = v_bucket;
        der(position_2) = -v_bucket;
      end if;
    end if;
  end if;
//Mock mass balance equation hopper
//  level_hopper = m_hopper / m_hopper_max * 100;
//  der(m_hopper) = abs(mdot_out_1) + abs(mdot_out_2) + mdot_out_hopper;
//bucket mass balance equation
  m_bucket_1 = rho_particle * (length_bucket1 ^ 2 * height_1 * packing_factor);
  m_bucket_2 = rho_particle * (length_bucket2 ^ 2 * height_2 * packing_factor);
  rho_particle * length_bucket1 ^ 2 * der(height_1) * packing_factor = mdot_in_1 + mdot_out_1;
  rho_particle * length_bucket2 ^ 2 * der(height_2) * packing_factor = mdot_in_2 + mdot_out_2;
  level_1 = height_1 / height_bucket1 * 100;
  level_2 = height_2 / height_bucket2 * 100;
//Energy balance equation
  (mdot_in_1 + mdot_out_1) * h_out_1 + der(h_out_1) * abs(m_bucket_1) = mdot_in_1 * h_in_1 + mdot_out_1 * h_out_1 - Q_loss_convection_1 - Q_loss_radiation_1;
  (mdot_in_2 + mdot_out_2) * h_out_2 + der(h_out_2) * abs(m_bucket_2) = mdot_in_2 * h_in_2 + mdot_out_2 * h_out_2 - Q_loss_convection_2 - Q_loss_radiation_2;
  Q_loss_convection_1 = U_value * A_bucket * (T_out_1 - T_amb);
  Q_loss_radiation_1 = CN.sigma * emissivity * (T_out_1 ^ 4 - T_amb ^ 4);
  Q_loss_convection_2 = U_value * A_bucket * (T_out_2 - T_amb);
  Q_loss_radiation_2 = CN.sigma * emissivity * (T_out_2 ^ 4 - T_amb ^ 4);
  T_out_1 = Util.T_h(h_out_1);
  T_out_2 = Util.T_h(h_out_2);
//  h_in_1 = Util.h_T(from_degC(580));
//  h_in_2 = Util.h_T(from_degC(580));
    h_in_1 = inStream(fluid_a.h_outflow);
    h_in_2 = inStream(fluid_a.h_outflow);
/////////////////////////////////////////////////////////
  fluid_a.h_outflow = 0;
  fluid_b.h_outflow = if mdot_out_1 < 0 then h_out_1 elseif mdot_out_2 < 0 then h_out_2 else h_out_1;
  fluid_a.m_flow = if mdot_in_1 > 0 then mdot_in_1 elseif mdot_in_2 < 0 then mdot_in_2 else mdot_in_1;
  fluid_b.m_flow = if mdot_out_1 < 0 then mdot_out_1 elseif mdot_out_2 < 0 then mdot_out_2 else mdot_out_1;
//////////////////////////////////////////////////////////
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 1));
end DoubleBucketModel;