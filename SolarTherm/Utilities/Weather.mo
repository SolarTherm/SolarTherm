within SolarTherm.Utilities;
package Weather

block WeatherTable "Weather data stored in table"
	extends Modelica.Blocks.Sources.CombiTimeTable;
end WeatherTable;

function weatherFileChecker "Check and possibly convert weather file"
	import Modelica.Utilities.System.command;
	input String fileName;
	output String newName;
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
end weatherFileChecker;

end Weather;
