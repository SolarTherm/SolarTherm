within SolarTherm.Models.Storage;

function GenEffectivenessPyFunc

	input String ppath;
	input String pname;
	input String pfunc;
    input String psave;
    input String modelicapath;
	input Integer argc;
    input String varnames[:];
    input Real vars[:];
	output String result;
	external result =RunStorageFunc(ppath, pname, pfunc, psave, modelicapath, argc, varnames, vars)
	annotation(Library="python3.8",
		IncludeDirectory="modelica://SolarTherm/Resources/Include",
		Include="#include \"run_storage_py.c\""
		);
end GenEffectivenessPyFunc;
