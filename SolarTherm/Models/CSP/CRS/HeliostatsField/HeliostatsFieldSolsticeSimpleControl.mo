within SolarTherm.Models.CSP.CRS.HeliostatsField;
model HeliostatsFieldSolsticeSimpleControl
    extends Interfaces.Models.Heliostats;

    import metadata = SolarTherm.Utilities.Metadata_Optics;
    parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location"));
    parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location"));
    parameter Real method = 1 "method of the system design, 1 is design from the PB, and 2 is design from the field";
    parameter SI.HeatFlowRate Q_in_rcv = 1e6;
   parameter String sunshape = "Buie";
   parameter Real csr = 0.02 "circumsolar ratio";

	// heliostat field
    parameter Real n_h=metadata_list[1] "Number of heliostats" annotation(Dialog(group="Technical data"));
    parameter SI.Area A_h=W_helio*H_helio  "Heliostat's Area" annotation(Dialog(group="Technical data"));
    parameter Real he_av=0.99 "Heliostat availability" annotation(Dialog(group="Technical data"));
    parameter SI.Length W_helio = 10 "width of heliostat in m";
    parameter SI.Length H_helio = 10 "height of heliostat in m";
    parameter SI.Length H_tower = 100 "Tower height";
    parameter SI.Length R_tower = 0.01 "Tower diameter";
    parameter SI.Length R1=80 "distance between the first row heliostat and the tower";
    parameter Real fb=0.7 "factor to grow the field layout";
    parameter SI.Efficiency rho_helio = 0.9 "reflectivity of heliostat max =1";
    parameter SI.Angle slope_error = 2e-3 "slope error of the heliostat in mrad";

	// receiver
    parameter SI.Length H_rcv=10 "Receiver aperture height";
    parameter SI.Length W_rcv=10 "Receiver aperture width";
    parameter Real n_H_rcv=10 "num of grid in the vertical direction (for flux map)";
    parameter Real n_W_rcv=10 "num of grid in the horizontal/circumferetial direction (for flux map)";
    parameter nSI.Angle_deg tilt_rcv = 0 "tilt of receiver in degree relative to tower axis";
    parameter SI.HeatFlowRate Q_design=529.412 "Receiver design thermal power (with heat losses)" annotation(min=0,Dialog(group="Operating strategy")); 

    parameter Real n_row_oelt = 3 "number of rows of the look up table (simulated days in a year)";
    parameter Real n_col_oelt = 3 "number of columns of the lookup table (simulated hours per day)";
    parameter Real n_rays = 5e6 "number of rays for the optical simulation";

    parameter String psave = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Resources/tmp/solstice-result/demo") "the directory for saving the results";  
    parameter String field_type = "polar" "Other options are : surround";
    parameter String rcv_type = "flat" "other options are : flat, cylindrical, stl";  
	parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab"); 

    parameter SI.Angle ele_min=from_deg(8) "Heliostat stow deploy angle" annotation(min=0,Dialog(group="Operating strategy"));

    parameter String opt_file(fixed=false);
    parameter Real metadata_list[9] = metadata(opt_file);

  SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELT optical(hra=solar.hra, dec=solar.dec, lat=lat, method=method, Q_in_rcv=Q_in_rcv, H_rcv=H_rcv, W_rcv=W_rcv, n_H_rcv=n_H_rcv, n_W_rcv=n_W_rcv, tilt_rcv=tilt_rcv, W_helio=W_helio, H_helio=H_helio, H_tower=H_tower, R_tower=R_tower, R1=R1, fb=fb, rho_helio=rho_helio,slope_error=slope_error, n_row_oelt=n_row_oelt, n_col_oelt=n_col_oelt, n_rays=n_rays, field_type=field_type, rcv_type=rcv_type, psave=psave, wea_file=wea_file, sunshape=sunshape, csr=csr);

  SI.HeatFlowRate Q_raw;
  SI.HeatFlowRate Q_net;
  SI.HeatFlowRate Q_solar;  

  SI.Angle elo;
  SI.Angle ele;
  SI.Angle zen;
  SI.Angle zen2;
  SI.Angle azi;


initial equation

   opt_file=optical.tablefile;


equation

  Q_solar=max(n_h*A_h*solar.dni,0);
  Q_raw=max(he_av*n_h*A_h*solar.dni*optical.nu,0);
  Q_net= Q_raw;
  heat.Q_flow= -Q_net;


  elo=SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(solar.dec);

  ele=SolarTherm.Models.Sources.SolarFunctions.elevationAngle(
    solar.dec,
    solar.hra,
    lat);
  zen=pi/2-ele;
  zen2=SolarTherm.Models.Sources.SolarFunctions.aparentSolarZenith(
    solar.dec,
    solar.hra,
    lat);
  azi=SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(
    solar.dec,
    solar.hra,
    lat);


  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Ye Wang <br>Released first version. </li>
</ul>
</html>"));
end HeliostatsFieldSolsticeSimpleControl;
