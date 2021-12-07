within SolarTherm.Utilities;
function FluxInterpolation
	extends Modelica.Icons.Function;
	input String ppath;
	input String pname;
	input String psave;
	input Integer argc;
	input String varnames[:];
	input Real vars[:];
	output Integer result;
	external result = RunInterpolationFunc(ppath, pname, psave, argc, varnames, vars)
	annotation(Library={"python2.7"},
		IncludeDirectory="modelica://SolarTherm/Resources/Include",
		Include="#include \"run_py_interpolation.c\""
		);
end FluxInterpolation;
