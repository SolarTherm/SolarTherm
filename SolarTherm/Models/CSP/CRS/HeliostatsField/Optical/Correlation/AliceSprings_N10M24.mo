within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Correlation;
function AliceSprings_N10M24
  extends
    SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.Correlation.opticalCorrelation;
protected
       SI.Angle elo=SolarTherm.Models.Sources.SolarFunctions.eclipticLongitude(dec);
       Real x=to_deg(hra);
       Real y=to_deg(elo);
       parameter Real p00 =       0.643;//  (0.6151, 0.6709)
       parameter Real p10 =  1.541e-018;//  (-0.0009344, 0.0009344)
       parameter Real p01 =   0.0001144;//  (-0.0007192, 0.0009479)
       parameter Real p20 =  2.384e-006;//  (-1.016e-005, 1.493e-005)
       parameter Real p11 = -3.064e-021;//  (-1.212e-005, 1.212e-005)
       parameter Real p02 =  8.857e-006;//  (-1.613e-005, 3.384e-005)
       parameter Real p30 =  -4.06e-022;//  (-3.402e-007, 3.402e-007)
       parameter Real p21 = -2.759e-007;//  (-5.718e-007, 2.005e-008)
       parameter Real p12 = -2.886e-022;//  (-4.709e-007, 4.709e-007)
       parameter Real p03 = -4.509e-008;//  (-2.179e-007, 1.277e-007)
       parameter Real p40 = -8.556e-009;//  (-1e-008, -7.111e-009)
       parameter Real p31 =  9.986e-025;//  (-1.327e-009, 1.327e-009)
       parameter Real p22 =  1.917e-009;//  (4.179e-010, 3.415e-009)
       parameter Real p13 =  6.562e-026;//  (-2.042e-009, 2.042e-009)
       parameter Real p04 = -2.624e-009;//  (-6.836e-009, 1.588e-009)
       parameter Real p50 =  1.021e-026;//  (-3.195e-011, 3.195e-011)
       parameter Real p41 = -2.813e-011;//  (-5.652e-011, 2.525e-013)
       parameter Real p32 =  1.492e-025;//  (-3.116e-011, 3.116e-011)
       parameter Real p23 =  3.392e-011;//  (-7.129e-012, 7.497e-011)
       parameter Real p14 = -7.117e-026;//  (-7.505e-011, 7.505e-011)

algorithm
  nu :=max(0,p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + p30*x^3 + p21*x^2*y +
    p12*x*y^2 + p03*y^3 + p40*x^4 + p31*x^3*y + p22*x^2*y^2 + p13*x*y^3 + p04*y^
    4 + p50*x^5 + p41*x^4*y + p32*x^3*y^2 + p23*x^2*y^3 + p14*x*y^4);

end AliceSprings_N10M24;
