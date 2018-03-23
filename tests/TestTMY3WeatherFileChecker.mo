model TestTMY3WeatherFileChecker

	import Modelica.Utilities.Streams;
	import Modelica.Utilities.Strings;

	parameter String wea_file_TMY3 = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/USA_CA_Los_Angeles_Intl_Arpt_722950_TMY3.CSV")"Absolute path to the weather file with tmy3 extension";
	parameter String file_motab = SolarTherm.Models.Sources.Weather.weatherFileChecker(file=wea_file_TMY3) "Absolute path to the converted weather file with motab extention";

	parameter Integer file_ln = Streams.countLines(file_motab) "Number of lines in the motab file";
	parameter Integer ln_test[4] = {8,4007,8007,file_ln} "Indexes of lines to be tested";
	String line_str[size(ln_test,1)] "String version of the selected lines from the motab file";
	parameter Integer sz_line = 9 "Number of real elements in each line";

	Integer j "Search index";
	Real l_real[size(ln_test,1),sz_line] "Real values corresponding to each element for the tested lines";
	Real l1[sz_line] "Real values corresponding to each element in the first test line";
	Real l2[sz_line] "Real values corresponding to each element in the second test line";
	Real l3[sz_line] "Real values corresponding to each element in the third test line";
	Real l4[sz_line]"Real values corresponding to each element in the fourth test line";

algorithm

	for i in 1:size(ln_test,1) loop
		line_str[i] := Streams.readLine(file_motab, ln_test[i]);
	end for;

	//print(line_str[1]);
	//print(line_str[2]);

	for k in 1:size(ln_test,1) loop
		(l_real[k,1], j) := Strings.scanReal(line_str[k]);
		for i in 2:sz_line loop
			(l_real[k,i], j) := Strings.scanReal(line_str[k], j+1);
		end for;
	end for;

	l1 := l_real[1,:];
	l2 :=l_real[2,:];
	l3 :=l_real[3,:];
	l4 :=l_real[4,:];
	annotation(experiment(StartTime=0.0, StopTime=1.0, Interval=0.1, Tolerance=1e-06));
end TestTMY3WeatherFileChecker;
