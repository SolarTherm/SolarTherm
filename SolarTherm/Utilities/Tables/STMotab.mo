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
        input String label;
        output String units;
        external "C" units = motab_get_col_units(table, label) annotation(Library="st_motab");
    end getColUnits;
    
    function findColByLabel
        input STMotab table;
        input String label;
        output Integer col;
        external "C" col = motab_find_col_by_label(table, label) annotation(Library="st_motab");
    end findColByLabel;
    
    function getValue
        input STMotab table;
        input Real indep;
        input Integer col;
        output Real val;
        external "C" val = motab_get_value(table, indep, col) annotation(Library="st_motab");
    end getValue;
    
end STMotab;

// vim: ts=4:sw=4:et:tw=80
