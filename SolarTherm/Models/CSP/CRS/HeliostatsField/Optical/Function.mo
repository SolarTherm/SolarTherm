within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
model Function "From function"
  extends OpticalEfficiency;

  replaceable function fun =
      SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Correlation.AliceSprings_N10M24
                                                                                                        constrainedby
    SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Correlation.opticalCorrelation
    annotation (choicesAllMatching=true);
  SI.Angle elo;

equation
  elo=SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(dec);
  nu=fun(hra,elo);
end Function;
