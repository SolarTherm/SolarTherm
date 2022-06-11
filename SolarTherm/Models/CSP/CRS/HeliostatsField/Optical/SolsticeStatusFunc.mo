within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
function SolsticeStatusFunc
  input Integer tablefile_status;
  input String psave;
  output String tablefile;

algorithm
 	tablefile:=Modelica.Utilities.Files.loadResource(psave+"/OELT_Solstice.motab");
	
end SolsticeStatusFunc;
