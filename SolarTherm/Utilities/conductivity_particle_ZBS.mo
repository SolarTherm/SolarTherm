within SolarTherm.Utilities;

function conductivity_particle_ZBS
import exp = Modelica.Math.exp;
import ln = Modelica.Math.log;
input Real T;
input Real d_p;
input Real phi_g;
input Real k_s;
input Real eps_r;
output Real k_particle;

protected
Real pi = Modelica.Constants.pi;
Real R = Modelica.Constants.R;
Real sigma = Modelica.Constants.sigma;

Real M_g = 28.97 "Molar Mass Air kg/kmol";
Real M_s = 101.96 "Solid molar mass in kg/kmol";
Real M_x = 1.4 * 101.96;
Real mu = M_g / M_s "Ratio of molar mass";
Real P = 101325 "Pressure in Pa";
Real B = 1.25 * ((1-phi_g)/phi_g)^(10/9);
Real T_0 = 273.15;
Modelica.Media.Air.DryAirNasa.ThermodynamicState state_air = Modelica.Media.Air.DryAirNasa.setState_pTX(101325,T);
Real k_f = Modelica.Media.Air.DryAirNasa.thermalConductivity(state_air);
Real cp_f = Modelica.Media.Air.DryAirNasa.specificHeatCapacityCp(state_air);
Real a_T = exp(-0.57*((T-T_0)/(T_0)))*(M_x/(6.8+M_x))+((2.4*mu)/(1+mu)^2)*(1-exp(-0.57*((T-T_0)/T_0)));
Real l = 2*((2-a_T)/a_T)*(2*pi*R*T/M_g)^(0.5)*(k_f/(P*(2*cp_f-R/M_g)));
Real kappa = k_s/k_f;
Real kappa_r = ((4*sigma)/((2/eps_r)-1))*T^3*(d_p/k_f);
Real kappa_G = (1+(1/d_p))^(-1);
Real N = (1/kappa_G)*(1+((kappa_r-B*kappa_G)/kappa))-B*((1/kappa_G)-1)*(1+(kappa_r/kappa));
Real k_c = (2/N)*(((B*(kappa+kappa_r-1))/(N^2*kappa_G*kappa))*ln((kappa+kappa_r)/(B*(kappa_G+(1-kappa_G)*(kappa+kappa_r))))+((B+1)/(2*B))*((kappa_r/kappa_G)-B*(1+((1-kappa_G)/kappa_G)*kappa_r))-((B-1)/(N*kappa_G)));

algorithm
k_particle := k_f * ((1-sqrt(1-phi_g))*phi_g*((phi_g-1+(1/kappa_G))^(-1)+kappa_r)+sqrt(1-phi_g)*(phi*kappa+(1-phi)*k_c));


end conductivity_particle_ZBS;