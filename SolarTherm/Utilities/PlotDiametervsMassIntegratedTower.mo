within SolarTherm.Utilities;

model PlotDiametervsMassIntegratedTower
import SI = Modelica.SIunits;
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph "Medium props for Carbo HSP 40/70";
parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, 823.15) "Cold partilces thermodynamic state at design";
parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, 1073.15) "Hot partilces thermodynamic state at design";
parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold particles specific enthalpy at design";
parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot particles specific enthalpy at design";
parameter SI.Density rho_particle = 2100;
parameter SI.Length H_tower = 200;
parameter SI.Length D_outlet = 0.21;
parameter SI.Mass m_max = 1e7;
parameter SI.HeatFlowRate Q_PB_des = 200e6;
parameter Real t_storage = m_max * (h_hot_set-h_cold_set) / Q_PB_des / 3600;

SI.Length D_inner_tower;

//********************* Tower Inner Diameter Calculator - for integrated storage concept only
  SolarTherm.Utilities.TowerInnerDiameterCalculator_IntegratedG3P3Storage towerInnerDiameterCalculator(
      rho_particle = rho_particle,
      H_tower = H_tower,
      m_max = m_max,
      Th_refractory =  0.6,
      D_outlet = D_outlet
  );

equation
D_inner_tower  = towerInnerDiameterCalculator.D_inner_tower;

end PlotDiametervsMassIntegratedTower;