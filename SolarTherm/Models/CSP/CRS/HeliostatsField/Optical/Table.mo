within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
model Table "From table"
  extends OpticalEfficiency;
  parameter String file "File where optical data matrix is stored" annotation (Dialog(
      group="Technical data",
      enable=tableOnFile,
      loadSelector(filter="TMY3 custom-built files (*.motab);;MATLAB MAT-files (*.mat)",
                   caption="Open file in which optical data is present")));
  parameter SolarTherm.Types.Solar_angles angles=SolarTherm.Types.Solar_angles.elo_hra
    "Table angles"
    annotation (Dialog(group="Table data interpretation"));
  SI.Angle angle1;
  SI.Angle angle2;
  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optical_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file)
    annotation (Placement(transformation(extent={{12,12},{32,32}})));
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
  nu=max(0,nu_table.y);
  connect(angle2_input.y, nu_table.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, nu_table.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));
end Table;
