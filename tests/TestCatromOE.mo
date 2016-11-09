block TestCatromOE
	import CN = Modelica.Constants;
	import SolarTherm.Models.CSP.CRS.HeliostatsField.CatromOE;
	import Modelica.Utilities.Files.loadResource;
	CatromOE oeff(
		file=loadResource("resources/optics/AliceSprings_N10M24_ext.csv"),
		n = 10,
		m = 24,
		sym = "E"
		);
	SolarTherm.Models.Sources.Weather.WeatherSource wea(
		file=loadResource("resources/weather/AUS_NT.Alice.Springs.Airport.943260_RMY.motab")
		);
equation
	connect(wea.wbus, oeff.wbus);
end TestCatromOE;
