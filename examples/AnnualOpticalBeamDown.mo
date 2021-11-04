within examples;

model AnnualOpticalBeamDown

import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELT;
import SI = Modelica.SIunits;
import nSI = Modelica.SIunits.Conversions.NonSIunits;
import metadata = SolarTherm.Utilities.Metadata_Optics;

  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/AUS_WA_Leinster_Airport_954480_TMY.motab");
  parameter nSI.Angle_deg lon = 120.70 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -27.85 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  parameter Real n_h=metadata_list[1] "Number of heliostats";
  parameter SI.Area A_h=metadata_list[2] "Heliostat's Area";
  parameter Real metadata_list[8] = metadata(opt_file);
  parameter String opt_file(fixed=false);
  parameter String casefolder ="test-beamdown";


  parameter nSI.Angle_deg cpc_theta_deg=20 "acceptance half angle of the CPC in degree";
  parameter Real cpc_h_ratio=1 "ratio of CPC critical height [0,1]";
  parameter nSI.Angle_deg rim_angle_x=80 "rim angle of the hyperboloid and heliostat field in the xOz plan in degree";
  parameter nSI.Angle_deg rim_angle_y=80 "rim angle of the hyperboloid and heliostat field in the yOz plan in degree";
  parameter Real secref_inv_eccen=0.6 "Secondary Reflector (hyperboloid) inverse eccentricity [0,1]";
  parameter SI.Length H_tower=75 "Tower height";
  parameter Real fb=0.7 "factor to grow the field layout";
  parameter nSI.Angle_deg tilt_secref=10 "tilt angle of the secondary mirror (hyperboloid) central axis along the N-S axis in degree";
  parameter SI.Length W_rcv=8 "Polygon receiver width";
  parameter SI.Length H_rcv=8 "Polygon receiver length";
  parameter SI.Length Z_rcv=0 "Polygon receiver z position, 0 is on the ground";
  parameter Real n_rays = 5e6 "number of rays for the optical simulation";
  parameter Real n_row_oelt = 5 "number of rows of the look up table (simulated days in a year)";
  parameter Real n_col_oelt = 22 "number of columns of the lookup table (simulated hours per day)";
  parameter SI.HeatFlowRate Q_in_rcv = 50e6;
  parameter SI.Length R1=15. "distance between the first row heliostat and the tower";
  parameter SI.Length W_helio = 6.1 "width of heliostat in m";
  parameter SI.Length H_helio = 6.1 "height of heliostat in m";
  parameter SI.Length Z_helio = 0.0 "heliostat center z location in m";
  parameter SI.Angle slope_error_bd = 1e-3 "slope error of all reflective surfaces in mrad";
  parameter SI.Efficiency rho_secref = 0.95 "reflectivity of the secondary reflector (hyperboloid)";
  parameter SI.Efficiency rho_cpc = 0.95 "reflectivity of the CPC";
  parameter Real cpc_nfaces=4 "2D-crossed cpc with n faces";
  parameter Real n_H_rcv=40 "rendering of flux map on receiver";

	//Sun
	SolarTherm.Models.Sources.SolarModel.Sun sun(
		lon = data.lon,
		lat = data.lat,
		t_zone = data.t_zone,
		year = data.year,
		redeclare function solarPosition = SolarTherm.Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
																										Placement(transformation(extent = {{-82, 60}, {-62, 80}})));


	//Weather data
	SolarTherm.Models.Sources.DataTable.DataTable data(
		lon = lon,
		lat = lat,
		t_zone = t_zone,
		year = year,
		file = wea_file) annotation(
											Placement(visible = true, transformation(extent = {{-100, -50}, {-70, -22}}, rotation = 0)));

	//DNI_input
	Modelica.Blocks.Sources.RealExpression DNI_input(
		y = data.DNI) annotation(
									Placement(visible = true, transformation(extent = {{-102, 64}, {-82, 84}}, rotation = 0)));

SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELTBeamdown lookuptable(
        cpc_theta_deg=cpc_theta_deg,
        cpc_h_ratio=cpc_h_ratio,
        rim_angle_x=rim_angle_x,
        rim_angle_y=rim_angle_y,
        secref_inv_eccen=secref_inv_eccen,
        H_tower=H_tower,
        fb=fb,
        tilt_secref=tilt_secref,
        Z_rcv=Z_rcv,
        W_rcv=W_rcv,
        H_rcv=H_rcv,
        n_rays=n_rays,
        n_row_oelt=n_row_oelt,
        n_col_oelt=n_col_oelt,
        Q_in_rcv=Q_in_rcv,
        R1=R1,
        W_helio=W_helio,
        H_helio=H_helio,
        Z_helio=Z_helio,
        slope_error_bd=slope_error_bd,
        rho_secref=rho_secref,
        rho_cpc=rho_cpc,
        cpc_nfaces=cpc_nfaces,
        n_H_rcv=n_H_rcv,
        psave=casefolder,
        hra=sun.solar.hra,
        dec=sun.solar.dec,
        lat=lat);

Real opt_eff;
Real opt_ann_eff "annual optical efficiency";

SI.Energy E_sun;
SI.Energy E_rcv;
SI.HeatFlowRate Q_sun;
SI.HeatFlowRate Q_rcv;

initial equation
   opt_file=lookuptable.tablefile;

equation
  opt_eff=lookuptable.nu;
  Q_sun=sun.dni*n_h*A_h;
  der(E_sun)=Q_sun;

  Q_rcv=sun.dni*n_h*A_h*opt_eff;
  der(E_rcv)=Q_rcv;
  if E_rcv>0.1 then opt_ann_eff=E_rcv/E_sun;
  else opt_ann_eff=0;
  end if;

  connect(DNI_input.y, sun.dni) annotation(
												Line(points = {{-119, 70}, {-102, 70}, {-102, 69.8}, {-82.6, 69.8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

  annotation(
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 60),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>
	<ul>
	<li> Y. Wang (23 Jun 2021) :<br>Released first version. </li>
	</ul>

	</html>"),
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1)));
end AnnualOpticalBeamDown;
