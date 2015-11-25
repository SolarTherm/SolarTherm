within SolarTherm.Optics;
block FluxMapFile "Read in flux maps from file"
	extends SolarTherm.Optics.FluxMap;
	import SI = Modelica.SIunits;
	parameter String fileName;

	parameter String tableNames[nelem] = {"flux" + String(i) for i in 1:nelem};
	Modelica.Blocks.Tables.CombiTable2D table[nelem](
		each verboseRead=false,
		each tableOnFile=true,
		each fileName=fileName,
		each smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		tableName=tableNames
		);
equation
	for i in 1:nelem loop
		connect(alt, table[i].u1);
		connect(azi, table[i].u2);
		connect(table[i].y, flux[i]);
	end for;
end FluxMapFile;
