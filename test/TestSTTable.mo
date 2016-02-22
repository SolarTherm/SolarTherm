block TestSTTable
	import SolarTherm.Utilities.Tables.STTable;
	import SolarTherm.Utilities.Tables.table_grid;
	import SolarTherm.Utilities.Tables.table_catrom_interp;
	STTable table = STTable("resources/sym_test_file1.csv", delim=",");
	parameter Integer res(fixed=false);
	parameter Real val(fixed=false);
initial algorithm
	res := table_grid(table, 10, 24, "E");
	val := table_catrom_interp(table, 0., 0., 360./10, 360./24);
end TestSTTable;
