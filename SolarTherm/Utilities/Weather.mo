within SolarTherm.Utilities;
package Weather

block WeatherTable "Weather data stored in table"
	extends Modelica.Blocks.Sources.CombiTimeTable;
end WeatherTable;

impure function checkVersion "Check if file is correct version"
	import Modelica.Utilities.Streams;
	import Modelica.Utilities.Strings;
	input String fileName;
	output Boolean pass;
protected
	// Change these as the format changes
	constant String metal = "#METALABELS,name,lat,lon,elev,tzone,tstart";
	constant String metau = "#METAUNITS,str,deg,deg,m,h,s";
	constant String tablel = "#TABLELABELS,time,ghi,dni,dry,dew,rhum,p,wdir,wspd";
	constant String tableu = "#TABLEUNITS,s,W/m2,W/m2,degC,degC,%,mbar,deg,m/s";
	constant Integer ncol = 9;
	String line;
	Integer nr;
	Integer nc;
	Integer i;
algorithm
	pass := (Streams.readLine(fileName, 1) == "#1")
			and (Streams.readLine(fileName, 3) == metal)
			and (Streams.readLine(fileName, 4) == metau)
			and (Streams.readLine(fileName, 5) == tablel)
			and (Streams.readLine(fileName, 6) == tableu)
			;
	if pass then
		// The scan functions assert that Integer is found
		line := Streams.readLine(fileName, 2);
		Streams.print(line, "outfile.txt");
		i := Strings.find(line, "(");
		(nr, i)  := Strings.scanInteger(line, i+1);
		i := Strings.find(line, ",");
		(nc, i)  := Strings.scanInteger(line, i+1);
		pass := (nc == ncol);
	end if;
	Streams.close(fileName);
end checkVersion;

impure function weatherFileChecker "Check and possibly convert weather file"
	import Modelica.Utilities.System.command;
	input String fileName;
	output String newName;
protected
	String dir;
	String name;
	String ext;
	Integer result;
algorithm
	// Should add parameter for whether or not to overwrite existing .motab file.
	if checkVersion(fileName) then
		newName := fileName;
	else
		result := command("st_wea_to_mo " + fileName);
		assert(result == 0, "Failed to convert weather file " + fileName);
		(dir, name, ext) := Modelica.Utilities.Files.splitPathName(fileName);
		newName := dir + name + ".motab";
		assert(checkVersion(newName), "Converted weather file version mismatch "
			+ newName);
	end if;
end weatherFileChecker;

end Weather;
