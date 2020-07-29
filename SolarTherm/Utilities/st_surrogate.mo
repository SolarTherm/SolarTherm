within SolarTherm.Utilities;

function st_surrogate
 input Real raw_input[:];
 input Integer inputsize;
 input String saved_model_dir;
 output Real result;
 external result = st_surrogate(raw_input,inputsize,saved_model_dir)
 annotation
    (Library = {"surrogate","tensorflow"},
     LibraryDirectory="modelica://SolarTherm/Resources/Include/lib/");
end st_surrogate;