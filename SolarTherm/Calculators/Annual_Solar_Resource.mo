within SolarTherm.Calculators;

model Annual_Solar_Resource
//Calculates the annual solar resource (integral of DNI) based on a given TMY weather data file
//Alice Springs 1998 "example_TMY3.motab" lat=-23.795, lon=133.889, tzone=9.5
//Daggett 2008 "Daggett_Ca_TMY3.motab" lat=34.85, lon=-116.78, tzone=-8.0

  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/example_TMY3.motab");
  parameter nSI.Angle_deg lon = -23.795 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = 133.889 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = 9.5 "Local time zone (UCT=0)";
  parameter Integer year = 2008 "Meteorological year";
  Real Resource(start=0) "Solar resource (kWh/m2-year)";
SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-120, 82}, {-90, 110}}, rotation = 0)));
equation
  der(Resource) = max(0.0,data.DNI)/(3.6e6);
annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.001, Interval = 300, maxStepSize = 60, initialStepSize = 60));
end Annual_Solar_Resource;