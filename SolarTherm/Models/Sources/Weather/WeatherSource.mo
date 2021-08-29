within SolarTherm.Models.Sources.Weather;
block WeatherSource
  "Weather source including tabular data and other calculators"
 import SolarTherm.Models.Sources.Solar.SolarPositionDB;
 parameter String file "File containing TMY data";
 parameter nSI.Angle_deg lat = meta.lat "Latitude";
 parameter nSI.Angle_deg lon = meta.lon "Longitude";
 parameter Boolean orient_north = if lat < 0 then true else false "Orient system toward north else south";
 // Delay could be added to metadata.
 // By default we assume no delay as it appears to depend on the weather file
 // whether or not it lines up better.
 parameter SI.Time delay[8] = {0,0,0,0,0,0,0,0} "Time delay of table columns";
  output SolarTherm.Interfaces.Connectors.WeatherBus wbus;
protected
 parameter String file_act = weatherFileChecker(file);
 parameter Metadata meta = getMetadata(file_act);
 WeatherTable wtab(
  each tableOnFile=true,
  each fileName=file_act,
  each tableName="weather",
  each smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
  each columns=2:9,
  delay=delay);
 SolarTherm.Models.Sources.Date.SimpleDate date(toyoffset=meta.tstart);
 SolarPositionDB spos(lon=lon, lat=lat, tzone=meta.tzone);
 SI.Irradiance dni_l;
 SI.Irradiance ghi_l;
 SI.Velocity wspd_l;
 SI.Temperature Tdry_K;
 SI.Temperature Tdew_K;
equation
 connect(date.t, spos.t);

 // In order for connections to expandable connector to work outside here,
 // the values needed to be connected here (so they are registered)
 connect(date.t, wbus.t);
 connect(date.tod, wbus.tod);
 connect(date.dow, wbus.dow);
 connect(date.moy, wbus.moy);

 connect(spos.alt, wbus.alt);
 connect(spos.azi, wbus.azi);
 connect(spos.elo, wbus.elo);
 connect(spos.hra, wbus.hra);
 connect(spos.dec, wbus.dec);
 connect(spos.zen, wbus.zen);
 //connect(wbus.ghi, wtab.y[1]);
 //ghi_l = noEvent(if wtab.y[1] > 0 then wtab.y[1] else 0);
 //ghi_l = if noEvent(wtab.y[1] > 0) then wtab.y[1] else 0;
 //ghi_l = if wtab.y[1] >= 0 then wtab.y[1] else 0;
 ghi_l = max(wtab.y[1], 0);
 connect(ghi_l, wbus.ghi);
 //connect(wbus.dni, wtab.y[2]); // must be used
 // For some reason need to connect because otherwise these constraints
 // don't show up...
 //wbus.dni = if wtab.y[2] < 0 then 0 else wtab.y[2]; // under-determined
 //wbus.dni = wtab.y[2]; // under-determined
 //wbus.dni = 5.0;
 //dni_l = noEvent(if wtab.y[2] > 0 then wtab.y[2] else 0); // diff result
 //dni_l = if noEvent(wtab.y[2] > 0) then wtab.y[2] else 0; // diff result

 //dni_l = if wtab.y[2] >= 0 then wtab.y[2] else 0; // diff result
 dni_l = max(wtab.y[2], 0);
 connect(dni_l, wbus.dni);
 Tdry_K = from_degC(wtab.y[3]);
 connect(Tdry_K, wbus.Tdry);
 Tdew_K = from_degC(wtab.y[4]);
 connect(Tdew_K, wbus.Tdew);
 connect(wtab.y[7], wbus.wdir);
 //connect(wbus.wspd, wtab.y[8]);
 //wspd_l = noEvent(if wtab.y[8] > 0 then wtab.y[8] else 0);
 //wspd_l = if noEvent(wtab.y[8] > 0) then wtab.y[8] else 0;
 //wspd_l = if wtab.y[8] >= 0 then wtab.y[8] else 0;
 wspd_l = max(wtab.y[8], 0);
 connect(wspd_l, wbus.wspd);
end WeatherSource;

