block TestOptEffFile
	import CN = Modelica.Constants;
	import SolarTherm.Optics.OptEffFile;
	OptEffFile oeff(nelem=2, fileName="resources/opt_eff.motab");
initial equation
	oeff.alt = 0.0;
	oeff.azi = 0.0;
equation
	when time >= 1 then
		oeff.alt = 22.5;
		oeff.azi = 0.0;
	elsewhen time >= 2 then
		oeff.alt = 45;
		oeff.azi = 0.0;
	elsewhen time >= 3 then
		oeff.alt = 67.5;
		oeff.azi = 0.0;
	elsewhen time >= 4 then
		oeff.alt = 90;
		oeff.azi = 0.0;
	elsewhen time >= 5 then
		oeff.alt = 0.0;
		oeff.azi = 22.5;
	elsewhen time >= 6 then
		oeff.alt = 45;
		oeff.azi = 45;
	elsewhen time >= 7 then
		oeff.alt = 22.5;
		oeff.azi = 22.5;
	elsewhen time >= 8 then
		oeff.alt = 33.75;
		oeff.azi = -22.5;
	end when;
end TestOptEffFile;
