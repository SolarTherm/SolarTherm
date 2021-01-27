within SolarTherm.Models.CSP.CRS.HeliostatsField.Optical;

function SWInterp

input Real nu_70;
input Real nu_80;
input Real nu_90;
input Real nu_100;
input Real nu_110;
//input Real nu_120;
input Real ele;
input Real dni;

output Real result;
protected

Real cons1 = 0.7;
Real cons2 = 0.8;
Real cons3 = 0.9;
Real cons4 = 1.0;
Real cons5 = 1.1;
//Real cons6 = 1.2;
Real x = 1;
Real dni_clear = 1;

algorithm
if ele > 0 then
    dni_clear:=1363*0.7^((1./cos(0.5*pi-ele))^0.678);
end if;    
x:=dni/dni_clear;

if x >= cons5 then
   result := nu_110;
//elseif x >= cons5 and x<cons6 then
//    result := nu_110+(x-cons5)/(cons6-cons5)*(nu_120-nu_110);
elseif x >= cons4 and x<cons5 then
    result := nu_100+(x-cons4)/(cons5-cons4)*(nu_110-nu_100);
elseif x >= cons3 and x<cons4 then
    result := nu_90+(x-cons3)/(cons4-cons3)*(nu_100-nu_90);
elseif x >= cons2 and x<cons3 then
    result := nu_80+(x-cons2)/(cons3-cons2)*(nu_90-nu_80);
elseif x >= cons1 and x<cons2 then
    result := nu_70+(x-cons1)/(cons2-cons1)*(nu_80-nu_70);
elseif x < cons1 then
    result := nu_70;
end if;


end SWInterp;