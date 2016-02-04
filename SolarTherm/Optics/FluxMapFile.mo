within SolarTherm.Optics;
block FluxMapFile "Read in flux maps from file"
	extends SolarTherm.Optics.FluxMap;
	import SI = Modelica.SIunits;
	parameter String fileName "Flux table normalised to design output";
	parameter SI.RadiantPower R_des "Radiant power from field at 1 sun and 1 flux from file";

	parameter String tableNames[nelem] = {"flux" + String(i) for i in 1:nelem};
	Modelica.Blocks.Tables.CombiTable2D table[nelem](
		each verboseRead=false,
		each tableOnFile=true,
		each fileName=fileName,
		each smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		//each extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
		// Could also try Periodic table extrapolation
		// Painful: CombiTimeTable has extrapolation but not CombiTable1D or CombiTable2D
		tableName=tableNames
		);
equation
	for i in 1:nelem loop
		connect(alt, table[i].u1);
		connect(azi, table[i].u2);
		flux[i] = R_des*table[i].y;
	end for;
end FluxMapFile;
