within SolarTherm.Utilities.Tables;
class STTable "Table"
 extends ExternalObject;
 function constructor
  input String file "Name of file to load";
  input String delim "Delimiter used in file";
  output STTable table;
  external "C" table = st_table_init_csv(file, delim)
   annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="#include \"st_tables.c\"");
 end constructor;

 function destructor
  input STTable table;
  external "C" st_table_free(table)
   annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
      Include="#include \"st_tables.c\"");
 end destructor;
end STTable;
