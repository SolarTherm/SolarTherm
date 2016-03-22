block TestOptEffCatrom
	import CN = Modelica.Constants;
	SolarTherm.Collectors.OptEffCatrom oeff(
		fileName="resources/optics/AliceSprings_N10M24_ext.csv",
		n = 10,
		m = 24,
		sym = "E"
		);
	SolarTherm.Sources.Weather.WeatherSource wea(
		weaFile="resources/weather/AUS_NT.Alice.Springs.Airport.943260_RMY.motab"
		);
equation
	connect(wea.wbus, oeff.wbus);
end TestOptEffCatrom;

