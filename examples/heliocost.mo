within examples;

model heliocost
parameter Real Wspd_max = 15.65;
parameter Real A_helio = 150;
Real cost;
equation

cost = SolarTherm.Models.Analysis.Finances.heliostat_specific_cost_w_spd(Wspd_max,A_helio) * 0.3716;

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end heliocost;