within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;

function SWInterp

input Real nu_60;
input Real nu_80;
input Real nu_100;
input Real nu_120;
input Real ele;
input Real dni;

output Real result;
protected

Real cons1 = 0.6;
Real cons2 = 0.8;
Real cons3 = 1.0;
Real cons4 = 1.2;
Real x = 1;
Real dni_clear = 1;

algorithm
if ele > 0 then
    dni_clear:=1363*0.7^((1./cos(0.5*pi-ele))^0.678);
end if;    
x:=dni/dni_clear;

if x >= cons4 then
   result := nu_120;
elseif x >= cons3 and x<cons4 then
    result := nu_100+(x-cons3)/(cons4-cons3)*(nu_120-nu_100);
elseif x >= cons2 and x<cons3 then
    result := nu_80+(x-cons2)/(cons3-cons2)*(nu_100-nu_80);
elseif x >= cons1 and x<cons2 then
    result := nu_60+(x-cons1)/(cons2-cons1)*(nu_80-nu_60);
elseif x < cons1 then
    result := nu_60;
end if;


end SWInterp;