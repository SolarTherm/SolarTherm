within SolarTherm.Models.Sources.DataTable;
model DataTable
  extends Icons.Data;

  parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location"));
  parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location"));
  parameter nSI.Time_hour t_zone=9.5 "Local time zone (UCT=0)" annotation(Dialog(group="System location"));
  parameter Integer year=1996 "Year" annotation(Dialog(group="Table data definition"));
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
  output Real Albeldo;

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
  DNI=table.y[2];
  DHI=table.y[3];
  Tdry=from_degC(table.y[4]);
  Tdew=from_degC(table.y[5]);
  RH=table.y[6];
  Pres=1e2*table.y[7];
  Wspd=table.y[8];
  Wdir=from_deg(table.y[9]);
  Albeldo=table.y[10];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model wrapps the extraction of weather data by mean a file <i>.mat</i>.</p>
</html>"));
end DataTable;
