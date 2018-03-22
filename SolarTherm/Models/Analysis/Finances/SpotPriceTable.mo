within SolarTherm.Models.Analysis.Finances;
block SpotPriceTable "Spot market electricity price table"
 parameter String file "Prices file";
 extends Modelica.Blocks.Sources.CombiTimeTable(verboseRead=false,
  fileName=file, tableOnFile=true, tableName="prices",
  smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
  columns=2:2);
 EnergyPrice price "Spot market electricity price";
equation
 price = y[1]/(1e6*3600);
end SpotPriceTable;
