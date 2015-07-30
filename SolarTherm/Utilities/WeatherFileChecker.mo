within SolarTherm.Utilities;
function WeatherFileChecker "Check and possibly convert weather file"
	input String fileName(fixed=false);
	output String newName(fixed=false);
protected
	String dir;
	String name;
	String ext;
	Integer result;
algorithm
	(dir, name, ext) := Modelica.Utilities.Files.splitPathName(fileName);
	if ext == ".mo" then
		newName := fileName;
	else
		result := command("st_wea_to_mo " + fileName);
		assert(result == 0, "Failed to convert weather file " + fileName);
		newName := dir + name + ".mo";
	end if;
end WeatherFileChecker;
