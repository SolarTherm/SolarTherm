within SolarTherm.Utilities;

function electrolyser_current_density
  input Real W "Electrical power [W]";
  input Real T "Working temp. of the electrolyser [C]";
  input Modelica.Blocks.Types.ExternalCombiTable2D polarisation_curve "Table with the values to interpolate";
  output Real i "current density [A/cm2]";
  
  external "C" i = ModelicaStandardTables_CombiTable2D_getValue(polarisation_curve, W, T) annotation(
    Library = {"ModelicaStandardTables", "ModelicaMatIO", "zlib"});
    

end electrolyser_current_density;