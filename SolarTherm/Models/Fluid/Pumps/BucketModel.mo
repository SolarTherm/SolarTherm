within SolarTherm.Models.Fluid.Pumps;

model BucketModel
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import Util = SolarTherm.Media.SolidParticles.CarboHSP_utilities;
  parameter SI.Time filling_time = 60;
  parameter SI.Time pouring_time = 60;
  parameter SI.Time traveling_time = 600;
  parameter SI.Time stand_by_time = 3600;
  parameter SI.Mass m_hopper_max = m_bucket*2;
  parameter SI.MassFlowRate m_hopper_out = -500;
  parameter Real on_level = 20;
  parameter Real packing_factor = 0.7;
  parameter SI.Length H_tower = 200;
  parameter SI.Length H_hopper = 20;
  parameter SI.Length H_total = H_tower + H_hopper;
  parameter SI.Mass m_bucket = 200000;
  parameter SI.Density rho_particle = 3300;
  parameter SI.Volume vol_bucket = m_bucket / rho_particle / packing_factor;
  parameter SI.Length length_bucket1 = vol_bucket ^ (1 / 3);
  parameter SI.Length length_bucket2 = length_bucket1;
  parameter SI.Length height_bucket1 = length_bucket1;
  parameter SI.Length height_bucket2 = height_bucket1;
  parameter SI.Velocity v_bucket = H_total / traveling_time;
  parameter SI.MassFlowRate mdot_filling = m_bucket / filling_time;
  parameter SI.MassFlowRate mdot_pouring = -m_bucket / pouring_time;
  
  Real hopper_level;
  SI.Mass m_hopper(start=100000);
  SI.MassFlowRate mdot_in1;
  SI.MassFlowRate mdot_out1;
  SI.MassFlowRate mdot_in2;
  SI.MassFlowRate mdot_out2;
  SI.Length height_1(start=0);
  SI.Length height_2(start=0);
  SI.Length position1(start=0);
  SI.Length position2(start=0);
  Real check(start=0);
  Real level_1(start=0);
  Real level_2(start=0);
  Integer count(start=0,min=0);
  Boolean filling1(start=false);
  Boolean travelling1(start=false);
  Boolean pouring1(start=false);
  Boolean on1(start=false);
  Boolean filling2(start=false);
  Boolean travelling2(start=false);
  Boolean pouring2(start=false);
  Boolean on2(start=false);
  
algorithm
  if hopper_level < on_level then
  check := rem(count,2);
    if check == 0 then
      on1 := true;
      on2 := false;
    else
      on1 := false;
      on2 := true;
    end if;
  end if;
  
  if on1==true then
      //Filling
        if level_1 < 98 then
          filling1 := true;
        elseif level_1 >= 99 then
          filling1 := false;
        else 
          filling1 := false;
        end if;
        if filling1 == true then
          mdot_in1 := m_bucket / filling_time;
        else
          mdot_in1 := 0;
        end if;
      //Travelling
        if level_1 >= 99 and position1<=0 then
          travelling1 := true;
        else
          travelling1 := false;
        end if;
      //Pouring
        if position1 >= H_total and level_1>0 then
          travelling1 := false;
          pouring1 := true;
        end if;
        count := pre(count) + 1;
        if pouring1 == true then
          mdot_out1 := mdot_pouring;
        else
          mdot_out1 :=0;
        end if;
  elseif on2==true then
      //Filling
        if level_2 < 98 and pouring1 == true then
          filling2 := true;
        elseif level_2 >= 99 then
          filling2 := false;
        else
          filling2 := false;
        end if;
        if filling2 == true then
          mdot_in2 := m_bucket / filling_time;
        else
          mdot_in2 := 0;
        end if;
      //Travelling
        if level_2 >= 99 and position2<1 then
          travelling2 := true;
        else 
          travelling2 :=false;
        end if;
      //Pouring
        if position2 >= H_total and level_2>0 then
          travelling1 := false;
          pouring2 := true;
        end if;
        count := pre(count) + 1;
        if pouring2 == true and level_2 > 0 then
          mdot_out2 := mdot_pouring;
        else
          mdot_out2 :=0;
        end if;
  end if;
equation
  //position equation
  if travelling1 == true then
  //going up
    der(position1) = v_bucket;
  elseif travelling2 == true and position1 >= H_total then
  //going down
    der(position1) = -v_bucket;
  else
    der(position1) = 0;
  end if;
  if travelling2 == true then
  //going up
    der(position2) = v_bucket;
  elseif travelling1 == true and position2 >= H_total then
  //going down
    der(position2) = -v_bucket;
  else
    der(position2) = 0;
  end if;
  //mass balance equation
  rho_particle * length_bucket1 ^ 2 * der(height_1) = mdot_in1 - mdot_out1;
  rho_particle * length_bucket2 ^ 2 * der(height_2) = mdot_in2 - mdot_out2;
  level_1 = height_1/height_bucket1;
  level_2 = height_2/height_bucket2;
  der(m_hopper) = abs(mdot_out1+mdot_out2)+m_hopper_out;
  hopper_level = m_hopper/m_hopper_max*100;
  
  annotation(
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 1));
end BucketModel;