within SolarTherm.Utilities;

function DNI_horizon
extends Modelica.Icons.Function;
  input Real time_horizon;
  input Modelica.Blocks.Types.ExternalCombiTable1D weather "Table with the values to interpolate";
  output Real dni "DNI for the next forecast horizon";
  external"C" dni = ModelicaStandardTables_CombiTable1D_getValue(weather, 2, time_horizon)
      annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});


end DNI_horizon;