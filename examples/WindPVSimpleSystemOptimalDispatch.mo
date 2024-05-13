within examples;
model WindPVSimpleSystemOptimalDispatch
    // Imports
    import SI = Modelica.SIunits;
    import CN = Modelica.Constants;
    import CV = Modelica.SIunits.Conversions;
    import FI = SolarTherm.Models.Analysis.Finances;
    import nSI = Modelica.SIunits.Conversions.NonSIunits;
    import SolarTherm.Utilities.Tables.STMotab;

    extends Modelica.Icons.Example;

    constant Real MWh_per_J = 1 / (3600. * 1e6);

    // Renewable energy input
    parameter String pv_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_pv.motab");
    parameter String wind_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_wind.motab");
    parameter STMotab.STMotab pv_motab = STMotab.STMotab(pv_file);
    parameter STMotab.STMotab wind_motab = STMotab.STMotab(wind_file);
    parameter Modelica.SIunits.Power pv_ref_size = 50e6 "PV farm reference size";
    parameter Modelica.SIunits.Power wind_ref_size = 50e6 "Wind farm reference size";
    parameter Modelica.SIunits.Power P_elec_min = 1e6;
    parameter Modelica.SIunits.Efficiency pv_fraction = 0.5 "Maximum hot salt mass flow rate";
    parameter Real renewable_multiple = 2 "Renewable energy to process heat demand factor";
    parameter Real heater_multiple = 1 "Heater energy to process heat demand factor";
    parameter Modelica.SIunits.Power P_elec_max = heater_multiple * Q_process_des "Maximum hot salt mass flow rate";
    parameter Modelica.SIunits.HeatFlowRate Q_process_des = 50e6 "Process heat demand at design";
    parameter Modelica.SIunits.Efficiency eff_heater = 0.99 "Electric heater efficiency";

    SolarTherm.Models.Sources.GridInput renewable_input(
        P_elec_max = P_elec_max, 
        P_elec_min = P_elec_min, 
        P_elec_pv_ref_size = pv_ref_size, 
        P_elec_wind_ref_size = wind_ref_size, 
        pv_file = pv_file, 
        pv_fraction = pv_fraction, 
        wind_file = wind_file, 
        renewable_multiple = renewable_multiple);

    Modelica.Blocks.Sources.BooleanExpression curtail(y=false);
    Modelica.Blocks.Sources.RealExpression P_curtail(y=Q_process_des/eff_heater);

    // Parameters
    parameter String pri_file = Modelica.Utilities.Files.loadResource(
        "modelica://SolarTherm/Data/Prices/g3p3_TOD.motab") 
            "[FN] Electricity price file";

    parameter SI.Efficiency eff_process = 1 "Power block efficiency";
    parameter Real t_storage(unit="h") = 8 "Hours of storage";
    parameter SI.Energy E_max = Q_process_des*t_storage*3600 "Max stored energy";

    parameter SI.Energy E_up_u = 0.95*E_max "Upper energy limit";
    parameter SI.Energy E_up_l = 0.93*E_max "Upper energy limit";
    parameter SI.Energy E_low_u = 0.07*E_max "Lower energy limit";
    parameter SI.Energy E_low_l = 0.05*E_max "Lower energy limit";
    parameter SI.Energy E_start = 0.3*E_max "Lower energy limit";

    parameter SI.Time t_con_on_delay = 20*60 "Delay until concentrator starts";
    parameter SI.Time t_con_off_delay = 15*60 "Delay until concentrator shuts off";
    parameter SI.Time t_blk_on_delay = 4*3600 "Delay until power block starts";
    parameter SI.Time t_blk_off_delay = 3*3600 "Delay until power block shuts off";

    parameter Integer ramp_order = 1 "ramping filter order";

    parameter Integer n_sched_states = 1 "Number of schedule states";
    parameter Integer sch_state_start(min=1, max=n_sched_states) = 1 "Starting schedule state";
    parameter SI.Time t_sch_next_start = 0 "Time to next schedule change";
    parameter SI.HeatFlowRate Q_flow_sched_val[n_sched_states] = {
            Q_process_des
            } "Heat flow at schedule states";
    parameter SI.Time t_delta[n_sched_states] = {
            24*3600
            } "Time differences between schedule states";

    parameter FI.Money C_cap = 10e6 "Capital costs";

    parameter FI.MoneyPerYear C_year = 10 "Cost per year";
    parameter Real C_prod(unit="$/J/year") = 0 "Cost per production per year";
    parameter Real r_disc = 0.05 "Discount rate";
    parameter Integer t_life(unit="year") = 20 "Lifetime of plant";
    parameter Integer t_cons(unit="year") = 1 "Years of construction";

    parameter Boolean constrained = false "Constraint is present in optimisation if true";
        // If there is a constraint, then "constrained" must be a 'variable' Boolean
        // whose value is determined through an if statement with a constraint being the condition.
        // Note in this case the if block must be moved to the equation section.
    parameter Real distance = 0 "Distance to be added to a constant offset as added penalty when a constraint is not respected";
        // e.g. for euclidean distance: if T > T0 then constrained=true & distance=sqrt((T-T0)^2)
        // e.g. for quadratic distance: if T > T0 then constrained=true & distance=(T-T0)^2
        // e.g. for a constraint like T1 < T < T2, then T0 = (T1 + T2)/2

    // Variables/Models
    FI.SpotPriceTable pri(file=pri_file);

    SI.HeatFlowRate Q_flow_rec "Heat flow into receiver";
    SI.HeatFlowRate Q_flow_chg "Heat flow into tank";
    SI.HeatFlowRate Q_flow_dis "Heat flow out of tank";
    SI.Power P_elec "Output power of power block";

    Real fr_dfc(min=0, max=1) "Target energy fraction of the heliostat fistateld at the defocused state";
    Boolean full "True if the storage tank is full";

    SolarTherm.Utilities.Transition.Ramp ramp_up_con(ramp_order=ramp_order, t_dur= t_con_on_delay, up=true);
    SolarTherm.Utilities.Transition.Ramp ramp_down_con(ramp_order=ramp_order, t_dur= t_con_off_delay, up=false);
    Real fr_ramp_con (min=0.0, max=1.0) "ramping transition rate for the concentrator";
    SolarTherm.Utilities.Transition.Ramp ramp_up_blk(ramp_order=ramp_order, t_dur= t_blk_on_delay, up=true);
    SolarTherm.Utilities.Transition.Ramp ramp_down_blk(ramp_order=ramp_order, t_dur= t_blk_off_delay, up=false);
    Real fr_ramp_blk (min=0.0, max=1.0) "ramping transition rate for the power block";

    SI.Energy E(min=0, max=E_max) "Stored energy";

    SI.HeatFlowRate Q_flow_sched "Discharge schedule";

    Integer con_state(min=1, max=5) "Concentrator state";
    Integer blk_state(min=1, max=4) "Power block state";
    Integer sch_state(min=1, max=n_sched_states) "Schedule state";

    SI.Time  t_con_w_now "Time of concentrator current warm-up event";
    SI.Time  t_con_w_next "Time of concentrator next warm-up event";
    SI.Time  t_con_c_now "Time of concentrator current cool-down event";
    SI.Time  t_con_c_next "Time of concentrator next cool-down event";
    SI.Time  t_blk_w_now "Time of power block current warm-up event";
    SI.Time  t_blk_w_next "Time of power block next warm-up event";
    SI.Time  t_blk_c_now "Time of power block current cool-down event";
    SI.Time  t_blk_c_next "Time of power block next cool-down event";
    SI.Time  t_sch_next "Time of next schedule change";

    FI.Money R_spot(start=0, fixed=true)
            "Spot market revenue";
    SI.Energy E_elec(start=0, fixed=true) "Generate electricity";

    /*Dispatch optimisation*/
    parameter Real DEmax = Q_process_des / eff_process * 1e-6 "Thermal rating of the power block ==> maximum dispatched thermal power to the PB (MWth)";
    parameter SI.Time dt(displayUnit="h") = 3600 "delta t";
    parameter Integer horizon = 48;
    parameter Boolean dispatch_optimiser = true;

    Real counter(start = -dt);
    Real time_simul "time of the optimisation";
    Real optimalDispatch "optimal disopatch";
    Real immediateDispatch "Immediate dispatch";
    Real SLinit "Current capacity the tank MWh";
    Real SLmax "Max capacity MWhth";
    Real SLmin "Minimum level of the tank MWhth";

    Real TOD_W(start=0);
    Real pre_dispatched_heat;

function LPOptimisation
    import SolarTherm.Utilities.Tables.STMotab;

    input STMotab.STMotab pv_motab;
    input STMotab.STMotab wnd_motab;
    input Real P_elec_max_pv;
    input Real P_elec_max_wind;
    input Real P_elec_pv_ref_size;
    input Real P_elec_wind_ref_size;
    input Integer horizon;
    input Real dt;
    input Real time_simul;
    input Real eff_heater;
    input Real eff_process;
    input Real DEmax;
    input Real SLmax;
    input Real SLinit;
    input Real SLmin;
    input Real max_ramp_up_fraction;
    input Real P_heater_max;
    input Real pre_dispatched_heat;
    output Real Dispatch;
    external "C" Dispatch = st_linprog_variability(
            pv_motab,wnd_motab
            ,P_elec_max_pv,P_elec_max_wind
            ,P_elec_pv_ref_size,P_elec_wind_ref_size
            ,horizon,dt,time_simul
            ,eff_heater,eff_process
            ,DEmax,SLmax,SLinit,SLmin
            ,max_ramp_up_fraction
            ,P_heater_max
            ,pre_dispatched_heat
        );
    annotation(Library="st_linprog");
end LPOptimisation;

initial equation

    E = E_start;
    Q_flow_sched = Q_flow_sched_val[sch_state_start];
    con_state = 1;
    blk_state = 1;
    sch_state = sch_state_start;
    t_con_w_now = 0;
    t_con_w_next = 0;
    t_con_c_now = 0;
    t_con_c_next = 0;
    t_blk_w_now = 0;
    t_blk_w_next = 0;
    t_blk_c_now = 0;
    t_blk_c_next = 0;
    t_sch_next = t_sch_next_start;

    if E > E_up_u then
        full = true;
    elseif E < E_up_l then
        full = false;
    else
        full = true;
    end if;

    algorithm
    // Discrete equation system not yet supported (even though correct)
    // Putting in algorithm section instead
    when con_state == 2 and (renewable_input.electricity <= P_elec_min or E >= E_up_u) then
        con_state := 1; // off sun
    elsewhen con_state == 3 and (renewable_input.electricity <= P_elec_min) and t_con_off_delay > 0 then
        con_state := 5; // ramp down
    elsewhen con_state == 3 and (renewable_input.electricity <= P_elec_min) and t_con_off_delay <= 0 then
        con_state := 1; // off sun(no ramp-down)
    elsewhen con_state == 3 and full then
        con_state := 4; // on sun at part load
    elsewhen con_state == 4 and not full then
        con_state := 3; // on sun at full load
    elsewhen con_state == 4 and (renewable_input.electricity <= P_elec_min) and t_con_off_delay > 0 then
        con_state := 5; // ramp down
    elsewhen con_state == 4 and (renewable_input.electricity <= P_elec_min) and t_con_off_delay <= 0 then
        con_state := 1; // off sun (no ramp-down)
    elsewhen con_state == 1 and renewable_input.electricity >= P_elec_min and E <= E_up_l and t_con_on_delay > 0 then
        con_state := 2; // start onsteering (i.e. ramp up)
    elsewhen con_state == 1 and renewable_input.electricity >= P_elec_min and E <= E_up_l and t_con_on_delay <= 0 then
        con_state := 3; // on sun at full (no ramp-up)
    elsewhen con_state == 2 and time >= t_con_w_next then
        con_state := 3; // on sun at full load
    elsewhen con_state == 5 and time >= t_con_c_next then
        con_state := 1; // off sun
    end when;

    when blk_state == 2 and Q_flow_sched <= 0 then
        blk_state := 1; // turn off (or stop ramping) due to no demand
    elsewhen blk_state == 2 and E <= E_low_l then
        blk_state := 1; // turn off (or stop ramping) due to empty tank
    elsewhen blk_state == 3 and Q_flow_sched <= 0 and t_blk_off_delay > 0 then
        blk_state := 4; // ramp down due to no demand
    elsewhen blk_state == 3 and Q_flow_sched <= 0 and t_blk_off_delay <= 0 then
        blk_state := 1; // turn off (no ramp-down) due to no demand
    elsewhen blk_state == 3 and E <= E_low_l and t_blk_off_delay > 0 then
        blk_state := 4; // ramp down due to empty tank
    elsewhen blk_state == 3 and E <= E_low_l and t_blk_off_delay <= 0 then
        blk_state := 1; // turn off (no ramp down) due to empty tank
    elsewhen blk_state == 2 and time >= t_blk_w_next then
        blk_state := 3; // operational, ramp-up completed
    elsewhen blk_state == 1 and Q_flow_sched > 0 and E >= E_low_u  and t_blk_on_delay > 0 then
        blk_state := 2; // ramp up, demand and tank has capacity
    elsewhen blk_state == 1 and Q_flow_sched > 0 and E >= E_low_u  and t_blk_on_delay <= 0 then
        blk_state := 3; // operational (no ramp-up)
    elsewhen blk_state == 4 and time >= t_blk_c_next then
        blk_state := 1; // turn off after the ramp-down is complete
    end when;

    when time >= t_sch_next then
        sch_state := mod(pre(sch_state), n_sched_states) + 1;
    end when;

    when con_state == 2 then
        t_con_w_now := time;
        t_con_w_next := time + t_con_on_delay;
    end when;

    when con_state == 5 then
        t_con_c_now := time;
        t_con_c_next := time + t_con_off_delay;
    end when;

    when blk_state == 2 then
        t_blk_w_now := time;
        t_blk_w_next := time + t_blk_on_delay;
    end when;

    when blk_state == 4 then
        t_blk_c_now := time;
        t_blk_c_next := time + t_blk_off_delay;
    end when;

    for i in 1:n_sched_states loop
        when sch_state == i then
            Q_flow_sched := Q_flow_sched_val[i];
            t_sch_next := time + t_delta[i];
        end when;
    end for;

    when E > E_up_u then
        full := true;
    elsewhen E < E_up_l then
        full := false;
    end when;

    if con_state == 2 then
        fr_ramp_con := if ramp_order == 0 then 0.0 else abs(ramp_up_con.y);
    elseif con_state == 5 then
        fr_ramp_con := if ramp_order == 0 then 0.0 else abs(ramp_down_con.y);
    else
        fr_ramp_con := 0;
    end if;


    if blk_state == 2 then
        fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_up_blk.y);
    elseif blk_state == 4 then
        fr_ramp_blk := if ramp_order == 0 then 0.0 else abs(ramp_down_blk.y);
    else
     fr_ramp_blk := 0;
    end if;

equation
    connect(renewable_input.curtail,curtail.y);
    connect(renewable_input.P_schedule,P_curtail.y);

    ramp_up_con.x = t_con_w_now;
    ramp_down_con.x = t_con_c_now;

    ramp_up_blk.x = t_blk_w_now;
    ramp_down_blk.x = t_blk_c_now;

    Q_flow_chg = eff_heater*Q_flow_rec;

    der(E) = Q_flow_chg - Q_flow_dis;

    if con_state <= 1 then
        Q_flow_rec = 0;
        fr_dfc = 0;
    elseif con_state == 2 then
        Q_flow_rec = fr_ramp_con * max(renewable_input.electricity, 0);
        fr_dfc = if ramp_order == 0 then 0 else 1;
    elseif con_state == 5 then
        Q_flow_rec = fr_ramp_con * max(renewable_input.electricity, 0);
        fr_dfc = if ramp_order == 0 then 0 else 1;
    else
        if full then
            if eff_heater*(renewable_input.electricity) > Q_flow_dis then
                Q_flow_rec = min(Q_flow_dis/eff_heater, max(renewable_input.electricity, 0));
                fr_dfc = Q_flow_dis / (max(renewable_input.electricity, 0) + 1e-10);
            else
                Q_flow_rec = max(renewable_input.electricity, 0);
                fr_dfc = 1;
            end if;
        else
            Q_flow_rec = max(renewable_input.electricity, 0);
            fr_dfc = 1;
        end if;
    end if;

    der(counter) = 1;
    SLinit = E * MWh_per_J "Initial stored energy at TES";
    SLmax = E_max * MWh_per_J "Maximum stored energy at TES";
    SLmin = E_low_l * MWh_per_J "Lowest energy level in the tank";
    pre_dispatched_heat = pre(Q_flow_dis)/1e6 "Previous heat dispatched";
    
    when counter > 0 then
        time_simul = floor(time);
        optimalDispatch = LPOptimisation(
            pv_motab, wind_motab
            ,renewable_input.P_elec_max/1e6,renewable_input.P_elec_max_wind/1e6
            ,renewable_input.P_elec_pv_ref_size/1e6,renewable_input.P_elec_wind_ref_size/1e6
            ,horizon, dt, time_simul
            ,eff_heater, eff_process
            ,DEmax, SLmax, SLinit, SLmin
            ,dt/t_blk_on_delay
            ,P_elec_max/1e6
            ,pre(Q_flow_dis)/1e6
          );
        immediateDispatch = Q_process_des/1e6;
        reinit(counter, -dt);  
    end when;
                         
 
    if blk_state <=1 then
        Q_flow_dis = 0;
        P_elec = 0;
    elseif blk_state == 2 then
        if ramp_order == 0 then
            if dispatch_optimiser == true then
                Q_flow_dis = optimalDispatch*1e6;
            else
                Q_flow_dis = Q_flow_sched;
            end if;
        else
            if dispatch_optimiser == true then
                Q_flow_dis = fr_ramp_blk * optimalDispatch*1e6;
            else
                Q_flow_dis = fr_ramp_blk * Q_flow_sched;
            end if;
        end if;
        P_elec = eff_process*Q_flow_dis;
    elseif blk_state == 4 then
        Q_flow_dis = fr_ramp_blk * (if dispatch_optimiser == true
                then optimalDispatch*1e6 else Q_flow_sched);
        P_elec = eff_process*Q_flow_dis;
    else
        Q_flow_dis = if dispatch_optimiser == true 
                then optimalDispatch*1e6 else Q_flow_sched;
        P_elec = eff_process*Q_flow_dis;
    end if;

    der(E_elec) = P_elec;
    der(R_spot) = P_elec*pri.price;
    der(TOD_W) = P_elec*pri.price * (1e6*3600);
//        StopTime=31536000.0
    annotation(experiment(StartTime = 0, StopTime = 864000, Interval = 300, Tolerance = 1e-06),
 Diagram(graphics = {Bitmap(origin = {-18, 72}, extent = {{-30, -32}, {30, 32}})}));
end WindPVSimpleSystemOptimalDispatch;
