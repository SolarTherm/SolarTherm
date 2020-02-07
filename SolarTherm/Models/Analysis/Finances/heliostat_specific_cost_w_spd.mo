within SolarTherm.Models.Analysis.Finances;

/*This cost model of the heliostat is taking account the cut-off wind speed. The higher the wind speed, the more expensive it will be. The paper evaluates torque, bending and pressure stress within vital parts of heliostat. The wind speed's drag formula for different axes are taken from the wind-tunnel experiment by Sandia
Further reading :

Emes et al. ,Effect of heliostat design wind speed on the levelised cost ofelectricity from concentrating solar thermal power tower plants,Solar Energy 115 (2015) 441–451 ==> taken from the Fig 8. 


Created by Philipe Gunawan*/

function heliostat_specific_cost_w_spd
import SI = Modelica.SIunits;
input SI.Velocity Wspd_max;
input SI.Area A_helio;
output Real result;
algorithm
if Wspd_max <= 5 then

    result := (Wspd_max-0)/(5) * (-1.87603e-11*A_helio^7 + 1.24940959e-8*A_helio^6 - 3.37174e-6*A_helio^5 + 4.731e-4*A_helio^4
              -3.683e-2*A_helio^3 + 1.5730*A_helio^2 - 3.404269*A_helio + 375.9368);

elseif Wspd_max <= 10 and Wspd_max > 5 then

    result := (Wspd_max-5)/(10-5) * ((-1.4099-10*A_helio^7 + 7.027677e-8*A_helio^6 - 1.41655e-5*A_helio^5 + 1.4858e-3*A_helio^4
              -8.700704e-2*A_helio^3 + 2.8372217*A_helio^2 - 48.05276*A_helio + 441.7753) - (-1.87603e-11*A_helio^7 + 1.24940959e-8*A_helio^6 - 3.37174e-6*A_helio^5 + 4.731e-4*A_helio^4
              -3.683e-2*A_helio^3 + 1.5730*A_helio^2 - 3.404269*A_helio + 375.9368)) + (-1.87603e-11*A_helio^7 + 1.24940959e-8*A_helio^6 - 3.37174e-6*A_helio^5 + 4.731e-4*A_helio^4
              -3.683e-2*A_helio^3 + 1.5730*A_helio^2 - 3.404269*A_helio + 375.9368) ;
              
elseif Wspd_max > 10 and Wspd_max <= 15 then
    result := (Wspd_max-10)/(15-10) * ((-1.10620579e-10*A_helio^7 + 5.5475014e-8*A_helio^6 - 1.138933e-5*A_helio^5 + 1.23243e-3*A_helio^4
              -7.53580582e-2*A_helio^3 + 2.58902*A_helio^2 - 45.8817*A_helio + 460.042) - (-1.4099-10*A_helio^7 + 7.027677e-8*A_helio^6 - 1.41655e-5*A_helio^5 + 1.4858e-3*A_helio^4
              -8.700704e-2*A_helio^3 + 2.8372217*A_helio^2 - 48.05276*A_helio + 441.7753)) + (-1.4099-10*A_helio^7 + 7.027677e-8*A_helio^6 - 1.41655e-5*A_helio^5 + 1.4858e-3*A_helio^4
              -8.700704e-2*A_helio^3 + 2.8372217*A_helio^2 - 48.05276*A_helio + 441.7753) ;    

elseif Wspd_max > 15 and Wspd_max <= 20 then
    result := (Wspd_max-15)/(20-15) * ((-6.0638386e-11*A_helio^7 + 3.35073934e-8*A_helio^6 - 7.55592e-6*A_helio^5 + 8.94321947e-4*A_helio^4
              -5.9483722e-2*A_helio^3 + 2.20508*A_helio^2 - 41.0255832*A_helio + 462.308)-(-1.10620579e-10*A_helio^7 + 5.5475014e-8*A_helio^6 - 1.138933e-5*A_helio^5 + 1.23243e-3*A_helio^4
              -7.53580582e-2*A_helio^3 + 2.58902*A_helio^2 - 45.8817*A_helio + 460.042)) + (-1.10620579e-10*A_helio^7 + 5.5475014e-8*A_helio^6 - 1.138933e-5*A_helio^5 + 1.23243e-3*A_helio^4
              -7.53580582e-2*A_helio^3 + 2.58902*A_helio^2 - 45.8817*A_helio + 460.042) ;    

elseif Wspd_max > 20 and Wspd_max <= 25 then
    result := (Wspd_max-20)/(25-20) * ((-2.27387524e-11*A_helio^7 + 1.4582958e-8*A_helio^6 - 3.81104805e-6*A_helio^5 + 5.21539017e-4*A_helio^4
              -3.994593602e-2*A_helio^3 + 1.69136295*A_helio^2 - 34.57246*A_helio + 470.4528)-(-6.0638386e-11*A_helio^7 + 3.35073934e-8*A_helio^6 - 7.55592e-6*A_helio^5 + 8.94321947e-4*A_helio^4
              -5.9483722e-2*A_helio^3 + 2.20508*A_helio^2 - 41.0255832*A_helio + 462.308)) + (-6.0638386e-11*A_helio^7 + 3.35073934e-8*A_helio^6 - 7.55592e-6*A_helio^5 + 8.94321947e-4*A_helio^4
              -5.9483722e-2*A_helio^3 + 2.20508*A_helio^2 - 41.0255832*A_helio + 462.308) ; 
              
elseif Wspd_max > 25 and Wspd_max <= 30 then
    result := (Wspd_max-25)/(30-25) * ((-6.1639e-12*A_helio^7 + 4.79077e-9*A_helio^6 - 1.5120e-6*A_helio^5 + 2.4875e-4*A_helio^4
              -2.2756e-2*A_helio^3 + 1.1376542*A_helio^2 - 25.77*A_helio + 464.3)-(-2.27387524e-11*A_helio^7 + 1.4582958e-8*A_helio^6 - 3.81104805e-6*A_helio^5 + 5.21539017e-4*A_helio^4
              -3.994593602e-2*A_helio^3 + 1.69136295*A_helio^2 - 34.57246*A_helio + 470.4528)) + (-2.27387524e-11*A_helio^7 + 1.4582958e-8*A_helio^6 - 3.81104805e-6*A_helio^5 + 5.21539017e-4*A_helio^4
              -3.994593602e-2*A_helio^3 + 1.69136295*A_helio^2 - 34.57246*A_helio + 470.4528); 

else
    result := (Wspd_max-25)/(30-25) * ((-6.1639e-12*A_helio^7 + 4.79077e-9*A_helio^6 - 1.5120e-6*A_helio^5 + 2.4875e-4*A_helio^4
              -2.2756e-2*A_helio^3 + 1.1376542*A_helio^2 - 25.77*A_helio + 464.3)-(-2.27387524e-11*A_helio^7 + 1.4582958e-8*A_helio^6 - 3.81104805e-6*A_helio^5 + 5.21539017e-4*A_helio^4
              -3.994593602e-2*A_helio^3 + 1.69136295*A_helio^2 - 34.57246*A_helio + 470.4528)) + (-6.1639e-12*A_helio^7 + 4.79077e-9*A_helio^6 - 1.5120e-6*A_helio^5 + 2.4875e-4*A_helio^4
              -2.2756e-2*A_helio^3 + 1.1376542*A_helio^2 - 25.77*A_helio + 464.3) ;

end if;


end heliostat_specific_cost_w_spd;