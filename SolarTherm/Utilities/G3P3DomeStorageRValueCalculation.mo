within SolarTherm.Utilities;

function G3P3DomeStorageRValueCalculation
import ln = Modelica.Math.log;

input Real Th_refractory;
input Real H_bin;
input Real D_bin;
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

/*Calculated intermediate variables*/
Real HD_refractory_thickness = 1/6 * Th_refractory "Fraction of Th_refractory that is high-insulation refractory";
Real LD_refractory_thickness = Th_refractory-HD_refractory_thickness "Fraction of Th_refractory that is low-insulation refractory";

SI.Area A_internal_bin = 2 * pi * D_bin ^ 2 / 4 + 2 * pi * D_bin / 2 * (H_bin - D_bin / 2) "Internal bin area";

Real H_cylinder = H_bin - D_bin/2 "Cylindrical height []m";

Real Th_dome = 1.5187478830852255e-001 + 2.0904371077436060e-004 * A_internal_bin - 3.9941189858652609e-008 * A_internal_bin ^ 2 + 3.4572388452249412e-012 * A_internal_bin ^ 3 "Structural thickness in m";

Real r_bin = D_bin / 2 "Bin inner surface radius m";

Real r_HD_refractory = r_bin + HD_refractory_thickness "Outer radius of the HD_refractory_thickness from the center of the bin [m]";
Real r_LD_refractory = r_HD_refractory + LD_refractory_thickness "Outer radius of the LD_refractory_thickness from the center of the bin shall there is no HD_refractory_thickness installed [m]";
Real r_HRC = r_LD_refractory + Th_dome * 0.67 "Outer radius of the high resistance concrete (HRC) [m]"; 
Real r_construction = r_HRC + Th_dome*(1-0.67) "Outer radius of the tower [m]";

/*Hemisphere R calculation*/
Real A_hemi = 2 * pi * r_construction^2 "Hemisphere surface area";
Real R_air_hemi = L_air/k_air/(pi*r_bin^2) "Thermal resistance of the air layer in K/W";
Real R_HD_hemi = ((1/r_bin)-(1/r_HD_refractory))/(4*pi*k_HD_refractory*scaling_k_HD) "Thermal resistance of the HD_refractory_thickness in K/W";
Real R_LD_hemi = ((1/r_HD_refractory)-(1/r_LD_refractory))/(4*pi*k_LD_refractory*scaling_k_LD) "Thermal resistance of the LD_refractory_thickness in K/W";
Real R_HRC_hemi = ((1/r_LD_refractory)-(1/r_HRC))/(4*pi*k_HRC*1) "Thermal resistance of the HRC in K/W";
Real R_construction_hemi = ((1/r_HRC)-(1/r_construction))/(4*pi*k_concrete*1) "Thermal resistance of the construction in K/W";
Real R_ambient_hemi = 1 / (h_convection_ambient * A_hemi);
Real R_total_hemi = R_air_hemi + R_HD_hemi + R_LD_hemi + R_HRC_hemi + R_construction_hemi + R_ambient_hemi;

/*Cylinder R calculation*/
Real A_cylinder = 2*pi*r_construction*H_cylinder "Cylinder surface area [m2]";
Real R_HD_cy = ln(r_HD_refractory/r_bin)/(2*pi*H_cylinder*k_HD_refractory*scaling_k_HD);
Real R_LD_cy = ln(r_LD_refractory/r_HD_refractory)/(2*pi*H_cylinder*k_LD_refractory*scaling_k_LD);
Real R_HRC_cy = ln(r_HRC/r_LD_refractory)/(2*pi*H_cylinder*k_HRC*1) "Thermal resistance of the HRC in K/W";
Real R_construction_cy = ln(r_construction/r_HRC)/(2*pi*H_cylinder*k_concrete*1) "Thermal resistance of the concrete in K/W";
Real R_ambient_cy = 1 / (h_convection_ambient * A_cylinder);
Real R_total_cy = R_HD_cy + R_LD_cy + R_HRC_cy + R_construction_cy + R_ambient_hemi;

algorithm

if which_part == "hemisphere" then
    R_out := R_total_hemi;
elseif which_part == "cylinder" then
    R_out := R_total_cy;
else
    R_out := -1000 "Invalid";
end if;


end G3P3DomeStorageRValueCalculation;