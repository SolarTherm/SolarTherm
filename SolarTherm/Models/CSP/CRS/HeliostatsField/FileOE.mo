// file created by Paul Scott, used initially as part of GenericSystem model
within SolarTherm.Models.CSP.CRS.HeliostatsField;
block FileOE "Read in optical efficiency from file"
	extends SolarTherm.Models.CSP.CRS.HeliostatsField.OptEff;
	// Expects data in file to be oriented north (i.e. as for system in Southern
	// hemisphere).  When running simulations in the Northern hemisphere, the
	// the field can be turned around be setting orient_north = false.
	import SI = Modelica.SIunits;
	parameter String file "Optical efficiency table (relative to aperture area)";
	parameter Boolean orient_north = true "Orient system toward north else south";

	parameter String tableNames[nelem] = {"eff" + String(i) for i in 1:nelem};
	Modelica.Blocks.Tables.CombiTable2D table[nelem](
		each verboseRead=false,
		each tableOnFile=true,
		each fileName=file,
		each smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		tableName=tableNames);
	//each extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
	// Could also try Periodic table extrapolation
	// Painful: CombiTimeTable has extrapolation but not CombiTable1D or CombiTable2D
equation
	for i in 1:nelem loop
		table[i].u1 = max(wbus.alt, 0); // Needed because of interpolation below horizon

		if orient_north then
			table[i].u2 = wbus.azi;
		else
			table[i].u2 = mod(wbus.azi + 180.0, 360.);
		end if;
		eff[i] = table[i].y;
	end for;
end FileOE;
