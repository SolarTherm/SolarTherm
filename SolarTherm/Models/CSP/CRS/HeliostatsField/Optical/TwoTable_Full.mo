within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;

model TwoTable_Full
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
    tableName="optical_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(visible = true, transformation(extent = {{12, 14}, {32, 34}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D nu_tableB(
    tableOnFile=true,
    tableName="optical_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);
  Modelica.Blocks.Sources.RealExpression angle2_input(y=to_deg(angle2))
    annotation (Placement(transformation(extent={{-38,6},{-10,26}})));
  Modelica.Blocks.Sources.RealExpression angle1_input(y=to_deg(angle1))
    annotation (Placement(transformation(extent={{-38,22},{-10,42}})));
    
  Real nu_shading;
  Real nu_cosine;
  Real nu_reflection;
  Real nu_blocking;
  Real nu_attenuation;
  Real nu_intercept;
  Real isp_min;
  

  Modelica.Blocks.Tables.CombiTable2D shading_tableA(
    tableOnFile=true,
    tableName="shading_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(visible = true, transformation(extent = {{12, 14}, {32, 34}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D shading_tableB(
    tableOnFile=true,
    tableName="shading_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);
    
  Modelica.Blocks.Tables.CombiTable2D cosine_tableA(
    tableOnFile=true,
    tableName="cosine_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(visible = true, transformation(extent = {{12, 14}, {32, 34}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D cosine_tableB(
    tableOnFile=true,
    tableName="cosine_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);
    
  Modelica.Blocks.Tables.CombiTable2D reflection_tableA(
    tableOnFile=true,
    tableName="reflection_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(visible = true, transformation(extent = {{12, 14}, {32, 34}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D reflection_tableB(
    tableOnFile=true,
    tableName="reflection_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);
    
  Modelica.Blocks.Tables.CombiTable2D blocking_tableA(
    tableOnFile=true,
    tableName="blocking_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(visible = true, transformation(extent = {{12, 14}, {32, 34}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D blocking_tableB(
    tableOnFile=true,
    tableName="blocking_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);
    
  Modelica.Blocks.Tables.CombiTable2D attenuation_tableA(
    tableOnFile=true,
    tableName="attenuation_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(visible = true, transformation(extent = {{12, 14}, {32, 34}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D attenuation_tableB(
    tableOnFile=true,
    tableName="attenuation_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);

  Modelica.Blocks.Tables.CombiTable2D intercept_tableA(
    tableOnFile=true,
    tableName="intercept_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA)
    annotation (Placement(visible = true, transformation(extent = {{12, 14}, {32, 34}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D intercept_tableB(
    tableOnFile=true,
    tableName="intercept_efficiency",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);

  Modelica.Blocks.Tables.CombiTable2D isp_tableA(
    tableOnFile=true,
    tableName="isp",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileA);
  Modelica.Blocks.Tables.CombiTable2D isp_tableB(
    tableOnFile=true,
    tableName="isp",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=fileB);
  
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
  
  shading_tableA.u1 = angle1_input.y;
  shading_tableB.u1 = angle1_input.y;
  shading_tableA.u2 = angle2_input.y;
  shading_tableB.u2 = angle2_input.y;
  nu_shading = max(0,shading_tableA.y + weight*(shading_tableB.y-shading_tableA.y));

  cosine_tableA.u1 = angle1_input.y;
  cosine_tableB.u1 = angle1_input.y;
  cosine_tableA.u2 = angle2_input.y;
  cosine_tableB.u2 = angle2_input.y;
  nu_cosine = max(0,cosine_tableA.y + weight*(cosine_tableB.y-cosine_tableA.y));
  
  reflection_tableA.u1 = angle1_input.y;
  reflection_tableB.u1 = angle1_input.y;
  reflection_tableA.u2 = angle2_input.y;
  reflection_tableB.u2 = angle2_input.y;
  nu_reflection = max(0,reflection_tableA.y + weight*(reflection_tableB.y-reflection_tableA.y));
  
  blocking_tableA.u1 = angle1_input.y;
  blocking_tableB.u1 = angle1_input.y;
  blocking_tableA.u2 = angle2_input.y;
  blocking_tableB.u2 = angle2_input.y;
  nu_blocking = max(0,blocking_tableA.y + weight*(blocking_tableB.y-blocking_tableA.y));
  
  attenuation_tableA.u1 = angle1_input.y;
  attenuation_tableB.u1 = angle1_input.y;
  attenuation_tableA.u2 = angle2_input.y;
  attenuation_tableB.u2 = angle2_input.y;
  nu_attenuation = max(0,attenuation_tableA.y + weight*(attenuation_tableB.y-attenuation_tableA.y));
  
  intercept_tableA.u1 = angle1_input.y;
  intercept_tableB.u1 = angle1_input.y;
  intercept_tableA.u2 = angle2_input.y;
  intercept_tableB.u2 = angle2_input.y;
  nu_intercept = max(0,intercept_tableA.y + weight*(intercept_tableB.y-intercept_tableA.y));
  
  isp_tableA.u1 = angle1_input.y;
  isp_tableB.u1 = angle1_input.y;
  isp_tableA.u2 = angle2_input.y;
  isp_tableB.u2 = angle2_input.y;
  isp_min = min(isp_tableB.y,isp_tableA.y);
end TwoTable_Full;