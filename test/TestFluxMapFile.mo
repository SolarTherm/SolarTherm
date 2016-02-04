block TestFluxMapFile
	import CN = Modelica.Constants;
	import SolarTherm.Optics.FluxMapFile;
	FluxMapFile fluxmap(nelem=2, R_des=1, fileName="resources/flux.motab");
initial equation
	fluxmap.alt = 0.0;
	fluxmap.azi = 0.0;
equation
	when time >= 1 then
		fluxmap.alt = 1*CN.pi/8;
		fluxmap.azi = 0.0;
	elsewhen time >= 2 then
		fluxmap.alt = 2*CN.pi/8;
		fluxmap.azi = 0.0;
	elsewhen time >= 3 then
		fluxmap.alt = 3*CN.pi/8;
		fluxmap.azi = 0.0;
	elsewhen time >= 4 then
		fluxmap.alt = 4*CN.pi/8;
		fluxmap.azi = 0.0;
	elsewhen time >= 5 then
		fluxmap.alt = 0.0;
		fluxmap.azi = CN.pi/8;
	elsewhen time >= 6 then
		fluxmap.alt = 2*CN.pi/8;
		fluxmap.azi = CN.pi/4;
	elsewhen time >= 7 then
		fluxmap.alt = CN.pi/8;
		fluxmap.azi = CN.pi/8;
	elsewhen time >= 8 then
		fluxmap.alt = 1.5*CN.pi/8;
		fluxmap.azi = -CN.pi/8;
	end when;
end TestFluxMapFile;
