within SolarTherm.Utilities;
function FlowpathFlux
	extends Modelica.Icons.Function;
	import Modelica.Utilities.Streams;
	import Modelica.Utilities.Strings;
	input String file;
	input Integer N;
	input Integer fpath;
	output Real[N,fpath] real;
	protected
		String line;
		Integer i;
		Integer j;
		Integer k;
	algorithm
	for i in 1:N loop
		line := Streams.readLine(file, i);
		k := 0;
		for j in 1:fpath loop
			(real[i,j], k) := Strings.scanReal(line, k+1);
		end for;
	end for;
	Streams.close(file);
end FlowpathFlux;