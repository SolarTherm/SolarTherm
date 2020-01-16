within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;

model TwoTable
  extends OpticalEfficiency;
  parameter String fileA "File (for small recv) where optical data matrix is stored" annotation (Dialog(
      group="Technical data",
      enable=tableOnFile,
      loadSelector(filter="TMY3 custom-built files (*.motab);;MATLAB MAT-files (*.mat)",
                   caption="Open file in which optical data is present")));
  parameter String fileB "File (for big recv) where optical data matrix is stored" annotation (Dialog(
      group="Technical data",
      enable=tableOnFile,
      loadSelector(filter="TMY3 custom-built files (*.motab);;MATLAB MAT-files (*.mat)",
                   caption="Open file in which optical data is present")));
  parameter SolarTherm.Types.Solar_angles angles=SolarTherm.Types.Solar_angles.elo_hra
    "Table angles"
    annotation (Dialog(group="Table data interpretation"));
  Real nuA "Efficiency of small recv";
  Real nuB "Efficiency of big recv";
  parameter Real weight "Interpolation weight towards B";
  SI.Angle angle1;
  SI.Angle angle2;
  Modelica.Blocks.Tables.CombiTable2D nu_tableA(
    tableOnFile=true,
    tableName="optics",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(transformation(extent={{12,12},{32,32}})));
  Modelica.Blocks.Tables.CombiTable2D nu_tableB(
    tableOnFile=true,
    tableName="optics",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);
  Modelica.Blocks.Sources.RealExpression angle2_input(y=to_deg(angle2))
    annotation (Placement(transformation(extent={{-38,6},{-10,26}})));
  Modelica.Blocks.Sources.RealExpression angle1_input(y=to_deg(angle1))
    annotation (Placement(transformation(extent={{-38,22},{-10,42}})));
equation
  if angles==SolarTherm.Types.Solar_angles.elo_hra then
    angle1=SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(dec);
    angle2=hra;
  elseif angles==SolarTherm.Types.Solar_angles.dec_hra then
    angle1=dec;
    angle2=hra;
  elseif angles==SolarTherm.Types.Solar_angles.ele_azi then
    angle1=SolarTherm.Models.Sources.SolarFunctions.elevationAngle(dec,hra,lat);
    angle2=SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(dec,hra,lat);
  else
    angle1=SolarTherm.Models.Sources.SolarFunctions.solarZenith(dec,hra,lat);
    angle2=SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(dec,hra,lat);
  end if;
  nuA = nu_tableA.y;
  nuB = nu_tableB.y;
  nu=max(0,nuA+weight*(nuB-nuA));
  nu_tableA.u2 = angle2_input.y;
  nu_tableB.u2 = angle2_input.y; 
  nu_tableA.u1 = angle1_input.y;
  nu_tableB.u1 = angle1_input.y;
end TwoTable;
