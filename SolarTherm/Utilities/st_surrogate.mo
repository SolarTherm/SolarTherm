within SolarTherm.Utilities;

function st_surrogate
 input Real raw_input[:];
 input Integer inputsize;
 input String saved_model_dir;
 output Real result;
 external result = st_surrogate(raw_input,inputsize,saved_model_dir)
 annotation(IncludeDirectory="modelica://SolarTherm/Resources/Include",
            Include="#include \"st_surrogate.c\"",
            Library = "tensorflow");
end st_surrogate;