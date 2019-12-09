within SolarTherm.Models.CSP.CRS.Receivers;
function HTC_receiver
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";

  input SI.Length d_i "Inner Tube diameter";
  input Medium1.ThermodynamicState state_mean_Na;
  input SI.Velocity v_Na "Sodium velocity in tubes";

  output Real h_t "Tube-side Heat tranfer coefficient";
  
  protected
  //Tube-side heat transfer coefficient:
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  
  Real Re_Na(start=23551.4178716723,min=0) "Na Reynolds Number";
  Real Pr_Na(unit= "",min=0) "Na Prandtl Number";
  Real Pe_Na(unit= "",min=0) "Na Peclet Number";
  Real A(unit= "") "Correlation coefficient";
  Real Nu_Na(unit= "", min=0) "Na Nusselt number";

algorithm
  rho_Na:=Medium1.density(state_mean_Na);
  cp_Na:=Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na:=Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall:=mu_Na;
  k_Na:=Medium1.thermalConductivity(state_mean_Na);
  Re_Na:=v_Na*d_i/mu_Na;
  Pr_Na:=mu_Na*cp_Na/k_Na;
  Pe_Na:=Re_Na*Pr_Na;
  
  if noEvent(Re_Na>0) then
    if Pe_Na<=1000 then
      A:=4.5;
    elseif Pe_Na>=2000 then
      A:=3.6;
    else
      A:=5.4-9e-4*Pe_Na;
    end if;
    Nu_Na:=A+0.018*Pe_Na;
    h_t:=Nu_Na*k_Na/d_i;
  else
    h_t:=0;
  end if;
  
end HTC_receiver;
