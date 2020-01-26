within SolarTherm.Models.Sources.Weather;
record Metadata "Metadata for weather file"
 String name "Station name";
 nSI.Angle_deg lat "Latitude";
 nSI.Angle_deg lon "Longitude";
 SI.Length elev "Elevation";
 nSI.Time_hour tzone "Time zone";
 SI.Time tstart "Local time difference between time=0 and start of year";
end Metadata;
