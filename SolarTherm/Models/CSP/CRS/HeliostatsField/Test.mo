within SolarTherm.Models.CSP.CRS.HeliostatsField;

model Test

Real res;
equation

res = SolarTherm.Models.CSP.CRS.HeliostatsField.Optical.SWInterp(1,2,3,4,5,0.68);

end Test;