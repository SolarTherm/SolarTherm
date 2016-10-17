within SolarTherm;
package Types
  extends Modelica.Icons.TypesPackage;













  type solar_angles = enumeration(
    elo_hra   "Ecliptic longitude - Solar hour angle",
    dec_hra   "Declination - Solar hour angle",
    ele_azi   "Elevation - Azimuth",
    zen_azi   "Zenith - azimuth")
    "Enumeration defining the solar angles";

end Types;
