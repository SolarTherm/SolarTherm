block TestFluxMapFile
	import CN = Modelica.Constants;
	import SolarTherm.Optics.FluxMapFile;
	FluxMapFile fluxmap(nelem=2, R_des=1, fileName="resources/flux.motab");
initial equation
	fluxmap.alt = 0.0;
	fluxmap.azi = 0.0;
equation
	when time >= 1 then
		fluxmap.alt = 22.5;
		fluxmap.azi = 0.0;
	elsewhen time >= 2 then
		fluxmap.alt = 45;
		fluxmap.azi = 0.0;
	elsewhen time >= 3 then
		fluxmap.alt = 67.5;
		fluxmap.azi = 0.0;
	elsewhen time >= 4 then
		fluxmap.alt = 90;
		fluxmap.azi = 0.0;
	elsewhen time >= 5 then
		fluxmap.alt = 0.0;
		fluxmap.azi = 22.5;
	elsewhen time >= 6 then
		fluxmap.alt = 45;
		fluxmap.azi = 45;
	elsewhen time >= 7 then
		fluxmap.alt = 22.5;
		fluxmap.azi = 22.5;
	elsewhen time >= 8 then
		fluxmap.alt = 33.75;
		fluxmap.azi = -22.5;
	end when;
end TestFluxMapFile;
