within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
function SolsticePyFunc
  input String ppath;
  input String pname;
  input String psave;
  input String wea_file;
  input String sunshape;  
  input String field_type;
  input String rcv_type;
  input String rcv_material;
  input String HTF;  
  input String fluxlimitpath; 
  input Integer argc;
  input String varnames[:];
  input Real vars[:];
  output Integer result;

  external result = RunSolsticeFunc(ppath, pname, psave, wea_file, sunshape, field_type, rcv_type, rcv_material, HTF, fluxlimitpath, argc, varnames, vars)
    annotation(Library="st_solsticepy");
end SolsticePyFunc;
