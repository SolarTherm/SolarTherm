within SolarTherm.Utilities;

model TesCost
  /*Starting from here, specific cost is for Jeremy Sment storage system cost function*/
  /*
  parameter Real pri_HRC = 850 "[ST] Specific cost of high resistance concrete [USD/m^3]";
  parameter Real pri_portland = 229 "[ST] Specific cost of portland concrete [USD/m^3]";
  parameter Real pri_RF = 2700 "[ST] Specific cost of refractory [USD/m^3]";
  parameter Real pri_filler_floor = 150 "[ST] Specific cost of floor filler material [USD/m^3]";
  parameter Real pri_particle_storage = 0.6 "[ST] Cost to hold particle mass [USD/kg]";
  parameter Real pri_HX_vol_pair = 41 "[ST] HX Volume for pair of 16.5 P1157C-1016 Units";
  parameter Real pri_excav = 130.795893 "[ST] Specififc excavation cost[USD/m^3]";
  parameter Real cap_conveyor_1 = 1800 "[ST] Capacity of transorting particle of a single conveyor [ton/h]";
  parameter Real pri_conveyor = 4.5e6 "[ST] Specific cost of conveyor [USD/unit]";
  parameter Real pri_roof = 457.4662 "[ST] Specific cost for roof (integrated storage)";
  parameter Real[10] c = {
                        pri_HRC, 
                        pri_portland, 
                        pri_RF, 
                        pri_filler_floor, 
                        pri_particle_storage, 
                        pri_HX_vol_pair, 
                        pri_excav, 
                        cap_conveyor_1, 
                        pri_conveyor, 
                        pri_roof} "Specific cost of the storage system in an array";
  parameter Real c_HRC = c[1] "Specific cost of high resistance concrete [USD/m^3]";
  parameter Real c_portland = c[2] "Specific cost of portland concrete [USD/m^3]";
  parameter Real c_RF = c[3] "Specific cost of refractory [USD/m^3]";
  parameter Real c_filler_floor = c[4] "Specific cost of floor filler material [USD/m^3]";
  parameter Real c_particle = c[5] "Cost to hold particle mass [USD/kg]";
  parameter Real c_HX_vol_pair = c[6] "HX Volume for pair of 16.5 P1157C-1016 Units";
  parameter Real c_excav = c[7] "Specififc excavation cost[USD/m^3]";
  parameter Real cap_conveyor = c[8] "Capacity of transorting particle of a single conveyor [ton/h]";
  parameter Real c_conveyor = c[9] "Specific cost of conveyor [USD/unit]";
  parameter Real c_roof = c[10];

  parameter Real rho_particle = 2153 "kg/m^3";
  parameter Real tan_30 = sqrt(3)/3;
  parameter Real tan_313 = 0.6080095302; 
  parameter Real pi = 3.1415926536;

  parameter Real Th_refractory = 0.670059 "[m]";
  parameter Real m_max = 37.134e6 "[kg]";
  parameter Real phi = 0.6;
  parameter Real V_bin = m_max / rho_particle / phi;
  parameter Real D_outlet = 0.5;
  parameter Real H_tower = 236.93 ;
  parameter Real D_tower_inner = 50 - 2 * 1.83;

  parameter Real D_bin = D_tower_inner - Th_refractory;
  parameter Real H_bin = (V_bin - pi/3 * tan_30 * ((D_bin/2)^2 - (D_outlet/2)^3))/
                                      (0.25 * pi * D_bin^2) + tan_30*(D_bin/2 + D_outlet/2);
                                      
  parameter Real H_bin_shenannigan = 
  (
    V_bin -
    pi/3 * tan_30 * (D_bin-D_outlet)/2 * (D_bin^2/4+D_outlet^2/4+(D_bin*D_outlet)/4)
    - (pi /3 * D_bin^2/4 * tan_313 * D_bin/2)
    ) / (0.25 * pi * D_bin^2) + D_bin/2 * tan_313 + tan_30 * (D_bin-D_outlet)/2;

  parameter Real H_cylindrical = H_bin - tan_30 * D_bin/2;

  parameter Real A_internal_bin_shenanigan = pi*D_bin^2/4+2*pi*D_bin/2*H_bin "Cylindrical part only why?Why using the H_bin not H_cylindrical";

  parameter Real A_internal_bin = 1/4 * pi * D_bin^2 * H_cylindrical + pi * D_bin/2 * tan_30*D_bin/2 - pi * D_outlet/2 * tan_30*D_outlet/2;


  parameter Real V_refractory_tower = 
  pi*(H_bin)*((D_bin/2+Th_refractory)^2-(D_bin/2)^2);

  parameter Real V_refractory_tower_shenanigan = 
  pi*(H_bin_shenannigan)*((D_bin/2+Th_refractory)^2-(D_bin/2)^2);

  parameter Real V_refractory_roof = 
  pi*(D_bin+Th_refractory)^2/4*Th_refractory;

  parameter Real C_refractory = 
  V_refractory_roof*c_roof + V_refractory_tower*c_RF;

  parameter Real C_refractory_shenanigan = 
  V_refractory_roof*c_roof + V_refractory_tower_shenanigan*c_RF;

  parameter Real Th_HRC = 
        3.2832285689461693e-001
        + 1.1518447137747705e-004 * A_internal_bin
        -1.4095189864825422e-008 * A_internal_bin^2
        + 1.1372113852466968e-012 * A_internal_bin^3;

  parameter Real V_HRC = 
  pi/4*(H_bin-tan_313*D_bin/2)*((D_bin/2+Th_refractory+Th_HRC)^2-(D_bin/2+Th_refractory)^2);

  parameter Real V_HRC_shenanigan = 
  pi/4 * (H_bin_shenannigan - tan_313 * D_bin/2) * ((D_bin + 2 * Th_refractory + 2 * Th_HRC)^2 - (D_bin + 2 * Th_refractory + 2 * Th_HRC)^2);

  parameter Real C_HRC = V_HRC*0.67*c_HRC;
  parameter Real C_HRC_shenanigan = V_HRC_shenanigan*0.67*c_HRC;

  parameter Real V_floor = 
  pi/3*tan_30*(2*(D_bin/2)^3-3*(D_outlet/2)*(D_bin/2)^2+(D_outlet/2)^3);

  parameter Real C_floor = V_floor*0.9*c_filler_floor+V_floor*0.1*rho_particle*c_particle;

  Real C_total_bin;
  Real C_total_bin_shennigan;

  algorithm
  C_total_bin := 1 * (C_HRC+C_refractory+C_floor);
  C_total_bin_shennigan := 1 * (C_HRC_shenanigan + C_refractory_shenanigan + C_floor);*/
  /*Starting from here, specific cost is for Jeremy Sment storage system cost function*/
  parameter Real pri_HRC = 850 "[ST] Specific cost of high resistance concrete [USD/m^3]";
  parameter Real pri_portland = 229 "[ST] Specific cost of portland concrete [USD/m^3]";
  parameter Real pri_RF = 2700 "[ST] Specific cost of refractory [USD/m^3]";
  parameter Real pri_filler_floor = 150 "[ST] Specific cost of floor filler material [USD/m^3]";
  parameter Real pri_particle_storage = 1 "[ST] Cost to hold particle mass [USD/kg]";
  parameter Real pri_HX_vol_pair = 41 "[ST] HX Volume for pair of 16.5 P1157C-1016 Units";
  parameter Real pri_excav = 130.795893 "[ST] Specififc excavation cost[USD/m^3]";
  parameter Real cap_conveyor_1 = 1800 "[ST] Capacity of transorting particle of a single conveyor [ton/h]";
  parameter Real pri_conveyor = 4.5e6 "[ST] Specific cost of conveyor [USD/unit]";
  parameter Real pri_roof = 457.4662 "[ST] Specific cost for roof (integrated storage)";
  parameter Real[10] c = {pri_HRC, pri_portland, pri_RF, pri_filler_floor, pri_particle_storage, pri_HX_vol_pair, pri_excav, cap_conveyor_1, pri_conveyor, pri_roof} "Specific cost of the storage system in an array";
  parameter Real c_HRC = c[1] "Specific cost of high resistance concrete [USD/m^3]";
  parameter Real c_portland = c[2] "Specific cost of portland concrete [USD/m^3]";
  parameter Real c_RF = c[3] "Specific cost of refractory [USD/m^3]";
  parameter Real c_filler_floor = c[4] "Specific cost of floor filler material [USD/m^3]";
  parameter Real c_particle = c[5] "Cost to hold particle mass [USD/kg]";
  parameter Real c_HX_vol_pair = c[6] "HX Volume for pair of 16.5 P1157C-1016 Units";
  parameter Real c_excav = c[7] "Specififc excavation cost[USD/m^3]";
  parameter Real cap_conveyor = c[8] "Capacity of transorting particle of a single conveyor [ton/h]";
  parameter Real c_conveyor = c[9] "Specific cost of conveyor [USD/unit]";
  parameter Real c_roof = c[10];
  parameter Real rho_particle = 2153 "kg/m^3";
  parameter Real tan_30 = sqrt(3) / 3;
  parameter Real tan_313 = 0.6080095302;
  parameter Real pi = 3.1415926536;
  parameter Real Th_refractory = 0.6 "[m]";
  parameter Real m_max = 33.6e6 "[kg]";
  parameter Real phi = 0.6;
  parameter Real V_bin = m_max / rho_particle / phi;
  parameter Real D_outlet = 0.5;
  parameter Real H_tower = 236.93 "[m]";
  Real D_tower_inner(start = 40);
  Real D_bin;
  Real H_bin;
  Real H_cylindrical;
  Real A_internal_bin;
  Real V_refractory_tower;
  Real V_refractory_roof;
  Real C_refractory;
  Real Th_HRC;
  Real V_HRC;
  Real C_HRC;
  Real V_floor;
  Real C_floor;
  Real C_total_bin;
  Real C_total_bin_test;
  Real C_total;
equation
//*******Constraint
  2 * H_bin + 30 = 0.5 * H_tower;
  D_bin = D_tower_inner - 2 * Th_refractory;
  H_bin = (V_bin - pi / 3 * tan_30 * (D_bin - D_outlet) / 2 * (D_bin ^ 2 / 4 + D_outlet ^ 2 / 4 + D_bin * D_outlet / 4) - pi / 3 * D_bin ^ 2 / 4 * tan_313 * D_bin / 2) / (0.25 * pi * D_bin ^ 2) + D_bin / 2 * tan_313 + tan_30 * (D_bin - D_outlet) / 2;
  H_cylindrical = H_bin - tan_30 * D_bin / 2;
  A_internal_bin = pi * D_bin ^ 2 / 4 + 2 * pi * D_bin / 2 * H_bin "Cylindrical part only why?Why using the H_bin not H_cylindrical";
  V_refractory_tower = pi * H_bin * ((D_bin / 2 + Th_refractory) ^ 2 - (D_bin / 2) ^ 2);
  V_refractory_roof = pi * (D_bin + Th_refractory) ^ 2 / 4 * Th_refractory;
  C_refractory = V_refractory_roof * c_roof + V_refractory_tower * c_RF;
  Th_HRC = 3.2832285689461693e-001 + 1.1518447137747705e-004 * A_internal_bin - 1.4095189864825422e-008 * A_internal_bin ^ 2 + 1.1372113852466968e-012 * A_internal_bin ^ 3;
  V_HRC = pi * (H_bin - tan_313 * D_bin / 2) * ((D_bin / 2 + Th_refractory + Th_HRC) ^ 2 - (D_bin / 2 + Th_refractory) ^ 2);
  C_HRC = V_HRC * 0.67 * c_HRC;
  V_floor = pi / 3 * tan_30 * (2 * (D_bin / 2) ^ 3 - 3 * (D_outlet / 2) * (D_bin / 2) ^ 2 + (D_outlet / 2) ^ 3);
  C_floor = V_floor * 0.9 * c_filler_floor + V_floor * 0.1 * rho_particle * c_particle;
  C_total_bin = 1 * (C_HRC + C_refractory + C_floor);
  C_total_bin_test = SolarTherm.Utilities.G3P3StorageCostFunction_Integrated(Th_refractory, H_tower, D_tower_inner, m_max, 0.5, phi, c);
  C_total = 2 * C_total_bin_test + m_max * c_particle;
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end TesCost;