within SolarTherm.Models.Control;

model StartUpLogic5_PVCSP_particle
  /*This controller has 1 extra variable called optimalMassFlow. The variable will be closed by the full system model. If dispatch optimiser is on, then this variable
    value will follow the output of the dispatch optimiser algorithm. Else, optimalMassFlow will always be equal to the full-load mass flow*/
  //power block startup+ time of standby
  Modelica.Blocks.Interfaces.RealInput level annotation(
    Placement(transformation(extent = {{-128, -20}, {-88, 20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation(
    Placement(transformation(extent = {{90, -20}, {130, 20}})));
  parameter Modelica.SIunits.Time t_start = 0.25 * 3600;
  parameter Modelica.SIunits.Time t_standby = 1 * 3600;
  parameter Modelica.SIunits.Time t_rampdown = 0.25 * 3600;
  parameter Real m_flow_max;
  parameter Real m_flow_startup;
  parameter Real m_flow_standby;
  parameter Real level_on = 20;
  parameter Real level_off = 5;
  parameter Boolean dispatch_optimiser = false;
  parameter Real P_net = 1e8 "Nameplate for the Hybrid System [W]";
  parameter Real CSP_name_plate = 1e8 "Nameplate of the CSP [W]";
  parameter Real PV_name_plate = 0.2e8 "Nameplate of the PV system [W]";
  
  Real CSP_duty "The power duty has to be supplied by the CSP that is the difference between P_net and PV input";
  //Boolean standby;
  //Boolean startup(start=false, fixed=true);
  //Boolean rampdown(start=false,fixed=true);
  //Boolean on_charge ;
  Boolean on_discharge "A boolean to sense whether it is actually OK to charge";
  Real optimalMassFlow;
  //discrete Modelica.SIunits.Time t_off;
  //discrete Modelica.SIunits.Time t_on;
  /*This part is only active when scheduler is on*/
  parameter String schedule_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/simple_schedule.motab");
  parameter Boolean set_scheduler = false;
  Modelica.Blocks.Types.ExternalCombiTable1D schedule_table = Modelica.Blocks.Types.ExternalCombiTable1D(tableName = "schedule", fileName = schedule_file, table = fill(0.0, 0, 2), columns = 1:2, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments);
  Real schedule(start = 0);
  Real idx(start = 0);
  Modelica.Blocks.Interfaces.RealInput m_flow_in annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = -90, origin = {0, 104})));
  //initial equation
  //pre(t_off) = 0;
  //pre(t_on) = 0;
  Modelica.Blocks.Interfaces.RealInput PV_input annotation(
    Placement(visible = true, transformation(extent = {{-128, -48}, {-88, -8}}, rotation = 0), iconTransformation(extent = {{-128, -58}, {-88, -18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_HX_industrial annotation(
    Placement(visible = true, transformation(extent = {{90, 20}, {130, 60}}, rotation = 0), iconTransformation(extent = {{90, 20}, {130, 60}}, rotation = 0)));
initial equation
  on_discharge = level > level_on and level > level_off;
equation

  CSP_duty = max(0,P_net - PV_input);
  
  

  der(idx) = 1;
  if set_scheduler == true then
    schedule = SolarTherm.Utilities.pri_horizon(idx, schedule_table);
  else
    schedule = 1;
  end if;
  when level > level_on then
    on_discharge = true;
  elsewhen level < level_off then
    on_discharge = false;
  end when;
  if on_discharge then
    m_flow = if dispatch_optimiser == true then optimalMassFlow else m_flow_max * (CSP_duty/CSP_name_plate) * schedule;
    m_flow_HX_industrial = 1600;
  else
    m_flow = if dispatch_optimiser == true then min(optimalMassFlow, m_flow_in) else min(m_flow_in, m_flow_max * (CSP_duty/CSP_name_plate) * schedule);
    m_flow_HX_industrial = 0;
  end if;
/*
   //on_charge = m_flow_in > 0;
   
   //***************** Old controller code, too complex and barely succeeded
   when on_charge or on_discharge then
     t_on = time;
   end when;
   when not (on_charge or on_discharge) then
     t_off = time;
   end when;
   
   when t_on-(t_off+t_standby)>0 then
     startup=true;
   elsewhen (time-t_on)>t_start then
     startup=false;
   end when;
//
  when time-(t_off+t_rampdown+t_standby)>0 then
    rampdown=false;
  elsewhen time-(t_off+t_rampdown+t_standby)<0 then
    rampdown=true;
  end when;
   standby = (time-t_off)<t_standby;
//   y =if level then (if (startup) then y_start else y_des) else 0;

  if on_charge or on_discharge then
    if startup then
      m_flow= m_flow_startup;
    else
      if on_discharge then
        m_flow= if dispatch_optimiser == true then optimalMassFlow else m_flow_max*schedule;
      else 
        m_flow=if dispatch_optimiser == true then min(optimalMassFlow,m_flow_in) else min(m_flow_in,m_flow_max*schedule);
      end if;
    end if;
  else
    if standby then
      m_flow=m_flow_standby;
    elseif rampdown then
      m_flow = if dispatch_optimiser == true then optimalMassFlow/2 else m_flow_startup;   
    else
      m_flow=0;
    end if;
  end if;
  */
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    uses(Modelica(version = "3.2.2")));
end StartUpLogic5_PVCSP_particle;