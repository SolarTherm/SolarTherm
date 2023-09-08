within examples;
model WindPVsaltTESsystem
	extends Modelica.Icons.Example;

	import Modelica.SIunits.Conversions.*;
	import Modelica.Constants.*;

	// Importing molten salt properties
	replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_ph;

	// Importing pv, wind and schedule files
	parameter String schedule_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/dummy_schedule.motab");

	// Renewable energy input
	parameter String pv_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_pv.motab");
	parameter String wind_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Renewable/dummy_wind.motab");
	parameter Modelica.SIunits.Power pv_ref_size = 50e6 "PV farm reference size";
	parameter Modelica.SIunits.Power wind_ref_size = 50e6 "Wind farm reference size";
	parameter Modelica.SIunits.Power P_elec_min = 1e5;
	parameter Modelica.SIunits.Efficiency pv_fraction = 0.5 "Maximum hot salt mass flow rate";
	parameter Real renewable_multiple = 2 "Renewable energy to process heat demand factor";
	parameter Modelica.SIunits.Power P_elec_max = renewable_multiple*Q_flow_des "Maximum hot salt mass flow rate";

	// Heater parameters
	parameter Modelica.SIunits.Efficiency heater_efficiency = 0.99 "Electric heater efficiency";
	parameter Modelica.SIunits.Temperature T_hot_set = from_degC(565) "Hot tank temperature";
	parameter Modelica.SIunits.Temperature T_cold_set = from_degC(290) "Hot tank temperature";

	// Thermal energy storage parameters
	parameter Boolean size_storage = true;
	parameter Real t_storage(unit = "h") = 8 "Hours of storage";
	parameter Real tank_ar = 20/19 "storage aspect ratio";
	parameter Modelica.SIunits.Temperature T_amb_des = from_degC(25) "Ambient temperature at design";
	parameter Modelica.SIunits.Length H_storage = if size_storage then ceil((4*V_max*tank_ar^2/pi)^(1/3)) else 10 "Storage tank height";
	parameter Modelica.SIunits.Diameter D_storage = if size_storage then H_storage/tank_ar else 20 "Storage tank diameter";
	parameter Modelica.SIunits.Power W_heater_hot = 30e6 "Hot tank heater capacity";
	parameter Modelica.SIunits.Power W_heater_cold = 30e6 "Cold tank heater capacity";
	parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha = 0.4 "Tank constant heat transfer coefficient with ambient";
	parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
	parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";

	parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
	parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
	parameter Modelica.SIunits.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";  
	parameter Modelica.SIunits.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
	parameter Modelica.SIunits.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
	parameter Modelica.SIunits.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";
	parameter Modelica.SIunits.Mass m_max = E_max/(h_hot_set - h_cold_set) "Max salt mass in tanks";
	parameter Modelica.SIunits.Volume V_max = 2*m_max/(rho_hot_set + rho_cold_set) "Max salt volume in tanks";
	parameter Modelica.SIunits.Efficiency off_design_factor = 0.98 "Off-design curtailment correction";

	parameter Modelica.SIunits.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";

	// Pump parameters
	parameter Modelica.SIunits.SpecificEnergy k_loss_cold = 0.15e3 "Cold pump parasitic power coefficient";
	parameter Modelica.SIunits.SpecificEnergy k_loss_hot = 0.55e3 "Hot pump parasitic power coefficient";

	// Boiler parameters
	parameter Modelica.SIunits.HeatFlowRate Q_flow_des = 50e6 "Process heat demand at design";
	parameter Modelica.SIunits.MassFlowRate m_flow_hot = Q_flow_des/(h_hot_set - h_cold_set) "Nominal hot salt mass flow rate";
	parameter Real nu_min_boiler = 0.25 "minimum allowed part-load mass flow fraction to the boiler";

	// Control parameters
	parameter Real heater_max_frac = 2.5 "Max/nominal heating fraction";
	parameter Modelica.SIunits.MassFlowRate m_flow_heater_max = heater_max_frac*m_flow_hot "Maximum hot salt mass flow rate";

	parameter Real hot_tnk_empty_lb = 5 "Hot tank empty trigger lower bound";
	parameter Real hot_tnk_empty_ub = 10 "Hot tank empty trigger upper bound";
	parameter Real hot_tnk_full_lb = 93 "Hot tank full trigger lower bound";
	parameter Real hot_tnk_full_ub = 96 "Hot tank full trigger upper bound";

	parameter Real cold_tnk_curtailment_lb = 7 "Cold tank empty trigger lower bound";
	parameter Real cold_tnk_curtailment_ub = 5 "Cold tank empty trigger upper bound";
	parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound";
	parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound";

	parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
	parameter Modelica.SIunits.Time Ti = 0.1 "Time constant for integral component of receiver control";
	parameter Real Kp = -1000 "Gain of proportional component in receiver control";

	parameter Modelica.SIunits.Temperature T_cold_aux_set = from_degC(280) "Cold tank auxiliary heater set-point temperature";
	parameter Modelica.SIunits.Temperature T_hot_aux_set = from_degC(500) "Hot tank auxiliary heater set-point temperature";

	// System defaults
	inner Modelica.Fluid.System system(
		T_start = T_cold_set, 
		allowFlowReversal = false, 
		p_start = Medium.p_default) annotation(
		Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Ambient temperature
	Modelica.Blocks.Sources.RealExpression T_amb(y = system.T_ambient) annotation(
		Placement(visible = true, transformation(origin = {-50, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Atmospheric pressure
	Modelica.Blocks.Sources.RealExpression p_atm(y = system.p_ambient) annotation(
		Placement(visible = true, transformation(origin = {-18, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Renewable energy input
	SolarTherm.Models.Sources.GridInput gridInput(
		P_elec_max = P_elec_max,P_elec_min = P_elec_min, 
		P_elec_pv_ref_size = pv_ref_size, 
		P_elec_wind_ref_size = wind_ref_size, pv_file = pv_file, 
		pv_fraction = pv_fraction, 
		wind_file = wind_file,
		renewable_multiple = renewable_multiple) annotation(
		Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Curtailment input
	Modelica.Blocks.Sources.RealExpression P_elec_schedule(y = scheduler.y[1] * (h_hot_set - h_cold_set)*off_design_factor) annotation(
		Placement(visible = true, transformation(origin = {-106, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Electrical Heater
	SolarTherm.Models.Fluid.HeatExchangers.SimpleResistiveHeater heater(
		redeclare package Medium = Medium,
		heater_efficiency = heater_efficiency,
		T_cold_set = T_cold_set,
		T_hot_set = T_hot_set) annotation(
			Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

	// Temperature sensor
	SolarTherm.Models.Fluid.Sensors.Temperature temperature(
		redeclare package Medium = Medium) annotation(
			Placement(visible = true, transformation(origin = {-20, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));

	// Cold salt pump
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(
		redeclare package Medium = Medium,
		k_loss = k_loss_cold) annotation(
			Placement(visible = true, transformation(origin = {20, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	// Cold salt pump control
	SolarTherm.Models.Control.HeaterControl controlCold(
		level_curtailment_on = cold_tnk_curtailment_ub, 
		level_curtailment_off = cold_tnk_curtailment_lb, 
		level_off = cold_tnk_crit_lb, 
		level_on = cold_tnk_crit_ub, 
		T_heater_set = T_hot_set, 
		m_flow_max = m_flow_heater_max, 
		m_flow_min = 0,
		Ti = Ti,
		Kp = Kp)  annotation(
			Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Hot tank TES
	SolarTherm.Models.Storage.Tank.Tank tankHot(
		redeclare package Medium = Medium, 
		T_set = T_cold_aux_set,
		D = D_storage, 
		H = H_storage, 
		L_start = split_cold*100,
		T_start = T_hot_set, 
		alpha = alpha,
		W_max = W_heater_hot, 
		enable_losses = tnk_enable_losses,
		use_L = true, 
		use_p_top = tnk_use_p_top) annotation(
			Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Cold tank TES
	SolarTherm.Models.Storage.Tank.Tank tankCold(
		redeclare package Medium = Medium, 
		T_set = T_cold_aux_set,
		D = D_storage, 
		H = H_storage, 
		L_start = (1 - split_cold)*100, 
		alpha = alpha,
		T_start = T_cold_set, 
		W_max = W_heater_cold, 
		enable_losses = tnk_enable_losses,
		use_L = true, 
		use_p_top = tnk_use_p_top) annotation(
			Placement(visible = true, transformation(origin = {70, -74}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	// Boiler pump
	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(
		redeclare package Medium = Medium,
		k_loss = k_loss_hot) annotation(
		Placement(visible = true, transformation(origin = {66, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

	// Hot pump control
	SolarTherm.Models.Control.HotPumpControl controlHot(
		level_curtailment_off = hot_tnk_full_lb, 
		level_curtailment_on = hot_tnk_full_ub,
		level_off = hot_tnk_empty_lb, 
		level_on = hot_tnk_empty_ub, 
		m_flow_on = m_flow_hot)  annotation(
		Placement(visible = true, transformation(origin = {82, 70}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));

	// Boiler
	SolarTherm.Models.Fluid.HeatExchangers.Boiler boiler(
		redeclare package Medium = Medium,
		Q_flow_ref = Q_flow_des,
		T_cold_set = T_cold_set, 
		T_hot_set = T_hot_set, 
		nu_min = nu_min_boiler)  annotation(
		Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));

	// Boiler scheduler
	Modelica.Blocks.Sources.CombiTimeTable scheduler(
		fileName = schedule_file, 
		tableName = "m_flow", 
		tableOnFile = true,
		smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
		Placement(visible = true, transformation(origin = {124, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

	// Variables

	Modelica.Blocks.Logical.Or or1 annotation(
		Placement(visible = true, transformation(origin = {-116, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

	Modelica.SIunits.Energy E_thermal(start = 0, fixed = true, displayUnit="MW.h") "Generated Energy";
	Modelica.SIunits.Power P_thermal "Thermal Output power of boiler";

equation

	// Ambient connections
	connect(T_amb.y, tankHot.T_amb) annotation(
	Line(points = {{-39, 64}, {6, 64}, {6, 60}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(p_atm.y, tankHot.p_top) annotation(
	Line(points = {{-7, 76}, {14.5, 76}, {14.5, 60}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(p_atm.y, tankCold.T_amb) annotation(
	Line(points = {{-6, 76}, {30, 76}, {30, -54}, {74, -54}, {74, -64}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
	connect(T_amb.y, tankCold.p_top) annotation(
	Line(points = {{-38, 64}, {-4, 64}, {-4, -60}, {66, -60}, {66, -64}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

	// Renewable heating connections
	connect(gridInput.electricity, heater.P_elec_in) annotation(
	Line(points = {{-60, 0}, {-30, 0}}, color = {0, 0, 127}));
	connect(or1.y, gridInput.curtail) annotation(
	Line(points = {{-112, 0}, {-80, 0}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
	connect(P_elec_schedule.y, gridInput.P_schedule) annotation(
	Line(points = {{-94, -30}, {-88, -30}, {-88, -6}, {-80, -6}}, color = {0, 0, 127}));
	connect(gridInput.on_renewable, heater.on_renewable) annotation(
	Line(points = {{-70, -12}, {-48, -12}, {-48, -6}, {-30, -6}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

	// Fluid connections
	connect(pumpCold.fluid_b, heater.port_a) annotation(
	Line(points = {{10, -80}, {-20, -80}, {-20, -10}}, color = {0, 127, 255}));
	connect(heater.port_b, temperature.fluid_a) annotation(
	Line(points = {{-20, 10}, {-20, 20}}, color = {0, 127, 255}));
	connect(temperature.fluid_b, tankHot.fluid_a) annotation(
	Line(points = {{-20, 40}, {-20, 55}, {0, 55}}, color = {0, 127, 255}));
	connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(
	Line(points = {{20, 43}, {29, 43}, {29, 42}, {56, 42}}, color = {0, 127, 255}));
	connect(pumpHot.fluid_b, boiler.port_a) annotation(
	Line(points = {{76, 42}, {120, 42}, {120, 10}}, color = {0, 127, 255}));
	connect(boiler.port_b, tankCold.fluid_a) annotation(
	Line(points = {{120, -10}, {120, -68}, {80, -68}}, color = {0, 127, 255}));
	connect(tankCold.fluid_b, pumpCold.fluid_a) annotation(
	Line(points = {{30, -80}, {50, -80}, {50, -81}, {60, -81}}, color = {0, 127, 255}));

	// Control Cold connections
	connect(temperature.T, controlCold.T_heater_measured) annotation(
	Line(points = {{-10, 30}, {49.5, 30}, {49.5, -24}, {59, -24}}, color = {0, 0, 127}));
	connect(controlCold.m_flow_heater, pumpCold.m_flow) annotation(
	Line(points = {{81, -30}, {100, -30}, {100, -48}, {20, -48}, {20, -71}}, color = {0, 0, 127}));
	connect(tankCold.L, controlCold.tank_level) annotation(
	Line(points = {{60, -70}, {50, -70}, {50, -30}, {60, -30}}, color = {0, 0, 127}));
	connect(controlCold.curtailment, or1.u2) annotation(
	Line(points = {{70, -42}, {70, -46}, {-136, -46}, {-136, -4}, {-120, -4}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
	connect(gridInput.on_renewable, controlCold.on_input_signal) annotation(
	Line(points = {{-70, -11}, {-70, -36}, {60, -36}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
	connect(controlCold.m_flow_heater, controlHot.m_flow_pump_charging) annotation(
	Line(points = {{82, -30}, {100, -30}, {100, 62}, {92, 62}}, color = {0, 0, 127}));

	// Control Hot connections
	connect(controlHot.m_flow_pump_discharging, pumpHot.m_flow) annotation(
	Line(points = {{71, 70}, {66, 70}, {66, 51}}, color = {0, 0, 127}));
	connect(tankHot.L, controlHot.tank_level) annotation(
	Line(points = {{20, 54}, {36, 54}, {36, 96}, {106, 96}, {106, 78}, {93, 78}}, color = {0, 0, 127}));
	connect(scheduler.y[1], controlHot.m_flow_schedule) annotation(
	Line(points = {{113, 70}, {93, 70}}, color = {0, 0, 127}));
	connect(controlHot.curtailment, or1.u1) annotation(
	Line(points = {{82, 82}, {82, 90}, {-136, 90}, {-136, 0}, {-120, 0}}, color = {255, 0, 255}, pattern = LinePattern.Dash));

	P_thermal = boiler.Q_flow;
	der(E_thermal) = P_thermal;

annotation(
	Diagram(
		coordinateSystem(extent = {{-140, -100}, {140, 100}}), 
		graphics = {
			Bitmap(extent = {{-18, 64}, {-18, 64}})
		}),
	Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
	experiment(StartTime = 0, StopTime = 3.1536e+07, Tolerance = 1e-06, Interval = 300),
	Documentation(revisions = "<html>
	<ul>
	<li> A. Fontalvo Lascano (September 2023) :<br>Released first version. </li>
	</ul>

	</html>"));
end WindPVsaltTESsystem;
