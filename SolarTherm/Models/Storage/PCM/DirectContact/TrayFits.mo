within SolarTherm.Models.Storage.PCM.DirectContact;

function TrayFits
    //Returns Clearance between plates
    input Real cost_tray;
    input Real V_vessel;
    input Real A_PCM;
    input Real a;
    //aspect ratio
    input Real thick_tray;
    input Real rho_tray;
    input Real cost_tray;
    input Real L_wall;
    output Real Spacing;
  protected
    Real A_vessel_base;
    Real N_trays;
    Real A_tray_base;
    Real pi;
    Real height;
  algorithm
    pi := 2 * Modelica.Math.asin(1.0);
    A_vessel_base := (V_vessel ^ 2 * pi / (4.0 * a * a)) ^ (1 / 3);
    N_trays := floor(A_PCM / (0.9 * A_vessel_base)) + 1;
    A_tray_base := A_PCM / N_trays;
    height := (4.0 * a * a * V_vessel / pi) ^ (1.0 / 3.0);
    Spacing := (height - L_wall * N_trays) / (N_trays + 1);
end TrayFits;