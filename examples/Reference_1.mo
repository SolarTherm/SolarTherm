within examples;
model Reference_1
	import SolarTherm.{Models,Media};
	import Modelica.SIunits.Conversions.from_degC;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;

	extends Modelica.Icons.Example;

	// Input Parameters
	// *********************
	parameter String file_weather = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
	parameter String file_optics =  Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/example_optics.motab");

	parameter SI.Area A_heliostat = 144.375 "Heliostat reflective area";
	parameter Integer n_heliostat = 6377 "Heliostats number";
	parameter SI.Length H_tower = 183.33 "Tower height";
	parameter SI.Length H_receiver = 18.67 "Receiver height";
	parameter SI.Diameter D_receiver = 15 "Receiver diameter";
	parameter Real t_storage(unit="h") = 4 "Hours of storage";
	parameter SI.Power P_name = 100e6 "Nameplate rating of power block";
	parameter SI.Power P_gross = 111e6 "Power block gross rating at design point";
	parameter SI.Efficiency eff_blk = 0.3774 "Power block efficiency at design point";
	parameter SI.Area A_land = 5876036 "Land area";

	parameter SI.Area A_field = n_heliostat * A_heliostat "Solar field reflective area";
	parameter SI.Area A_receiver = CN.pi*D_receiver*H_receiver "Receiver area";
	parameter SI.HeatFlowRate Q_flow_des = P_gross/eff_blk "Heat to power block at design point";
	parameter SI.Energy E_max = t_storage*3600*Q_flow_des "Maximum tank stored energy";

	// Cost data
	parameter Real r_disc = 0.07 "Discount rate";
	parameter Real r_i = 0.03 "Inflation rate";
	parameter Integer t_life = 27 "Lifetime of plant in years";
	parameter Integer t_cons = 3 "Years of construction";

	parameter Real f_Subs = 0 "Subsidies on initial investment costs";

	parameter FI.AreaPrice pri_field = 180 "Field cost per design aperture area";
	parameter FI.AreaPrice pri_site = 20 "Site improvements cost per area";
	parameter FI.EnergyPrice pri_storage = 37/(1e3*3600) "Storage cost per energy capacity";
	parameter FI.PowerPrice pri_block = 1000/1e3 "Power block cost per gross rated power";
	parameter FI.PowerPrice pri_bop = 350/1e3 "Balance of plant cost per gross rated power";
	parameter FI.AreaPrice pri_land = 10000/4046.86 "Land cost per area";

	parameter Real pri_om_name(unit="$/W/year") = 56.715/1e3 "Fixed O&M cost per nameplate per year"; // It is 58 $/kW/year in Mehdi's report, but Andrew suggsted a more recent number
	parameter Real pri_om_prod(unit="$/J/year") = 5.7320752/(1e6*3600) "Variable O&M cost per production per year"; // It was 5.9656 $/MWh/year in Mehdi's report, but Andrew suggsted a more recent number

	parameter FI.Money C_field = pri_field * A_field "Field cost";
	parameter FI.Money C_site = pri_site * A_field "Site improvements cost";
	parameter FI.Money C_tower = 3117043.67*exp(0.0113*H_tower) "Tower cost";
	parameter FI.Money C_receiver = 71708855*((A_receiver/879.8)^0.7) "Receiver cost";
	parameter FI.Money C_storage = pri_storage * E_max "Storage cost";
	parameter FI.Money C_block = pri_block * P_gross "Power block cost";
	parameter FI.Money C_bop = pri_bop * P_gross "Balance of plant cost";

	parameter FI.Money C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage + C_block + C_bop) "Direct capital cost subtotal"; // i.e. purchased equipment costs
	parameter FI.Money C_contingency = 0.07 * C_cap_dir_sub "Contingency costs";
	parameter FI.Money C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money C_EPC = 0.11 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
	parameter FI.Money C_land = pri_land * A_land "Land cost";
	parameter FI.Money C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";

	parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
	parameter Real C_prod(unit="$/J/year") = pri_om_prod "Variable O&M cost per production per year";

	// System components
	// *********************
	SolarTherm.Models.Sources.SolarModel.Sun sun(
		lon=data.lon,
		lat=data.lat,
		t_zone=data.t_zone,
		year=data.year,
		redeclare function solarPosition =
			SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm)
			annotation(Placement(transformation(extent={{-82,60},{-62,80}})));

	SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField heliostatsField(
		n_h=n_heliostat,
		lon=data.lon,
		lat=data.lat,
		ele_min(displayUnit="deg") = 0.13962634015955,
		Wspd_max=15,
		use_wind=true,
		he_av=0.99,
		use_on=true,
		use_defocus=true,
		A_h=A_heliostat,
		nu_defocus=1,
		nu_min=0.3,
		Q_design=330000000,
		nu_start=0.6,
		redeclare model Optical = SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table (
			angles=SolarTherm.Types.Solar_angles.elo_hra, file=file_optics))
			annotation (Placement(transformation(extent={{-88,2},{-56,36}})));

	SolarTherm.Models.CSP.CRS.Receivers.ReceiverSimple receiver(
		em=0.88,
		redeclare package Medium = Media.MoltenSalt.MoltenSalt_ph,
		H_rcv=H_receiver,
		D_rcv=D_receiver,
		N_pa=20,
		t_tb=1.25e-3,
		D_tb=40e-3,
		ab=0.94) annotation (Placement(transformation(extent={{-46,4},{-10,40}})));
		Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(Placement(transformation(extent={{-140,60},
		{-120,80}})));

	Modelica.Blocks.Sources.RealExpression Tamb_input(y=data.Tdry) annotation(Placement(transformation(extent={{140,70},
			{120,90}})));

	SolarTherm.Models.Storage.Tank.Tank tankHot(
		redeclare package Medium = Media.MoltenSalt.MoltenSalt_ph,
		T_start=from_degC(574),
		L_start=30,
		alpha=3,
		use_p_top=true,
		enable_losses=true,
		use_L=true,
		T_set=from_degC(500))
		annotation (Placement(transformation(extent={{16,54},{36,74}})));
		SolarTherm.Models.Fluid.Pumps.PumpSimple pumpHot(redeclare package Medium =
		Media.MoltenSalt.MoltenSalt_ph) annotation(Placement(transformation(extent={{66,38},
			{78,50}})));

	SolarTherm.Models.Storage.Tank.Tank tankCold(
		redeclare package Medium = Media.MoltenSalt.MoltenSalt_ph,
		T_start=from_degC(290),
		L_start=70,
		alpha=3,
		use_p_top=true,
		enable_losses=true,
		use_L=true,
		T_set=from_degC(280))
		annotation (Placement(transformation(extent={{64,-28},{44,-8}})));

	SolarTherm.Models.Fluid.Pumps.PumpSimple pumpCold(
		redeclare package Medium =Media.MoltenSalt.MoltenSalt_ph,
		k_loss=0.15e3)
		annotation(Placement(transformation(extent={{10,-30},{-2,-18}})));

	SolarTherm.Models.Sources.DataTable.DataTable data(
		t_zone=9.5,
		file=file_weather)
		annotation(Placement(
		transformation(extent={{-138,-30},{-108,-2}})));

	SolarTherm.Models.Fluid.Sensors.Temperature temperature(redeclare package
	Medium = Media.MoltenSalt.MoltenSalt_ph) annotation(Placement(transformation(extent={{-14,74},
	{-4,64}})));

	Modelica.Blocks.Sources.RealExpression Pres_input(y=data.Pres)
	annotation (Placement(transformation(extent={{76,18},{56,38}})));

	SolarTherm.Models.Control.PowerBlockControl controlHot(
		m_flow_on=682.544,
		L_off=5,
		L_df_on=120,
		L_df_off=123,
		L_on=10) annotation (Placement(transformation(extent={{48,72},{60,58}})));

	SolarTherm.Models.Control.ReceiverControl controlCold(
		T_ref=from_degC(574),
		m_flow_max=1400,
		y_start=1000,
		L_df_on=5,
		L_df_off=7,
		L_off=0,
		Ti=0.1,
		Kp=-1000) annotation (Placement(transformation(extent={{24,-10},{10,4}})));

	SolarTherm.Models.PowerBlocks.PowerBlockModel powerBlock(
		W_des=P_gross,
		enable_losses=true,
		redeclare model Cycle = SolarTherm.Models.PowerBlocks.Correlation.Rankine,
		nu_min=0.5,
		external_parasities=true,
		W_base=0.0055*111e6,
		p_bo=10000000,
		T_des=316.15,
		redeclare model Cooling = SolarTherm.Models.PowerBlocks.Cooling.SAM(T_des=316.15))
		annotation (Placement(transformation(extent={{88,4},{124,42}})));

	Modelica.Blocks.Sources.RealExpression Wspd_input(y=data.Wspd)
		annotation(Placement(transformation(extent={{-140,20},{-114,40}})));

	SolarTherm.Models.Analysis.Market market(redeclare model Price =
		SolarTherm.Models.Analysis.EnergyPrice.Constant)
		annotation (Placement(transformation(extent={{126,12},{146,32}})));

	Modelica.Blocks.Sources.RealExpression parasities_input(y=heliostatsField.W_loss
		+ pumpHot.W_loss + pumpCold.W_loss + tankHot.W_loss + tankCold.W_loss)
		annotation (Placement(transformation(
		extent={{-13,-10},{13,10}},
		rotation=-90,
		origin={109,60})));

	Modelica.Blocks.Logical.Or or1
		annotation (Placement(transformation(extent={{-102,4},{-94,12}})));

	// Variables:
	SI.Power P_elec "Output power of power block";
	SI.Energy E_elec(start=0, fixed=true) "Generate electricity";
	FI.Money R_spot(start=0, fixed=true) "Spot market revenue";

equation
	connect(sun.solar, heliostatsField.solar) annotation(Line(points={{-72,60},
		{-72,36}}, color = {255, 128, 0}));
	connect(heliostatsField.heat, receiver.heat) annotation(Line(points={{-55.68,27.5},
		{-54.82,27.5},{-54.82,27.4},{-46,27.4}}, color = {191, 0, 0}));
	connect(tankHot.fluid_b, pumpHot.fluid_a) annotation(Line(points={{36,57},
		{36,52},{36,44},{48,44},{48,43.88},{66,43.88}}, color = {0, 127, 255}));
	connect(receiver.fluid_a, pumpCold.fluid_b) annotation(Line(points={{-24.4,5.8},
		{-14.2,5.8},{-14.2,-24},{-2,-24}}, color = {0, 127, 255}));
	connect(pumpCold.fluid_a, tankCold.fluid_b) annotation(Line(points={{10,-24.12},
		{10,-24.12},{10,-25},{44,-25}}, color = {0, 127, 255}));
	connect(receiver.fluid_b, temperature.fluid_a) annotation (Line(points={{-21.88,30.64},
		{-21.88,30},{-20,30},{-16,30},{-16,69},{-14,69}}, color={0,127,255}));
	connect(controlHot.m_flow, pumpHot.m_flow) annotation (Line(points={{60.72,65},
		{72,65},{72,49.16}}, color={0,0,127}));
	connect(controlCold.m_flow, pumpCold.m_flow) annotation (Line(points={{9.16,-3},
		{4,-3},{4,-18.84}}, color={0,0,127}));
	connect(temperature.T, controlCold.T_mea) annotation (Line(points={{-9,63.9},
		{-10,63.9},{-10,24},{38,24},{38,1.2},{24.7,1.2}},  color={0,0,127}));
	connect(controlCold.L_mea, tankCold.L) annotation (Line(points={{24.56,-3},
		{38,-3},{38,-13.6},{43.8,-13.6}}, color={0,0,127}));
	connect(pumpHot.fluid_b, powerBlock.fluid_a) annotation (Line(points={{78,44},
		{86,44},{86,29.46},{98.08,29.46}}, color={0,127,255}));
	connect(tankHot.L,controlHot. L_mea) annotation (Line(points={{36.2,68.4},{40,
		68.4},{40,68.5},{47.52,68.5}},color={0,0,127}));
	connect(heliostatsField.on, controlCold.sf_on) annotation (Line(points={{-72,2},
		{-72,2},{-72,-36},{28,-36},{28,-6},{24.7,-6},{24.7,-7.2}}, color={255,0,255}));
	connect(DNI_input.y, sun.dni) annotation (Line(points={{-119,70},
		{-102,70},{-102,69.8},{-82.6,69.8}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(Wspd_input.y, heliostatsField.Wspd) annotation (Line(points={{-112.7,30},
		{-100,30},{-100,29.54},{-87.68,29.54}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(Pres_input.y, tankCold.p_top) annotation (Line(points={{55,28},
		{49.5,28},{49.5,20},{49.5,-8.3}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(Pres_input.y, tankHot.p_top) annotation (Line(points={{55,28},
		{46,28},{8,28},{8,78},{30.5,78},{30.5,73.7}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(Tamb_input.y, powerBlock.T_amb) annotation (Line(points={{119,80},
		{102.4,80},{102.4,34.4}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(Tamb_input.y, tankHot.T_amb) annotation (Line(points={{119,80},
		{68,80},{21.9,80},{21.9,73.7}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(receiver.Tamb, tankHot.T_amb) annotation (Line(points={{-28,36.04},
		{-28,80},{21.9,80},{21.9,73.7}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(tankCold.T_amb, powerBlock.T_amb) annotation (Line(points={{58.1,-8.3},
		{58.1,20},{90,20},{92,20},{92,42},{102.4,42},{102.4,34.4}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(powerBlock.fluid_b, tankCold.fluid_a) annotation (Line(points={{95.56,14.64},
		{78,14.64},{78,-13},{64,-13}}, color={0,127,255}));
	connect(temperature.fluid_b, tankHot.fluid_a) annotation (Line(points={{-4,69},
		{-4,69},{16,69}}, color={0,127,255}));
	connect(controlHot.m_flow_in, pumpCold.m_flow) annotation (Line(points={{47.52,61.5},
	{39.52,61.5},{39.52,30},{4,30},{4,-18.84}}, color={0,0,127}));
	connect(or1.y, heliostatsField.defocus) annotation (Line(points={{-93.6,8},
		{-92,8},{-92,8.8},{-87.68,8.8}}, color={255,0,255}, pattern=LinePattern.Dash));
	connect(controlCold.defocus, or1.u2) annotation (Line(points={{17,-10.98},
		{17,-32},{-106,-32},{-106,4.8},{-102.8,4.8}}, color={255,0,255}, pattern=LinePattern.Dash));
	connect(controlHot.defocus, or1.u1) annotation (Line(points={{54,72.98},
		{54,72.98},{54,86},{-106,86},{-106,8},{-102.8,8}}, color={255,0,255}, pattern=LinePattern.Dash));
	connect(parasities_input.y, powerBlock.parasities) annotation (Line(points={{109,45.7},
		{109,40.85},{109.6,40.85},{109.6,34.4}}, color={0,0,127}, pattern=LinePattern.Dot));
	connect(powerBlock.W_net, market.W_net) annotation (Line(points={{115.18,22.05},
		{119.59,22.05},{119.59,21.8},{126,21.8}}, color={0,0,127}));

	P_elec = powerBlock.W_net;
	E_elec = powerBlock.E_net;
	R_spot = market.profit;

	annotation(Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}),
		graphics={
			Text(
				extent={{4,92},{40,90}},
				lineColor={217,67,180},
				fontSize=9,
				textString="defocus strategy"),
			Text(
				extent={{-50,-40},{-14,-40}},
				lineColor={217,67,180},
				fontSize=9,
				textString="on/off strategy"),
			Text(
				extent={{-52,8},{-4,-12}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Receiver"),
			Text(
				extent={{-110,4},{-62,-16}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Heliostats Field"),
			Text(
				extent={{-80,86},{-32,66}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Sun"),
			Text(
				extent={{0,58},{48,38}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Hot Tank"),
			Text(
				extent={{30,-24},{78,-44}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Cold Tank"),
			Text(
				extent={{80,12},{128,-8}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Power Block"),
			Text(
				extent={{112,16},{160,-4}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Market"),
			Text(
				extent={{-6,20},{42,0}},
				lineColor={0,0,0},
				fontSize=8,
				textString="Receiver Control"),
			Text(
				extent={{30,62},{78,42}},
				lineColor={0,0,0},
				fontSize=8,
				textString="Power Block Control"),
			Text(
				extent={{-146,-26},{-98,-46}},
				lineColor={0,0,0},
				fontSize=10,
				textString="Data Source")}),
	Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
	experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
	__Dymola_experimentSetupOutput,
	Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Reference_1;
