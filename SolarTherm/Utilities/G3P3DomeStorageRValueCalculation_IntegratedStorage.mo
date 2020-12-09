within SolarTherm.Utilities;

function G3P3DomeStorageRValueCalculation_IntegratedStorage
import ln = Modelica.Math.log;
input Real Th_refractory,H_tower, D_tower_out, m_tot, D_outlet,t_storage;
input String which_part;
output Real R_out;

protected 
/*Heat transfer property*/
Real k_HD_refractory = 1.7	"W/(m*K)	Conductivity of HD Refractory Layer";
Real k_LD_refractory = 0.4	"W/(m*K)	Conductivity of LD Refractory Layer";
Real k_HRC = 1.1	 "W/(m*K)	Conductivity of Heat Resistant Concrete";
Real k_concrete = 1.1 "W/(m*K)	Conductivity of Concrete";
Real k_fiber = 1.28	"W/(m*K)	Conductivity of fiber modules";
Real k_air = 0.027 "W/(m*K)	Conductivity of air";

/*Some constants*/
Real pi = 3.1415926536;
Real L_air = 0.5 "Thickness of air layer[m]";
Real scaling_k_HD = 1.1 "Scaling factor of k_HD_refractory";
Real scaling_k_LD = 1.3 "Scaling factor of k_LD_refractory";
Real h_convection_ambient = 10 "Convection coefficienct of the ambient [W/m2.K]";

Real rho_particle = 2153 "kg/m^3";
Real tan_30 = sqrt(3)/3;
Real tan_313 = 0.6080095302; 

Real D_bin = D_tower_out - 2 * Th_refractory;
Real H_bin = 
((m_tot/rho_particle)-(tan_30*(D_bin-D_outlet)/2*pi/3*(D_bin^2/4+D_outlet^2/4+D_bin*D_outlet/2))-(pi/3*D_bin^2/4*tan_313*D_bin/2))/(pi*D_bin^2/4)+tan_313*D_bin/2+tan_30*(D_bin-D_outlet)/2;

Real A_internal_bin = pi*D_bin^2/4+2*pi*D_bin/2*H_bin;
Real Th_HRC = 
      3.2832285689461693e-001
      + 1.1518447137747705e-004 * A_internal_bin
      -1.4095189864825422e-008 * A_internal_bin^2
      + 1.1372113852466968e-012 * A_internal_bin^3;
      
Real tower_wall_hot_bin = if r_bin <= 8.4 then
                                 0.4064 * r_bin - 2.34696
                          else
                                 0.1306285714 * r_bin - 0.03048;
Real r_bin = D_bin/2;                                 
Real Th_roof = 0.134 "Thickness of the roof, constant value from J. Sment";
Real Th_HD = 1/6 * Th_refractory "Thickness of the High insulated refractory";
Real Th_LD = 5/6 * Th_refractory "Thickness of the low insulated refractory";


Real r_HD = r_bin + Th_HD;
Real r_LD = r_HD + Th_LD;
Real r_HRC = r_LD + Th_HRC;
Real r_concrete = max(0,1.83 - Th_HRC - tower_wall_hot_bin) "J. Sment from Sandia: Practical structural thickness is 6 feet (after insulation)";
Real r_tower_wall = r_concrete + tower_wall_hot_bin;

/*Cylindrical*/
Real R_HD_cy = ln(r_HD/r_bin)/(2*pi*H_bin*k_HD_refractory*scaling_k_HD);
Real R_LD_cy = ln(r_LD/r_HD)/(2*pi*H_bin*k_LD_refractory*scaling_k_LD);
Real R_HRC_cy = ln(r_HRC/r_LD)/(2*pi*H_bin*k_HRC*1);
Real R_construction_cy = ln(r_tower_wall/r_HRC)/(2*pi*H_bin*k_concrete*1);
Real R_cy = R_construction_cy + R_HD_cy + R_LD_cy + R_HRC_cy "[K/W]";

/*Roof*/
Real R_air_roof = L_air/k_air/(pi*r_bin^2);
Real R_mod = 0.3048/k_fiber/(pi*r_bin^2) "0.3048 is nutec modulus";
Real R_roof = R_air_roof + R_mod "[K/W]";
                                  
algorithm

if which_part == "cylinder" then 
    R_out := R_cy;
elseif which_part == "hemisphere" then
    R_out := R_roof;
else
    R_out := -1000 "Invalid";
end if;

end G3P3DomeStorageRValueCalculation_IntegratedStorage;