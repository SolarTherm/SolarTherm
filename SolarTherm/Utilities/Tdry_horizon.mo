within SolarTherm.Utilities;

function Tdry_horizon
extends Modelica.Icons.Function;
  input Real time_horizon;
  input Modelica.Blocks.Types.ExternalCombiTable1D weather "Table with the values to interpolate";
  output Real Tdry "DNI for the next forecast horizon";
  external"C" Tdry = ModelicaStandardTables_CombiTable1D_getValue(weather, 5, time_horizon)
      annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});


end Tdry_horizon;