within SolarTherm.Models.Analysis.EnergyPrice;
model Table "Price from a table"
  extends EnergyPrice;
  parameter String file "File where price data matrix is stored" annotation (Dialog(
      group="Technical data",
      enable=tableOnFile,
      loadSelector(filter="TMY3 custom-built files (*.motab);;MATLAB MAT-files (*.mat)",
          caption="Open file in which optical data is present")));
  Modelica.Blocks.Sources.CombiTimeTable table(tableOnFile=true, columns={2}, tableName="price",smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=file)
  annotation (Placement(transformation(extent={{-78,42},{-58,62}})));
equation
  table.y[1]=price;
end Table;
