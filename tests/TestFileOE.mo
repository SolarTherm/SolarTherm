block TestFileOE
	import CN = Modelica.Constants;
	import SolarTherm.Models.CSP.CRS.HeliostatsField.FileOE;
	FileOE oeff(nelem=2, file="../resources/tests/opt_eff.motab");
initial equation
	oeff.wbus.alt = 0.0;
	oeff.wbus.azi = 0.0;
equation
	when time >= 1 then
		oeff.wbus.alt = 22.5;
		oeff.wbus.azi = 0.0;
	elsewhen time >= 2 then
		oeff.wbus.alt = 45;
		oeff.wbus.azi = 0.0;
	elsewhen time >= 3 then
		oeff.wbus.alt = 67.5;
		oeff.wbus.azi = 0.0;
	elsewhen time >= 4 then
		oeff.wbus.alt = 90;
		oeff.wbus.azi = 0.0;
	elsewhen time >= 5 then
		oeff.wbus.alt = 0.0;
		oeff.wbus.azi = 22.5;
	elsewhen time >= 6 then
		oeff.wbus.alt = 45;
		oeff.wbus.azi = 45;
	elsewhen time >= 7 then
		oeff.wbus.alt = 22.5;
		oeff.wbus.azi = 22.5;
	elsewhen time >= 8 then
		oeff.wbus.alt = 33.75;
		oeff.wbus.azi = -22.5;
	end when;
	//annotation(experiment(StartTime=0.0, StopTime=10.0, Interval=0.1, Tolerance=1e-06));
end TestFileOE;
