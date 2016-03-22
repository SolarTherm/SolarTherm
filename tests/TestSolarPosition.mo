block TestSolarPosition
	import SolarTherm.Sources.Solar.SolarPositionDB;
	SolarPositionDB solp_0(lat=0, lon=0, tzone=0);
	SolarPositionDB solp_can(lat=-35.3, lon=149.1, tzone=10);
	SolarPositionDB solp_den(lat=39.74, lon=-104.99, tzone=-7);
	SolarPositionDB solp_dag(lat=34.85, lon=-116.8, tzone=-8);
equation
	solp_0.t = time;
	solp_can.t = time;
	solp_den.t = time;
	solp_dag.t = time;
end TestSolarPosition;
