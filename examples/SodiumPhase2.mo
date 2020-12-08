within examples;
model SodiumPhase2 "High temperature Sodium-sCO2 system"
	extends Modelica.Icons.Example;
	import FI = SolarTherm.Models.Analysis.Finances;
	import SI = Modelica.SIunits;

	parameter Integer n_modules = 4 "Number of modules (CSP plants)";

	parameter Modelica.SIunits.Energy E_fixed_mod =  152425.30 "Constant energy output per module";
	parameter Modelica.SIunits.Energy E_fixed =  n_modules * E_fixed_mod * 1e6 * 3600 "Constant energy output";

    // Design parameters
	parameter SI.RadiantPower R_des = CEFF[7] "Input power to receiver at design point";
	parameter Integer n_heliostat = integer(CEFF[9]) "Number of heliostats";
	parameter Real rec_fr = CEFF[12] "Receiver loss fraction of radiance at design point";
	parameter Real SM = CEFF[13] "Solar multiple";
	parameter Real[13] CEFF = {-332.98449743,118.17098909,-13.96885001,0.55141421,0.00027917,-0.0053865,183655255.657637,200,4981,9,13,0.128565648409309,2.94133997482595};
	parameter SI.Area A_heliostat = 7.07*7.07 "Heliostat module reflective area";
	parameter SI.Area A_field = n_heliostat * A_heliostat "Heliostat field reflective area";
	parameter Real land_mult = 6.16783860571 "Land area multiplier";
	parameter SI.Area A_land = land_mult * n_modules * A_field + 197434.207385281 "Land area";
	parameter SI.Efficiency eff_blk = 0.51 "Power block efficiency at design point";
	parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
	parameter SI.HeatFlowRate Q_flow_des = R_des * (1 - rec_fr) / SM "Heat to power block at design";
	parameter SI.Power P_gross = Q_flow_des * eff_blk "Power block gross rating at design point";
	parameter SI.Power P_name = (1 - par_fr) * P_gross "Power block net rating at design point";
	parameter Real t_storage(fixed = true, unit = "h") = 12.0 "Hours of storage"; // NREL updated the base case storage to 12 hours
	parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";

	// Cost data in USD (default) or AUD
	parameter Real r_disc = 0.044 "Real discount rate"; //Calculated to obtain a nominal discount rate of 0.0701, based on Downselect Criteria, Table 2
	parameter Real r_i = 0.025 "Inflation rate"; //Based on Downselect Criteria, Table 2
	parameter Integer t_life(unit = "year") = 30 "Lifetime of plant"; //Based on Downselect Criteria, Table 2
	parameter Integer t_cons(unit = "year") = 0 "Years of construction"; //Based on Downselect Criteria, Table 2 it should be 3, but for LCOE simple calculation is set to 0
	parameter FI.AreaPrice pri_field = 75 "Field cost per design aperture area";
	parameter FI.AreaPrice pri_site = 10 "Site improvements cost per area";
	parameter FI.EnergyPrice pri_storage = 40 / (1e3 * 3600) "Storage cost per energy capacity";
	parameter FI.PowerPrice pri_block = 900 "Power block cost per gross rated power";
	parameter FI.AreaPrice pri_land = 10000  "Land cost per area (in acres)";
	parameter Real pri_om_name(unit = "$/W/year") = 40  "Fixed O&M cost per nameplate per year";
	parameter Real pri_om_prod(unit = "$/J/year") = 3  "Variable O&M cost per production per year";

	// Spreadsheet costs
	parameter FI.Money_USD C_receiver = 89780652 "Receiver cost";
	parameter FI.Money_USD C_sodium_loop = 20621860 "Sodium loop cost";
	parameter FI.Money_USD C_tower = 20712884 "Tower cost";
	parameter FI.Money_USD C_riser = 18066848 "Riser and downcomer cost"; //Updated based on Felix last spreadsheet
	parameter FI.Money_USD C_hx = 58233886 "Sodium/Salt Heat Exchanger cost";
    // Calculated costs
	parameter FI.Money_USD C_storage = 100958019 "Storage cost";
	parameter FI.Money_USD C_block = n_modules * pri_block * P_gross/ 1e3 "Power block cost";
	parameter FI.Money_USD C_field = n_modules * pri_field * A_field "Field cost";
	parameter FI.Money_USD C_site = n_modules * pri_site * A_field "Site improvements cost";
    // Subtotal
	parameter FI.Money_USD C_cap_dir_sub = C_receiver + C_sodium_loop + C_tower + C_riser + C_hx + C_storage + C_block + C_field + C_site  "Direct capital cost subtotal"; // i.e. purchased equipment costs
	parameter FI.Money_USD C_contingency = 0.1 * C_cap_dir_sub "Contingency costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
	parameter FI.Money_USD C_EPC = 0.09 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs"; //Based on Downselect Criteria, Table 2
	parameter FI.Money_USD C_land = pri_land * A_land/ 4046.86 "Land cost";
	parameter FI.Money_USD C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
	parameter FI.MoneyPerYear C_year = pri_om_name * P_name / 1e3 "Fixed O&M cost per year";
	parameter Real C_prod(unit = "$/J/year") = pri_om_prod/ (1e6 * 3600) "Variable O&M cost per production per year";

	SI.Energy E_elec(min=0) "Stored energy";
	FI.Money R_spot(start=0) "Spot market revenue";

equation
    E_elec = E_fixed;
    R_spot = 0;

    annotation(experiment(StartTime=0.0, StopTime=31536000.0, Interval=60, Tolerance=1e-06));
end SodiumPhase2;
