within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
model Table_defocus "From table"
  extends OpticalEfficiency_defocus;
  parameter String file "File where optical data matrix is stored" annotation (Dialog(
      group="Technical data",
      enable=tableOnFile,
      loadSelector(filter="TMY3 custom-built files (*.motab);;MATLAB MAT-files (*.mat)",
                   caption="Open file in which optical data is present")));
  parameter SolarTherm.Types.Solar_angles angles=SolarTherm.Types.Solar_angles.elo_hra
    "Table angles"
    annotation (Dialog(group="Table data interpretation"));
  parameter Real ratio;
  SI.Angle ele;
  SI.Angle angle1;
  SI.Angle angle2;
  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optics",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file)
    annotation (Placement(transformation(extent={{12,12},{32,32}})));
    
  Modelica.Blocks.Sources.RealExpression angle2_input(y=to_deg(angle2))
    annotation (Placement(transformation(extent={{-38,6},{-10,26}})));
  Modelica.Blocks.Sources.RealExpression angle1_input(y=to_deg(angle1))
    annotation (Placement(transformation(extent={{-38,22},{-10,42}})));
  
  Modelica.Blocks.Tables.CombiTable2D nu_table_120(
    tableOnFile=true,
    tableName="optics_1.2",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file);
  Modelica.Blocks.Tables.CombiTable2D nu_table_80(
    tableOnFile=true,
    tableName="optics_0.8",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file);
  Modelica.Blocks.Tables.CombiTable2D nu_table_60(
    tableOnFile=true,
    tableName="optics_0.6",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file);
  
  Modelica.Blocks.Tables.CombiTable2D unavail_120(
    tableOnFile=true,
    tableName="unavail_1.2",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file);
  Modelica.Blocks.Tables.CombiTable2D unavail_100(
    tableOnFile=true,
    tableName="unavail_1.0",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file);
  Modelica.Blocks.Tables.CombiTable2D unavail_80(
    tableOnFile=true,
    tableName="unavail_0.8",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file);
  Modelica.Blocks.Tables.CombiTable2D unavail_60(
    tableOnFile=true,
    tableName="unavail_0.6",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file);
 
equation
  ele=SolarTherm.Models.Sources.SolarFunctions.elevationAngle(dec,hra,lat);
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
  nu_100=max(0,nu_table.y);
  nu_120=max(0,nu_table_120.y);
  nu_80=max(0,nu_table_80.y);
  nu_60=max(0,nu_table_60.y);
  nu=max(0,SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SWInterp(nu_60,nu_80,nu_100,nu_120,ele,dni));
  
  nu_unavail_120=max(0,unavail_120.y);
  nu_unavail_100=max(0,unavail_100.y);
  nu_unavail_80=max(0,unavail_80.y);
  nu_unavail_60=max(0,unavail_60.y);
  nu_unavail=max(0,SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SWInterp(nu_unavail_60,nu_unavail_80,nu_unavail_100,nu_unavail_120,ele,dni));
  //nu=nu_100;
  connect(angle2_input.y, nu_table.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, nu_table.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));
  connect(angle2_input.y, nu_table_120.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, nu_table_120.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));
  connect(angle2_input.y, nu_table_80.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, nu_table_80.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));
  connect(angle2_input.y, nu_table_60.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, nu_table_60.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));

  connect(angle2_input.y, unavail_120.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, unavail_120.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));
  connect(angle2_input.y, unavail_100.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, unavail_100.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));
  connect(angle2_input.y, unavail_80.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, unavail_80.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));
  connect(angle2_input.y, unavail_60.u2)
    annotation (Line(points={{-8.6,16},{10,16}}, color={0,0,127}));
  connect(angle1_input.y, unavail_60.u1) annotation (Line(points={{-8.6,32},{2,32},
          {2,28},{10,28}}, color={0,0,127}));

end Table_defocus;