within SolarTherm.Utilities;

function nu_plug
input Real inv_Gz;
output Real nu_plug_calculated;


protected
Real nu_plug_H = ((2*0.886/sqrt(inv_Gz))^(12/5) + 12 ^ (12/5)) ^ (5/12);
Real nu_plug_T = ((1.128 / sqrt(inv_Gz))^(5/2) + (9.87)^(5/2))^(2/5);

algorithm

nu_plug_calculated := (nu_plug_H+nu_plug_T)/2;

end nu_plug;