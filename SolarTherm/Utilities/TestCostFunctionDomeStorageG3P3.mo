within SolarTherm.Utilities;

model TestCostFunctionDomeStorageG3P3
  /*Constant specific cost -  For sensitivity analysis*/
  parameter Real c_HRC = 850 "Specific cost of high resistance concrete [USD/m^3]";
  parameter Real c_portland = 229 "Specific cost of portland concrete [USD/m^3]";
  parameter Real c_RF = 2700 "Specific cost of refractory [USD/m^3]";
  parameter Real c_filler_floor = 150 "Specific cost of floor filler material [USD/m^3]";
  parameter Real c_particle = 0.6 "Cost to hold particle mass [USD/kg]";
  parameter Real c_HX_vol_pair = 41 "HX Volume for pair of 16.5 P1157C-1016 Units";
  parameter Real c_excav = 130.795893 "Specififc excavation cost[USD/m^3]";
  parameter Real cap_conveyor = 1800 "Capacity of transorting particle of a single conveyor [ton/h]";
  parameter Real c_conveyor = 4.5e6 "Specific cost of conveyor [USD/unit]";
  parameter Real c_roof = 457.4662;
  parameter Real[10] c = {c_HRC, c_portland, c_RF, c_filler_floor, c_particle, c_HX_vol_pair, c_excav, cap_conveyor, c_conveyor, c_roof};
  parameter Real H_bin = 1.17 * D_bin;
  parameter Real D_bin = 11.9;
  parameter Real D_outlet = 0.21;
  parameter Real t_stg = 6;
  parameter Real m_max = 2173038;
  Real C_storage_system;
  parameter Real D_tower_out = 15;
  parameter Real H_tower = 84;
  parameter Real D_outlet_int = 0.21;
  Real C_storage_in;
equation
  C_storage_system = 2 * SolarTherm.Utilities.G3P3StorageCostFunction(0.6, H_bin, D_bin, D_outlet, t_stg, m_max, c) "Must be around 3.5 million";
  C_storage_in = 2 * SolarTherm.Utilities.G3P3StorageCostFunction_Integrated(0.6, H_tower, D_tower_out, m_max, D_outlet_int, c) "Must be around 2.381 mill";

end TestCostFunctionDomeStorageG3P3;