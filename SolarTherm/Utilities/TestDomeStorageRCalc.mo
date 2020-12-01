within SolarTherm.Utilities;

model TestDomeStorageRCalc
import ln = Modelica.Math.log;

parameter Real Th_refractory = 0.6;
parameter Real H_bin = 13.923;
parameter Real D_bin = 11.9;

parameter Real H_tower = 184;
parameter Real D_tower_out = 15;
parameter Real m_tot = 2173038;
parameter Real D_outlet = 0.21;
parameter Real t_storage = 6;


Real R_external_cylinder;
Real R_external_hemisphere;

Real R_integrated_cylinder;
Real R_integrated_hemisphere;

equation

R_external_cylinder = SolarTherm.Utilities.G3P3DomeStorageRValueCalculation(Th_refractory,H_bin,D_bin,"cylinder");
R_external_hemisphere = SolarTherm.Utilities.G3P3DomeStorageRValueCalculation(Th_refractory,H_bin,D_bin,"hemisphere");

R_integrated_cylinder = SolarTherm.Utilities.G3P3DomeStorageRValueCalculation_IntegratedStorage(Th_refractory,H_tower, D_tower_out, m_tot, D_outlet,t_storage,"cylinder");

R_integrated_hemisphere = SolarTherm.Utilities.G3P3DomeStorageRValueCalculation_IntegratedStorage(Th_refractory,H_tower, D_tower_out, m_tot, D_outlet,t_storage,"hemisphere");

end TestDomeStorageRCalc;