within examples;

model AnnualOpticalBeamDown

import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELT;
import SI = Modelica.SIunits;
import nSI = Modelica.SIunits.Conversions.NonSIunits;
import metadata = SolarTherm.Utilities.Metadata_Optics;

  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter nSI.Angle_deg lon = 133.889 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = -23.795 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 1996 "Meteorological year";
  parameter Real n_h=metadata_list[1] "Number of heliostats";
  parameter SI.Area A_h=metadata_list[2] "Heliostat's Area"; 
  parameter Real metadata_list[8] = metadata(opt_file);
  parameter String opt_file(fixed=false);
  parameter String casefolder =Modelica.Utilities.Files.loadResource("modelica://SolarTherm/SolsticeResults");  
  
  parameter SI.Length H_tower = 65 "Tower height"; 
  parameter nSI.Angle_deg theta_deg=20 "acceptance half angle of the CPC in degree";
  parameter nSI.Angle_deg rim_angle=45 "rim angle of the heliostat field in the xOz plan in degree";
  parameter SI.Length rec_w=10 "Polygon receiver width";      
  parameter SI.Length rec_l=10 "Polygon receiver length"; 
  parameter SI.Length rec_z=-60 "Polygon receiver z position, 0 is on the ground";    
      
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
        H_tower=H_tower,
        theta_deg=theta_deg,
        rim_angle=rim_angle,
        rec_w=rec_w,
        rec_l=rec_l,
        rec_z=rec_z,
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