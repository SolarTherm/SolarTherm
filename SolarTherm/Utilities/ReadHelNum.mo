within SolarTherm.Utilities;
function ReadHelNum
	import Modelica.Utilities.Streams;
	import Modelica.Utilities.Strings;
	input Integer index;
	input String file;
	output Integer n_heliostat;
protected
	String line;
algorithm
	line := Streams.readLine(file, index);
	n_heliostat := Strings.scanInteger(line);
end ReadHelNum;
