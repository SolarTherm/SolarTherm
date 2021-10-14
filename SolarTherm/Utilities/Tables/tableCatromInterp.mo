within SolarTherm.Utilities.Tables;
function tableCatromInterp "Perform Catmull-Rom interpolation"
 input STTable table;
 input Real x;
 input Real y;
 input Real x_step;
 input Real y_step;
 output Real p;
 external "C" p = st_table_catrom_interp(table, x, y, x_step, y_step)
   //annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
   //   Include="#include \"st_tables.c\"");
   annotation(Library="st_tables");
end tableCatromInterp;
