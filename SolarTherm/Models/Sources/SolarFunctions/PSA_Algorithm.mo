within SolarTherm.Models.Sources.SolarFunctions;
function PSA_Algorithm "Sun position using Blanco et al."
  extends SolarTherm.Models.Sources.SolarFunctions.solarPosition;
protected
  Real longitude=lon;
  Real latitude=lat;
  Real julianday=julianDay(year,
    1,1,(t/3600) - t_zone_int);
  Real declination;
  Real hourangle;
  Real zenithangle;
  Real azimuth;

  constant Real twopi = 2 * Modelica.Constants.pi;
  constant Real rad = Modelica.Constants.pi / 180;
  constant Real earthmeanradius = 6371.01;
  constant Real astronomicalunit = 149597890;
  Real elapsedjuliandays;
  Real aux;
  Real eclipticlongitude;
  Real eclipticobliquity;
  Real sineclipticlongitude;
  Real y;
  Real x;
  Real rightascension;
  Real greenwichmeansiderealtime;
  Real localmeansiderealtime;
  Real latitudeinradians;
  Real coslatitude;
  Real sinlatitude;
  Real coshourangle;
  Real parallax;
  Integer intaux;
algorithm
  elapsedjuliandays := julianday - 2451545.0;
  aux := 0.0172021241615 * elapsedjuliandays;
  eclipticlongitude := 4.894969024 + 0.017202791697 * elapsedjuliandays + 5.78262765229295e-09 * elapsedjuliandays * cos(2.67824 + aux) + 0.03341656 * cos(4.6693 + aux) + 0.00034894 * cos(4.6261 + 0.03440424832 * elapsedjuliandays) - 8.339e-05 * sin(2.1824 - 0.00092421755 * elapsedjuliandays) + 3.934e-05 * cos(2.7441 + 0.01575190938 * elapsedjuliandays) + 3.461e-05 * cos(2.8289 + 9.64572211e-06 * elapsedjuliandays) + 3.136e-05 * cos(3.6277 + 0.21276871047 * elapsedjuliandays) + 2.676e-05 * cos(4.4181 + 0.02152065544 * elapsedjuliandays) + 3.046e-05 * cos(6.1352 + 0.01076032772 * elapsedjuliandays);
  eclipticobliquity := 0.409092804039597 - 6.21395528282155e-09 * elapsedjuliandays + 4.4596737135516e-05 * cos(2.18295428698789 - 0.000924169576470094 * elapsedjuliandays) - 2.78266331083708e-06 * cos(87.6012025405766 - 0.0344055570784386 * elapsedjuliandays) + 1.04358121667584e-07 * cos(167.419645046537 - 0.0698787501985692 * elapsedjuliandays);
  sineclipticlongitude := sin(eclipticlongitude);
  y := cos(eclipticobliquity) * sineclipticlongitude;
  x := cos(eclipticlongitude);
  rightascension := Modelica.Math.atan2(y, x);
  if rightascension < 0.0 then
    rightascension := rightascension + twopi;
  end if;
  declination := Modelica.Math.asin(sin(eclipticobliquity) * sineclipticlongitude);
  greenwichmeansiderealtime := (-60053.302628) + 24.065709825 * elapsedjuliandays - 0.000292222 * sin(0.0009242 * elapsedjuliandays + 0.9574);
  localmeansiderealtime := (greenwichmeansiderealtime * 15 + longitude) * rad;
  hourangle := localmeansiderealtime - rightascension;
  latitudeinradians := latitude * rad;
  coslatitude := cos(latitudeinradians);
  sinlatitude := sin(latitudeinradians);
  coshourangle := cos(hourangle);
  zenithangle := Modelica.Math.acos(coslatitude * coshourangle * cos(declination) + sin(declination) * sinlatitude);
  y := -sin(hourangle);
  x := tan(declination) * coslatitude - sinlatitude * coshourangle;
  azimuth := Modelica.Math.atan2(y, x);
  if azimuth < 0.0 then
    azimuth := azimuth + twopi;
  end if;
  parallax := earthmeanradius / astronomicalunit * sin(zenithangle);
  zenithangle := zenithangle + parallax;
//   aux := hourangle / twopi;
//   intaux := integer(aux);
//   hourangle := hourangle - intaux * twopi;
   hourangle := mod(hourangle+pi,twopi)-pi;
  dec:=declination;
  hra:=hourangle;

  annotation(Diagram(coordinateSystem(extent = {{-148.5, -105}, {148.5, 105}}, preserveAspectRatio = true, initialScale = 0.1, grid = {5, 5})));
end PSA_Algorithm;
