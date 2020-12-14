within SolarTherm.Utilities;

model TowerInnerDiameterCalculator_IntegratedG3P3Storage
  //******************* This calculator is to calculate the inner tower diameter such that the height of the bins + 30 m (assumed height needed to host the PB = 1/2 of the tower height
  parameter SI.Density rho_particle = 2153 "kg/m^3";
  Real tan_30 = sqrt(3) / 3;
  Real tan_313 = 0.6080095302;
  import SI = Modelica.SIunits;
  parameter SI.Power P_gross = 100e6 / 0.9 "Size of the PB";
  parameter SI.Length H_tower = 236.93 "Height of the tower [m]";
  parameter SI.Length Th_refractory = 0.790596 "Insulation thickness [m]";
  parameter SI.Mass m_max = 3.53427e7 "Mass of the particles that must be hosted by the storage [kg]";
  parameter SI.Length D_outlet = 0.5 "Manifold of the particle [m]";
  parameter SI.Length PB_space_reference = 30 "Space inside the tower integrated-storage to host PB. We assume that 111.111 MWe needs 30 m, and scale proportionally [m]";
  parameter SI.Efficiency phi = 0.6 "Packing factor of the bulk particle";
  Real pi = 3.1415926536;
  SI.Length D_inner_tower(start = 35, min = 0, max = 100);
  SI.Volume V_bin;
  SI.Length H_bin;
  SI.Length D_bin(start = 35, min = 0, max = 100);
  SI.Length PB_space;
  SI.Length monolithic_height "Bin heights + PB space";
equation
  D_bin = D_inner_tower - Th_refractory * 2;
  V_bin = m_max / rho_particle / phi;
  H_bin = (V_bin - pi / 3 * tan_30 * (D_bin - D_outlet) / 2 * (D_bin ^ 2 / 4 + D_outlet ^ 2 / 4 + D_bin * D_outlet / 4) - pi / 3 * D_bin ^ 2 / 4 * tan_313 * D_bin / 2) / (0.25 * pi * D_bin ^ 2) + D_bin / 2 * tan_313 + tan_30 * (D_bin - D_outlet) / 2;
  PB_space = PB_space_reference * P_gross / (100e6 / 0.9);
  monolithic_height = 2 * H_bin + PB_space;
  monolithic_height = 0.5 * H_tower;
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end TowerInnerDiameterCalculator_IntegratedG3P3Storage;