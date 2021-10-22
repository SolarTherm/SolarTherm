within SolarTherm.Utilities;

model TestMetaDataFunction
  import metadata = SolarTherm.Utilities.Metadata_Optics_3Apertures;
  parameter String opt_file = "./OELT_Solstice.motab";
  parameter Real metadata_list[23] = metadata(opt_file);
  
equation

end TestMetaDataFunction;