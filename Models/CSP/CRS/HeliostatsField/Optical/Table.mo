within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
model Table "From table"
  extends OpticalEfficiency;
  parameter String file "File where optical data matrix is stored" annotation (Dialog(
      group="Technical data",
      enable=tableOnFile,
      loadSelector(filter="MATLAB MAT-files (*.mat)",
          caption="Open file in which optical data is present")));
  SI.Angle elo;
  Modelica.Blocks.Tables.CombiTable2D nu_table(
    tableOnFile=true,
    tableName="optics",
    fileName=file,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{12,12},{32,32}})));
  Modelica.Blocks.Sources.RealExpression hra_input(y=to_deg(hra))
    annotation (Placement(transformation(extent={{-36,6},{-8,26}})));
  Modelica.Blocks.Sources.RealExpression elo_input(y=to_deg(elo))
    annotation (Placement(transformation(extent={{-30,22},{-10,42}})));

equation
  elo=SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(dec);
  nu=max(0,nu_table.y);
  connect(hra_input.y,nu_table. u2)
    annotation (Line(points={{-6.6,16},{10,16}},
                                               color={0,0,127}));
  connect(elo_input.y,nu_table. u1) annotation (Line(points={{-9,32},{2,32},{2,28},
          {10,28}},          color={0,0,127}));
end Table;
