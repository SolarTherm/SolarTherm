within SolarTherm.Utilities;

function G3P3StorageCostFunction_Integrated
input Real Th_refractory,H_tower, D_tower_inner, m_tot, D_outlet,phi;
input Real c[:];

output Real C_total_bin;

protected
Real c_HRC = c[1] "Specific cost of high resistance concrete [USD/m^3]";
Real c_portland = c[2] "Specific cost of portland concrete [USD/m^3]";
Real c_RF = c[3] "Specific cost of refractory [USD/m^3]";
Real c_filler_floor = c[4] "Specific cost of floor filler material [USD/m^3]";
Real c_particle = c[5] "Cost to hold particle mass [USD/kg]";
Real c_roof = c[6];

Real rho_particle = 2153 "kg/m^3";
Real tan_30 = sqrt(3)/3;
Real tan_313 = 0.6080095302; 
Real pi = 3.1415926536;

Real D_bin = D_tower_inner - 2 * Th_refractory;
Real V_bin = m_tot / rho_particle / phi;
Real H_bin = 
(
  V_bin -
  pi/3 * tan_30 * (D_bin-D_outlet)/2 * (D_bin^2/4+D_outlet^2/4+(D_bin*D_outlet)/4)
  - (pi /3 * D_bin^2/4 * tan_313 * D_bin/2)
  ) / (0.25 * pi * D_bin^2) + D_bin/2 * tan_313 + tan_30 * (D_bin-D_outlet)/2;

Real A_internal_bin = pi*D_bin^2/4+2*pi*D_bin/2*H_bin "Cylindrical part only why?Why using the H_bin not H_cylindrical";

Real V_refractory_tower = 
pi*(H_bin)*((D_bin/2+Th_refractory)^2-(D_bin/2)^2);

Real V_refractory_roof = 
pi*(D_bin+Th_refractory)^2/4*Th_refractory;

Real C_refractory = 
V_refractory_roof*c_roof + V_refractory_tower*c_RF;

Real Th_HRC = 
      3.2832285689461693e-001
      + 1.1518447137747705e-004 * A_internal_bin
      -1.4095189864825422e-008 * A_internal_bin^2
      + 1.1372113852466968e-012 * A_internal_bin^3;

Real V_HRC = 
pi*(H_bin-tan_313*D_bin/2)*((D_bin/2+Th_refractory+Th_HRC)^2-(D_bin/2+Th_refractory)^2);

Real C_HRC = V_HRC*0.67*c_HRC;

Real V_floor = 
pi/3*tan_30*(2*(D_bin/2)^3-3*(D_outlet/2)*(D_bin/2)^2+(D_outlet/2)^3);

Real C_floor = V_floor*0.9*c_filler_floor+V_floor*0.1*rho_particle*c_particle;

Real C_bins = 1 * (C_HRC+C_refractory+C_floor);

algorithm
C_total_bin := C_bins;

end G3P3StorageCostFunction_Integrated;
