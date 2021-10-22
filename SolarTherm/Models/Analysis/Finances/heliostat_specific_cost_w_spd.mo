within SolarTherm.Models.Analysis.Finances;

/*This cost model of the heliostat is taking account the cut-off wind speed. The higher the wind speed, the more expensive it will be. The paper evaluates torque, bending and pressure stress within vital parts of heliostat. The wind speed's drag formula for different axes are taken from the wind-tunnel experiment by Sandia
Further reading :

Emes et al. ,Effect of heliostat design wind speed on the levelised cost ofelectricity from concentrating solar thermal power tower plants,Solar Energy 115 (2015) 441–451 ==> taken from the Fig 8. 

Using interpolation to get the price for windspeed value in between two nearest curves


Created by Philipe Gunawan*/

function heliostat_specific_cost_w_spd
import SI = Modelica.SIunits;
input SI.Velocity Wspd_max;
input SI.Area A_helio;
extends Modelica.Icons.Function;
output Real result;
algorithm
if Wspd_max <= 5 then

    result := (1.9673158680249e-21 * A_helio^12 - 2.71385693778118e-18 * A_helio^11 + 1.6478684883274e-15 * A_helio^10 - 5.80806864264151e-13*A_helio^9 + 1.31887004967549e-10 * A_helio^8 -2.024123896550007e-8 * A_helio^7 + 2.14216165471371e-6 * A_helio^6 - 0.0001566084 * A_helio^5 + 0.0078001615 * A_helio^4 - 0.2566716123 * A_helio^3 + 5.296521846 * A_helio^2 - 62.988840766 * A_helio+434.8007840978) * (Wspd_max/5);

elseif Wspd_max <= 10 and Wspd_max > 5 then

    result := (Wspd_max-5)/(10-5) * ((if A_helio <=40 then -3.3534503353194e-5*A_helio^5 + 0.0043752111*A_helio^4 - 0.2227805991*A_helio^3 + 5.5924158654*A_helio^2 - 71.2462096144*A_helio + 506.94950258 else 0.2258574336*A_helio + 91.0268184778)-(1.9673158680249e-21 * A_helio^12 - 2.71385693778118e-18 * A_helio^11 + 1.6478684883274e-15 * A_helio^10 - 5.80806864264151e-13*A_helio^9 + 1.31887004967549e-10 * A_helio^8 -2.024123896550007e-8 * A_helio^7 + 2.14216165471371e-6 * A_helio^6 - 0.0001566084 * A_helio^5 + 0.0078001615 * A_helio^4 - 0.2566716123 * A_helio^3 + 5.296521846 * A_helio^2 - 62.988840766 * A_helio+434.8007840978))+(1.9673158680249e-21 * A_helio^12 - 2.71385693778118e-18 * A_helio^11 + 1.6478684883274e-15 * A_helio^10 - 5.80806864264151e-13*A_helio^9 + 1.31887004967549e-10 * A_helio^8 -2.024123896550007e-8 * A_helio^7 + 2.14216165471371e-6 * A_helio^6 - 0.0001566084 * A_helio^5 + 0.0078001615 * A_helio^4 - 0.2566716123 * A_helio^3 + 5.296521846 * A_helio^2 - 62.988840766 * A_helio+434.8007840978);
              
elseif Wspd_max > 10 and Wspd_max <= 15 then
    result := (Wspd_max-10)/(15-10) * ((if A_helio <=30 then 0.0019450237*A_helio^4 - 0.1623414479*A_helio^3 + 5.0057300462*A_helio^2 - 69.0635914822*A_helio + 510.4317720648 else 0.5287265761*A_helio + 116.4963)-(if A_helio <=40 then -3.3534503353194e-5*A_helio^5 + 0.0043752111*A_helio^4 - 0.2227805991*A_helio^3 + 5.5924158654*A_helio^2 - 71.2462096144*A_helio + 506.94950258 else 0.2258574336*A_helio + 91.0268184778)) + (if A_helio <=40 then -3.3534503353194e-5*A_helio^5 + 0.0043752111*A_helio^4 - 0.2227805991*A_helio^3 + 5.5924158654*A_helio^2 - 71.2462096144*A_helio + 506.94950258 else 0.2258574336*A_helio + 91.0268184778);    

elseif Wspd_max > 15 and Wspd_max <= 20 then
    result := (Wspd_max-15)/(20-15) * ((if A_helio <=20 then -0.0838613929*A_helio^3 + 3.9291374014*A_helio^2 - 62.8388850818*A_helio + 529.0480 else 0.7465069322*A_helio+154.2203)-(if A_helio <=30 then 0.0019450237*A_helio^4 - 0.1623414479*A_helio^3 + 5.0057300462*A_helio^2 - 69.0635914822*A_helio + 510.4317720648 else 0.5287265761*A_helio + 116.4963))+(if A_helio <=30 then 0.0019450237*A_helio^4 - 0.1623414479*A_helio^3 + 5.0057300462*A_helio^2 - 69.0635914822*A_helio + 510.4317720648 else 0.5287265761*A_helio + 116.4963) ;    

elseif Wspd_max > 20 and Wspd_max <= 25 then
    result := (Wspd_max-20)/(25-20) * (( if A_helio <=16 then -0.0198705735*A_helio^4 + 0.7523490405*A_helio^3 - 8.7832071472*A_helio^2 + 20.1322730197*A_helio+ 362.242608 else 0.7833030119*A_helio+214.391)-(if A_helio <=20 then -0.0838613929*A_helio^3 + 3.9291374014*A_helio^2 - 62.8388850818*A_helio + 529.0480 else 0.7465069322*A_helio+154.2203)) + (if A_helio <=20 then -0.0838613929*A_helio^3 + 3.9291374014*A_helio^2 - 62.8388850818*A_helio + 529.0480 else 0.7465069322*A_helio+154.2203); 
              
elseif Wspd_max > 25 and Wspd_max <= 30 then
    result := (Wspd_max-25)/(30-25) * ((if A_helio <=14.5 then 1.3871936158*A_helio^2 - 37.3124210891*A_helio+ 508.645 else 2.1709296706*A_helio+214.9944)-(if A_helio <=16 then -0.0198705735*A_helio^4 + 0.7523490405*A_helio^3 - 8.7832071472*A_helio^2 + 20.1322730197*A_helio+ 362.242608 else 0.7833030119*A_helio+214.391))+(if A_helio <=16 then -0.0198705735*A_helio^4 + 0.7523490405*A_helio^3 - 8.7832071472*A_helio^2 + 20.1322730197*A_helio+ 362.242608 else 0.7833030119*A_helio+214.391); 

else
    result := if A_helio <=14.5 then 1.3871936158*A_helio^2 - 37.3124210891*A_helio+ 508.645 else 2.1709296706*A_helio+214.9944;

end if;


end heliostat_specific_cost_w_spd;