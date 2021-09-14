within SolarTherm.Utilities;

function pri_horizon
extends Modelica.Icons.Function;
  input Real time_horizon;
  input Modelica.Blocks.Types.ExternalCombiTable1D price "Table with the values to interpolate";
  output Real pri "wind speed for the next forecast horizon";
  external"C" pri = ModelicaStandardTables_CombiTable1D_getValue(price, 2, time_horizon)
      annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});


end pri_horizon;