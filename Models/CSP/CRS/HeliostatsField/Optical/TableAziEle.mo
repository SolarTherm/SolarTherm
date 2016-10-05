within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
model TableAziEle "From table"
  extends OpticalEfficiency;
  parameter String file "File where optical data matrix is stored" annotation (Dialog(
      group="Technical data",
      enable=tableOnFile,
      loadSelector(filter="MATLAB MAT-files (*.mat)",
          caption="Open file in which optical data is present")));
  parameter nSI.Angle_deg lat=-23.795 "Latitude (+ve North)";
  SI.Angle azi;
  SI.Angle ele;
  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optics",
    fileName=file,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{12,12},{32,32}})));
  Modelica.Blocks.Sources.RealExpression ele_input(y=to_deg(ele))
    annotation (Placement(transformation(extent={{-36,6},{-8,26}})));
  Modelica.Blocks.Sources.RealExpression azi_input(y=to_deg(azi))
    annotation (Placement(transformation(extent={{-30,22},{-10,42}})));

equation
  ele=SolarTherm.Models.Sources.SolarFunctions.elevationAngle(dec,hra,lat=lat);
  azi=SolarTherm.Models.Sources.SolarFunctions.solarAzimuth(dec,hra,lat=lat);
  nu=max(0,nu_table.y);
  connect(ele_input.y,nu_table. u2)
    annotation (Line(points={{-6.6,16},{10,16}},
                                               color={0,0,127}));
  connect(azi_input.y,nu_table. u1) annotation (Line(points={{-9,32},{2,32},{2,28},
          {10,28}},          color={0,0,127}));
end TableAziEle;
