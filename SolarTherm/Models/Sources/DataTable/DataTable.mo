within SolarTherm.Models.Sources.DataTable;
model DataTable
  extends Icons.Data;

  parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location and year"));
  parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location and year"));
  parameter nSI.Time_hour t_zone=9.5 "Local time zone (UCT=0)" annotation(Dialog(group="System location and year"));
  parameter Integer year=1996 "Year" annotation(Dialog(group="System location and year"));
  parameter String file = "Data/Weather/mat_Australia NT Alice Springs Airport 2000 (TMY3).mat"
    "File where data matrix is stored"
    annotation (Dialog(
      group="Table data definition",
      enable=tableOnFile,
      loadSelector(filter="MATLAB MAT-files (*.mat)",
          caption="Open file in which table is present")));
  output SI.Irradiance GHI;
  output SI.Irradiance DNI;
  output SI.Irradiance DHI;
  output SI.Temperature Tdry;
  output SI.Temperature Tdew;
  output Real RH;
  output SI.AbsolutePressure Pres;
  output SI.Velocity Wspd;
  output SI.Angle Wdir;
  output Real Albedo;

protected
  Modelica.Blocks.Sources.CombiTimeTable table(
    tableOnFile=true,
    tableName="data",
    fileName=file,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    columns=2:11)
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

equation
  GHI=table.y[1];
  DNI=max(table.y[2],0);
  DHI=table.y[3];
  Tdry=from_degC(table.y[4]);
  Tdew=from_degC(table.y[5]);
  RH=table.y[6];
  Pres=1e2*table.y[7];
  Wspd=table.y[8];
  Wdir=from_deg(table.y[9]);
  Albedo=table.y[10];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Brief description:</h4>
<p>This model encapsulates the extraction of weather data from a file. Uses a standard CombiTimeTable with a splines interpolation such that derivative is continuous. The file is a SAM&apos;s annual weather data TMY3-file save as a binary MAT-file (Matlab script available for make this operation). This file must to have two matrix, one called &QUOT;names&QUOT; with the variable names and the other called &QUOT;data&QUOT; with the data in columns. </p>
<h4>Inputs:</h4>
<p>The &QUOT;data&QUOT; matrix must to have the following colums in the same order:</p>
<ul>
<li>t (s): Time variable in seconds. The time step usually is one hour, because of TMY3-file, but other time steps are accepted. This time matches with the local time, therefore t=0 s is 00:00 of 1 of January in this time zone.</li>
<li>GHI (W/m2): Total amount of direct and diffuse solar radiation (global horizontal irradiance) received on a horizontal surface Watts per square meter.</li>
<li>DNI (W/m2): Amount of solar radiation received within a limited field of view centered on the sun (direct normal irradiance) in Watts per square meter.</li>
<li>DHI (W/m2): Amount of solar radiation received from the sky, excluding the solar disk on a horizontal surface (diffuse horizontal irradiance) in Watts per square meter.</li>
<li>Tdry (C): Average dry bulb temperature for the hour in degrees Celsius.</li>
<li>Tdew (C): Average dew point temperature for the hour in degrees Celsius.</li>
<li>RH (&percnt;): Average relative humidity for the hour.</li>
<li>Pres (mbar): Station pressure or measured atmospheric pressure in millibars corrected for temperature and humidity for the hour.</li>
<li>Wspd (m/s): Average speed of the wind for the hour in meters per second.</li>
<li>Albedo (adimensional): Ratio of reflected solar radiation to global horizontal radiation. Use -99 for null.</li>
</ul>
<h4>Parameters:</h4>
<h5>System location and year:</h5>
<ul>
<li>lon: Longitude angle in degrees. The sign notation is positive for the East.</li>
<li>lat: Latitude angle in degrees. The sign notation is positive for the North.</li>
<li>t_zone: Local time zone in hours with respect to UCT=0.</li>
<li>year: Year of simulation (Gregorian calendar).</li>
</ul>
<h5>Table data definition:</h5>
<ul>
<li>file: File name and path where MAT-file is stored. </li>
</ul>
<h4>Outputs:</h4>
<p>As output, the model has the same input variables but now as time-varying variables and all of them in SI units.</p>
</html>"));
end DataTable;
