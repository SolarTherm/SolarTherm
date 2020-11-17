within SolarTherm.Utilities;

function h_particle

input Real k_s;
input Real Dh;
input Real L;
input Real Pe_Dh;
output Real h_particle_calculated;

protected
Real inv_Gz = L/(Pe_Dh * Dh);
Real Nu_Dh = SolarTherm.Utilities.nu_plug(inv_Gz);
algorithm
h_particle_calculated := Nu_Dh * k_s / Dh;

end h_particle;