within SolarTherm.Utilities;

function horizon_function
		extends Modelica.Icons.Function;
		input Real time_horizon;
		input Integer column_file;
		input Modelica.Blocks.Types.ExternalCombiTable1D weather_table "Table with the values to interpolate";
		output Real w "output for the next forecast horizon";
		external"C" w = ModelicaStandardTables_CombiTable1D_getValue(weather_table, column_file, time_horizon)
		annotation (Library={"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
end horizon_function;