within SolarTherm.Utilities.Tables;
function tableGrid "Perform symmetry and grid transform to table"
 input STTable table;
 input Integer n;
 input Integer m;
 input String sym;
 output Integer res;
 external "C" res = st_table_grid_transform(table, n, m, sym)
   annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="#include \"st_tables.c\"");
   //annotation(Library="st_tables");
end tableGrid;
