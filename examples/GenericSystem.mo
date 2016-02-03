model GenericSystem
	import SI = Modelica.SIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;

	// Salt is 60% NaNO3 40% KNO3
	replaceable package MedRec = SolarTherm.Media.Sodium;
	//replaceable package MedRec = SolarTherm.Media.SodiumConst;

	inner Modelica.Fluid.System system(
		energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
		//energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
		allowFlowReversal=false);

	parameter String weaFile = "resources/Alice_Springs_Real2000_Created20130430.motab";
	// Might have to deactivate price calcs if not connected to NEM
	parameter String priFile = "resources/aemo_vic_2014.motab";
	parameter String fieldFile = "resources/field.motab";

	SolarTherm.Utilities.Weather.WeatherSource wea(weaFile=weaFile);
	SolarTherm.Utilities.Finances.SpotPriceTable pri(fileName=priFile);

	SolarTherm.Optics.SteeredConc con(
		redeclare model FluxMap=SolarTherm.Optics.FluxMapFile(fileName=fieldFile),
		steer_rate=0.001,
		target_error=0.001
		);

	SolarTherm.Receivers.RecPoly rec(
		redeclare package Medium=MedRec,
		Q_flow_loss_des=,
		R_des=,
		T_des=,
		ci0=,
		ci1=,
		ci2=,
		ci3=,
		ca0=,
		ca1=,
		ca2=,
		ca3=,
		cw0=,
		cw1=,
		cw2=,
		cw3=
		);

equation
	connect(wea.wbus, con.wbus);
	connect(wea.wbus, rec.wbus);
	connect(con.R_foc, rec.R);
end GenericSystem;
