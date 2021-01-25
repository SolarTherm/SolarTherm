within SolarTherm.Utilities;

function wind_speed_horizon
extends Modelica.Icons.Function;
  input Real time_horizon;
  input Modelica.Blocks.Types.ExternalCombiTable1D weather "Table with the values to interpolate";
  output Real w "eta_optical for the next forecast horizon";
  external"C" w = ModelicaStandardTables_CombiTable1D_getValue(weather, 9, time_horizon)
      annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});


end wind_speed_horizon;