within SolarTherm.Models.Sources.Solar;
partial block SolarPosition "Sun position"
 parameter nSI.Angle_deg lon "Longitude (+ve East)";
 parameter nSI.Angle_deg lat "Latitude (+ve North)";
 output nSI.Angle_deg alt "Altitude";
 output nSI.Angle_deg azi "Azimuth (Clockwise from North=0)";
 output nSI.Angle_deg elo "Ecliptic longitude (reduced to range [-90, 90])";
 output nSI.Angle_deg hra "Solar hour angle (solar noon at 0)";
end SolarPosition;
