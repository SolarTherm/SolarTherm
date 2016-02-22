within SolarTherm.Utilities;
package Tables

class STTable "Table"
	extends ExternalObject;
	function constructor
		input String fn "Name of file to load";
		input String delim "Delimiter used in file";
		output STTable table;
		external "C" table = st_table_init_csv(fn, delim)
			annotation(Library="st_tables");
	end constructor;

	function destructor
		input STTable table;
		external "C" st_table_free(table)
			annotation(Library="st_tables");
	end destructor;
end STTable;

function table_grid "Perform symmetry and grid transform to table"
	input STTable table;
	input Integer n;
	input Integer m;
	input String sym;
	output Integer res;
	external "C" res = st_table_grid_transform(table, n, m, sym)
			annotation(Library="st_tables");
end table_grid;

function table_catrom_interp "Perform Catmull-Rom interpolation"
	input STTable table;
	input Real x;
	input Real y;
	input Real x_step;
	input Real y_step;
	output Real p;
	external "C" p = st_table_catrom_interp(table, x, y, x_step, y_step)
			annotation(Library="st_tables");
end table_catrom_interp;

end Tables;
