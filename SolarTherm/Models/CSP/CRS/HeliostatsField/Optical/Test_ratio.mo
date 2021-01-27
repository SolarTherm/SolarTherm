within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;

function Test_ratio
input Real ele;
output Real result;
Real dni_clear = 1000;
protected
algorithm
dni_clear:=1363*0.7^((1./cos((90.-ele)/180.*pi))^0.678);
result:=dni_clear;
end Test_ratio;