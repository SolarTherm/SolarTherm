within SolarTherm.Models.Sources.DataTable;
model DataTable
  extends Icons.Data;

  parameter nSI.Angle_deg lon=133.889 "Longitude (+ve East)" annotation(Dialog(group="System location and year"));
  parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)" annotation(Dialog(group="System location and year"));
  parameter nSI.Time_hour t_zone=9.5 "Local time zone (UCT=0)" annotation(Dialog(group="System location and year"));
  parameter Integer year=1996 "Year" annotation(Dialog(group="System location and year"));
  parameter String file = "Data/mat_Australia NT Alice Springs Airport 2000 (TMY3).mat"
    "File where data matrix is stored"
    annotation (Dialog(
      group="Table data definition",
      enable=tableOnFile,
      loadSelector(filter="TMY3 custom-built files (*.motab);;MATLAB MAT-files (*.mat)",caption="Open file in which table is present")));
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
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    columns=2:11,
    fileName=file)
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
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end DataTable;
