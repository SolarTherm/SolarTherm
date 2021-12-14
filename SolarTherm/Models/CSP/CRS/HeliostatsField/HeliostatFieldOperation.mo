within SolarTherm.Models.CSP.CRS.HeliostatsField;
model HeliostatFieldOperation
  import SolarTherm.Types.Solar_angles;
  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/case_H230_Sodium_290_565.motab");
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  extends SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsField(redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file));

end HeliostatFieldOperation;