within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
function SolsticePyFunc
	input String ppath;
	input String pname;
	input String pfunc;
    input String psave;
    input String field_type;
    input String rcv_type;
    input String wea_file;
    input String sun_shape;
	input Integer argc;
    input String varnames[:];
    input Real vars[:];
	output String result;
	external result =RunSolsticeFunc(ppath, pname, pfunc, psave, field_type, rcv_type, wea_file, sun_shape, argc, varnames, vars)
	annotation(Library="python2.7",
		IncludeDirectory="modelica://SolarTherm/Resources/Include",
		Include="#include \"run_py_func.c\""
		);
end SolsticePyFunc;
