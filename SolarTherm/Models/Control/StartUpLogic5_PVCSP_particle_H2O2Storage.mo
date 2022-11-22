within SolarTherm.Models.Control;

model StartUpLogic5_PVCSP_particle_H2O2Storage
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
  parameter Real Q_HX_des = 0.2e8 "PHX thermal rating at design point[W]";
  parameter Real eta_gross_base = 0.5 "PB cycle thermal eff at design point";
  parameter Real eta_HX_base = 1 "PHX eff at design point. Always 1";
  
  Real load_curvefit "Load of the PB (mdot/mdot_des)";
  Real eta_rel "Required relative efficiency compared to the design effficiency of the PB";
  Real CSP_duty "The power duty has to be supplied by the CSP that is the difference between P_net and PV input";
  Real T_amb_input "Ambient temperature, connected from controller";
  Real T_HTF_in "Hot tank temperature, connected from controller";
  //Boolean standby;
  //Boolean startup(start=false, fixed=true);
  //Boolean rampdown(start=false,fixed=true);
  Boolean on_charge ;
  Boolean on_discharge "A boolean to sense whether it is actually OK to charge";
  Real optimalMassFlow;
  Boolean optimal_dispatch_dual_tank = false "Boolean to control controller setting";
  //discrete Modelica.SIunits.Time t_off;
  //discrete Modelica.SIunits.Time t_on;
  /*This part is only active when scheduler is on*/
  parameter String schedule_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/simple_schedule.motab");
  parameter Boolean set_scheduler = false;
  Modelica.Blocks.Types.ExternalCombiTable1D schedule_table = Modelica.Blocks.Types.ExternalCombiTable1D(tableName = "schedule", fileName = schedule_file, table = fill(0.0, 0, 2), columns = 1:2, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments);
  Real schedule(start = 0);
  Real idx(start = 0);
  
  Real fraction_Q_TES_PB "Given by the system level model";
  
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
  
  eta_rel = CSP_duty/(eta_gross_base*eta_HX_base * Q_HX_des);
  
  /*Polynomial to calculate the load as a function of T_HTF_in, eta_rel, T_amb_input*/
  load_curvefit = max(0,2769.6949617292476-0.00017169946438564605 * 1 +0.03015652530273176 * eta_rel -7.472152724516921 * T_HTF_in -12.00342644413723 * T_amb_input -0.6531344587751696 * eta_rel^2 -0.9391527546046186 * eta_rel*T_HTF_in +3.721870172798862 * eta_rel*T_amb_input +0.010423277572580292 * T_HTF_in^2 +0.004800277934745278 * T_HTF_in*T_amb_input +0.05213314156649744 * T_amb_input^2 -1.0506405067602818 * eta_rel^3 +0.11234159476764632 * eta_rel^2*T_HTF_in -0.41797097209511436 * eta_rel^2*T_amb_input +0.0007385147411058729 * eta_rel*T_HTF_in^2 +0.00041972152170860705 * eta_rel*T_HTF_in*T_amb_input -0.01325468478015788 * eta_rel*T_amb_input^2 -6.827970954129838e-06 * T_HTF_in^3 -1.2792065761764756e-07 * T_HTF_in^2*T_amb_input -1.7179705441180666e-05 * T_HTF_in*T_amb_input^2 -9.481050800094418e-05 * T_amb_input^3 -0.38139149635750785 * eta_rel^4 +0.0032984787322013777 * eta_rel^3*T_HTF_in -0.003769577132381243 * eta_rel^3*T_amb_input -7.328223869053223e-05 * eta_rel^2*T_HTF_in^2 +0.00012542788571932658 * eta_rel^2*T_HTF_in*T_amb_input +0.000536486546361981 * eta_rel^2*T_amb_input^2 -1.2512199200480572e-07 * eta_rel*T_HTF_in^3 -7.991285196830205e-07 * eta_rel*T_HTF_in^2*T_amb_input +1.9600186806112595e-06 * eta_rel*T_HTF_in*T_amb_input^2 +1.2634986124796368e-05 * eta_rel*T_amb_input^3 +1.6785050364228606e-09 * T_HTF_in^4 -2.1876967145517315e-10 * T_HTF_in^3*T_amb_input +2.329939109593691e-09 * T_HTF_in^2*T_amb_input^2 +1.3229428070171342e-08 * T_HTF_in*T_amb_input^3 +6.677448401176287e-08 * T_amb_input^4);

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
  
  on_charge = m_flow_in > 0 "TES is charged";
  
    if on_discharge then
        if dispatch_optimiser then //TES disp opt
            m_flow = optimalMassFlow;
        elseif optimal_dispatch_dual_tank then //TES + H2 stg disp opt
            m_flow = m_flow_max * fraction_Q_TES_PB * schedule;
        else //immediate disp
            m_flow =  m_flow_max * (min(1,CSP_duty/CSP_name_plate)) * schedule;
            //m_flow = m_flow_max * (min(1.25,load_curvefit)) * schedule;
        end if;
        
        m_flow_HX_industrial = 1600;
    else
        if on_charge then
            if dispatch_optimiser then
                m_flow = min(optimalMassFlow,m_flow_in);
            elseif optimal_dispatch_dual_tank then
                m_flow = min(m_flow_max * fraction_Q_TES_PB * schedule,m_flow_in);
            else
                m_flow =  min(m_flow_max * (min(1,CSP_duty/CSP_name_plate)) * schedule, m_flow_in);
                //m_flow = min(m_flow_max * (min(1.25,load_curvefit)) * schedule, m_flow_in);
            end if;
        else
            m_flow = 1e-5;
        end if;
        
        m_flow_HX_industrial = 0;
   end if;        
  /*
  if on_discharge and on_charge then
    if on_discharge then
        m_flow = if dispatch_optimiser == true then optimalMassFlow else if optimal_dispatch_dual_tank then m_flow_max * fraction_Q_TES_PB * schedule else m_flow_max * (min(1,CSP_duty/CSP_name_plate)) * schedule;
        //m_flow = if dispatch_optimiser == true then optimalMassFlow else m_flow_max * (min(1.25,load_curvefit)) * schedule;
        m_flow_HX_industrial = 1600;
    else
        //m_flow = if dispatch_optimiser == true then min(optimalMassFlow, m_flow_in) else min(m_flow_in, m_flow_max * (min(1.25,load_curvefit)) * schedule);
        m_flow = if dispatch_optimiser == true then min(optimalMassFlow, m_flow_in) else if optimal_dispatch_dual_tank then min(m_flow_in, m_flow_max * fraction_Q_TES_PB * schedule) else min(m_flow_in, m_flow_max * (min(1,CSP_duty/CSP_name_plate)) * schedule);
        m_flow_HX_industrial = 0;
    end if;
  else
    m_flow = 0;
    m_flow_HX_industrial = 0;
  end if;
  */
  

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
end StartUpLogic5_PVCSP_particle_H2O2Storage;