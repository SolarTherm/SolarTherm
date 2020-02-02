model checktable
    //Declaring the table TAB for h (output) and T (input), ditching out the h_T enthalpy function
    parameter String table_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Media/SolidParticles/CarboHSP_hT.txt");
    import Tables = Modelica.Blocks.Tables;
    Tables.CombiTable1Ds Tab 
    (
      each tableOnFile = true, 
      each tableName = "CarboHSP_hT", 
      each columns = 2:2, 
      each fileName = table_file
    );
    

equation



annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end checktable;