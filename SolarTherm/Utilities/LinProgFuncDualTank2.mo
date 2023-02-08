within SolarTherm.Utilities;

function LinProgFuncDualTank2
  input Real c0 "Rewards for producing hot hydrogen";
  input Real c1 "Penalty for burning hydrogen in the hydrogen tank";
  input Real c2 "Penalty for dumping heat from solar field";
  input Real c3 "Penalty for dumping electricity from PV";
  input Integer n_horizon "Horizon , how many look-ahead time steps";
  input Real dt "Time step in [s]";
  input Real c_ratio "Ratio between H_recycled and H2_reactor [-]";
  input Real etaPB "Power block efficiency at design point [-]";
  input Real etaSF[:] "Solar field efficiency for the next forecast horizon [-]";
  input Real etaRCV[:] "Receiver efficiency at design point [-]";
  input Real etaAEL "Electrolyser efficiency at design point [-]";
  input Real etaBurner "Hydrogen burner efficiency at design point [-]";
  input Real etaResistive "Resistive heater efficiency [-]";
  input Real dni[:] "DNI for the next forecast horizon [W/m2]";
  input Real P_PV_in_z[:] "Net electricity production for the next forecast horizon [MWe]";
  input Real P_AEL_nameplate "Electrolyser nameplate [MWe]";
  input Real A_sf "Total area of the solar field [m2]";
  input Real PB_size "PB name plate [MWe]";
  input Real TES_capacity "TES capacity [MWhth]";
  input Real Q_TES_HX_max "Maximum dispatchable thermal power from the TES to the TES-heater to heat-up H2_reactor + H2_recycle";
  input Real E_TES_init "Initial level of TES [MWhth]";
  input Real E_TES_min "Minimum TES level [MWhth]";
  input Real Q_H2_reactor_max "Maximum heat from the H₂ storage to the reactor (MWth) -- caried by the H2_reactor";
  input Real LHV "Lower heating value of the hydrogen [MJ]";
  input Real delta_h_H2 "Enthalpy change of the H2 before and after the pre-heating [MJ/kg]";
  input Real H2stg_capacity "H2 storage capacity [MWhth]";
  input Real H2stg_init "Initial level of H2 storage [MWhth]";
  input Real H2stg_min "Minimum level of H2 storage [MWhth]";
  input Real t0 "Starting time [s]";
  input Real um "CSP multipier";
  /*
  Solution index:
      1: P_PV_AEL       [MWe]
      2: P_PV_TES       [MWe]
      3: Q_TES_PB       [MWth]
      4: Q_TES_HX       [MWth]
      5: Q_H2_reactor   [MWth]
      6: Q_H2_burner    [MWth]
  */
  output Real optimalSolution[9] "Array to store the solution of the optimal dispatch";

  external "C" st_linprog_dualtank2(
    c0, c1, c2, c3, n_horizon, dt, c_ratio,
    etaPB, etaSF, etaRCV, etaAEL, etaBurner, etaResistive,
    dni, P_PV_in_z, P_AEL_nameplate,A_sf,
    PB_size, TES_capacity, Q_TES_HX_max, E_TES_init, E_TES_min,
    Q_H2_reactor_max, LHV, delta_h_H2, H2stg_capacity, H2stg_init, H2stg_min,
    t0, um, optimalSolution
  );
  annotation(Library="st_linprog_dualtank2");
end LinProgFuncDualTank2;