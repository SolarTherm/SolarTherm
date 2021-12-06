within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
function SolsticePyFunc
  input String ppath;
  input String pname;
  input String psave;
  input String field_type;
  input String rcv_type;
  input String wea_file;
  input Integer argc;
  input String varnames[:];
  input Real vars[:];
  output Integer result;

  external result = RunSolsticeFunc(ppath, pname, psave, field_type, rcv_type, wea_file, argc, varnames, vars)
    annotation(Library="st_solsticepy");
end SolsticePyFunc;
