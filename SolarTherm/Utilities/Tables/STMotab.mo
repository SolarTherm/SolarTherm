within SolarTherm.Utilities.Tables;

package STMotab
    class STMotab "Modelica Table Reader (SolarTherm implementation)"
    extends ExternalObject;
        function constructor
            input String file "Name of file to load";
            output STMotab table;
            external "C" table = motab_load(file) annotation(Library="st_motab");
        end constructor;

        function destructor
            input STMotab table;
            external "C" motab_free(table) annotation(Library="st_motab");
        end destructor;
    end STMotab;

    function getColUnits
        input STMotab table;
        input String col;
        output String units;
        external "C" units = motab_get_col_units(table, col) annotation(Library="st_motab");
    end getColUnits;
end STMotab;

// vim: ts=4:sw=4:et:tw=80
