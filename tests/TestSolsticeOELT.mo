block TestSolsticeOELT
  import SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SolsticeOELT;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;

  parameter nSI.Angle_deg lat=34 "Latitude (+ve North)" annotation(Dialog(group="System location"));
  parameter nSI.Angle_deg hra=0 "the solar hour angle for testing" annotation(Dialog(group="sun position"));
  parameter nSI.Angle_deg dec=0 "the declination angle for testing" annotation(Dialog(group="sun position"));

  SolsticeOELT lookuptable(hra=hra, dec=dec, lat=lat, psave="Test_SolsticeOELT" );

  Real opt_eff;

equation
  opt_eff=lookuptable.nu;

end TestSolsticeOELT;

// vim: ts=2:sw=2:et 
