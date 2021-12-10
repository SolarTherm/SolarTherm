within SolarTherm.Utilities;

function PopulateArray
  input Modelica.Blocks.Types.ExternalCombiTable2D yield_table "Table with the values to interpolate";
  input Modelica.SIunits.Angle dec_horizon "Solar declination angle ";
  input Modelica.SIunits.Angle hra_horizon "Solar hour angle";
  output Real yield;
  
  external "C" yield = ModelicaStandardTables_CombiTable2D_getValue(yield_table, dec_horizon, hra_horizon) annotation(
    Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});

end PopulateArray;