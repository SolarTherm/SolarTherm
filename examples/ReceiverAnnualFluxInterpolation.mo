within examples;
model ReceiverAnnualFluxInterpolation
	extends Modelica.Icons.Example;
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import SolarTherm.Types.Solar_angles;
	import SolarTherm.Types.Currency;
	import metadata = SolarTherm.Utilities.Metadata_Optics;
	import SolarTherm.Utilities.FluxInterpolation;
	// Parameters
	// *********************
	parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
	parameter Currency currency = Currency.USD "Currency used for cost analysis";
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/seville_spain_37.558_-5.326_60_tmy_2005_2014.motab");
	parameter nSI.Angle_deg lon = -5.326 "Longitude (+ve East)";
	parameter nSI.Angle_deg lat = 37.558 "Latitude (+ve North)";
	parameter nSI.Time_hour t_zone = 1 "Local time zone (UCT=0)";
	parameter Integer year = 2006 "Meteorological year";
	parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/gemasolar_H230_salt600_MDBA.motab");
	parameter Real metadata_list[23] = metadata(opt_file);
	parameter Integer n_heliostat = integer(metadata_list[1]) "Number of heliostats";
	parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
	parameter SI.Area A_heliostat = metadata_list[2] "Heliostat module reflective area";
	parameter Real he_av = 0.99 "Helisotats availability";
	parameter SI.Efficiency eff_opt = metadata_list[3] "Field optical efficiency at design point";
	parameter SI.Irradiance dni_des = 950 "DNI at design point";
	parameter SI.Angle ele_min = Modelica.SIunits.Conversions.from_deg(8) "Heliostat stow deploy angle";
	parameter SI.Velocity Wspd_max = 15 "Wind stow speed";
	parameter Real nu_start = 0.25 "Minimum energy start-up fraction to start the receiver";
	parameter Real nu_min = 0.25 "Minimum turn-down energy fraction to stop the receiver";
	parameter Integer N = 450 "Number of tube segments in flowpath";
	parameter String tableNames[N] = {"flux_" + String(i) for i in 1:N};
	parameter String tablemflowNames[4] = {"mflow_" + String(i - 1) for i in 1:4};
	parameter String file_dni0 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt600_FP1_DNIr3.motab");
	parameter String file_dni1 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt600_FP1_DNIr2.motab");
	parameter String file_dni2 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt600_FP1_DNIr1.motab");
	parameter String file_dni3 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/flux_a230_salt600_FP1_DNIr0.motab");
	parameter String file_mflow = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Data/mflow_a230_salt600_FP1.motab");
	parameter SI.HeatFlowRate Q_start=nu_start*R_des "Heliostat field start power" annotation(min=0,Dialog(group="Operating strategy"));
	parameter SI.HeatFlowRate Q_min=nu_min*R_des "Heliostat field turndown power" annotation(min=0,Dialog(group="Operating strategy"));
	parameter SI.Area A_field = n_heliostat*A_heliostat "Heliostat field reflective area";
	parameter SI.RadiantPower R_des = he_av*dni_des*A_field*eff_opt "Input power to receiver at design point";
	parameter Real[5] CH = {metadata_list[16],metadata_list[17],metadata_list[18],metadata_list[19],metadata_list[20]};
	// Variables
	// *********************
	Boolean on_hf;
	Boolean on_internal;
	SI.HeatFlux CG[N];
	SI.MassFlowRate m_flow_tb;
	SI.Angle ele;
	SI.HeatFlowRate Q_raw;
	SI.HeatFlowRate Q_net;
	SI.CoefficientOfHeatTransfer h_conv;
	// Models
	// *********************
	SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file);
	Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI);
	SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year,redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm);
	SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Table optical(hra=sun.hra, dec=sun.dec, lat=lat, angles = angles, file = opt_file);
protected
	Modelica.Blocks.Sources.RealExpression u1(y = Modelica.SIunits.Conversions.to_deg(sun.dec));
	Modelica.Blocks.Sources.RealExpression u2(y = Modelica.SIunits.Conversions.to_deg(sun.hra));
	Modelica.Blocks.Tables.CombiTable2D flux_dni0[N](each fileName = file_dni0, each tableOnFile = true, each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni1[N](each fileName = file_dni1, each tableOnFile = true, each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni2[N](each fileName = file_dni2, each tableOnFile = true, each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D flux_dni3[N](each fileName = file_dni3, each tableOnFile = true, each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = tableNames);
	Modelica.Blocks.Tables.CombiTable2D m_flow[4](each fileName = file_mflow, each tableOnFile = true, each smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, tableName = tablemflowNames);
initial equation
	on_internal=Q_raw>Q_start;
equation
	connect(DNI_input.y, sun.dni);
	// Flux interpolation
	// *********************
	for i in 1:N loop
	connect(u1.y, flux_dni0[i].u1);
	connect(u2.y, flux_dni0[i].u2);
	connect(u1.y, flux_dni1[i].u1);
	connect(u2.y, flux_dni1[i].u2);
	connect(u1.y, flux_dni2[i].u1);
	connect(u2.y, flux_dni2[i].u2);
	connect(u1.y, flux_dni3[i].u1);
	connect(u2.y, flux_dni3[i].u2);
	//               FluxInterpolation(flux_dni_r0.56 * 1e3, flux_dni_r0.87 * 1e3, flux_dni_r1.00 * 1e3, flux_dni_r1.39 * 1e3, ele, sun.dni, ele_min)
	CG[i] = max(0, FluxInterpolation(flux_dni0[i].y * 1e3, flux_dni1[i].y * 1e3, flux_dni2[i].y * 1e3, flux_dni3[i].y * 1e3, ele, sun.dni, ele_min));
	end for;
	for i in 1:4 loop
	connect(u1.y, m_flow[i].u1);
	connect(u2.y, m_flow[i].u2);
	end for;
	m_flow_tb = max(0, FluxInterpolation(m_flow[4].y, m_flow[3].y, m_flow[2].y, m_flow[1].y, ele, sun.dni, ele_min));
	// End Flux interpolation
	ele = SolarTherm.Models.Sources.SolarFunctions.elevationAngle(sun.dec, sun.hra, lat);
	// On-off logic
	on_hf = ele > ele_min and data.Wspd < Wspd_max;
	Q_raw = if on_hf then max(he_av * n_heliostat * A_heliostat * sun.dni * optical.nu, 0) else 0;
	Q_net = if on_internal then Q_raw else 0;
	when Q_raw>Q_start then
	on_internal=true;
	elsewhen Q_raw<Q_min then
	on_internal=false;
	end when;
	h_conv = CH[5] + CH[4]*data.Wspd + CH[3]*data.Wspd^2 + CH[2]*data.Wspd^3 + CH[1]*data.Wspd^4;
annotation(
Diagram(coordinateSystem(extent = {{-180, 140}, {200, -80}}, initialScale = 0.1)),Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 300),__Dymola_experimentSetupOutput,
Documentation(revisions = "<html><ul><li> A. Fontalvo Lascano (May 2022) :<br>Released first version. </li></ul></html>"));
end ReceiverAnnualFluxInterpolation;
