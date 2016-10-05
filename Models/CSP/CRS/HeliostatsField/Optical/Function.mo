within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;
model Function "From function"
  extends OpticalEfficiency;

  replaceable function fun =
      SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Correlation.AliceSprings_N10M24
                                                                                                        constrainedby
    SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Correlation.opticalCorrelation
    annotation (choicesAllMatching=true);


equation
  nu=fun(hra,dec);
end Function;
