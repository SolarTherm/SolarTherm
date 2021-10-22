within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
function SolsticePyFunc_windy
	input String ppath;
	input String pname;
	input String pfunc;
    input String psave;
    input String field_type;
    input String rcv_type;
    input String wea_file;
	input Integer argc;
    input String varnames[:];
    input Real vars[:];
	output String result;
	external result =RunSolsticeFunc_windy(ppath, pname, pfunc, psave, field_type, rcv_type, wea_file, argc, varnames, vars)
    annotation(Library="st_solsticepy_windy");
end SolsticePyFunc_windy;
