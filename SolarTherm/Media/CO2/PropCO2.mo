within SolarTherm.Media.CO2;

partial model PropCO2

  
inner Modelica.Blocks.Types.ExternalCombiTable2D tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D(tableName = "Enthalpy", fileName = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CO2/Props_from_P_S.txt"), table = fill(0.0, 0, 2), smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments);

  inner Modelica.Blocks.Types.ExternalCombiTable2D tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D(tableName = "Density", fileName = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CO2/Props_from_P_H.txt"), table = fill(0.0, 0, 2), smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments);
  
  inner Modelica.Blocks.Types.ExternalCombiTable2D tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D(tableName = "Temperature", fileName = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CO2/Props_from_P_H.txt"), table = fill(0.0, 0, 2), smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments);
  
inner Modelica.Blocks.Types.ExternalCombiTable2D tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D(
        tableName = "Enthalpy",fileName= Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/CO2/Props_from_P_T.txt"),table=fill(0.0, 0, 2),smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);
 
        
 
end PropCO2;