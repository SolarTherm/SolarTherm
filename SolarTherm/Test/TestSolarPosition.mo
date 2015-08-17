within SolarTherm.Test;
block TestSolarPosition
	import SolarTherm.Utilities.Solar.SolarPositionDB;
	SolarPositionDB solp_0 (lat=0, lon=0, t_zone=0);
	//SolarPositionDB solp_0 (lat=0, lon=0, t_zone=0, t_start=3600*24*160);
	//SolarPositionDB solp_0 (lat=-45, lon=0, t_zone=0, t_start=0);
	//SolarPositionDB solp_0 (lat=-45, lon=0, t_zone=0, t_start=3600*24*160);
	//SolarPositionDB solp_0 (lat=45, lon=0, t_zone=0, t_start=0);
	//SolarPositionDB solp_0 (lat=45, lon=0, t_zone=0, t_start=3600*24*160);
	SolarPositionDB solp_can (lat=-35.3, lon=149.1, t_zone=10);
end TestSolarPosition;
