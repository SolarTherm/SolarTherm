within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function HTCs
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  input SI.Length d_o "Outer Tube diameter";
  input Integer N_p "Number of tube-passes";
  input Integer N_sp "Number of shell-passes";
  input Integer layout "Tube layout";
  input Integer N_t "Number of tubes";
  input Medium1.ThermodynamicState state_mean_Na;
  input Medium2.ThermodynamicState state_mean_MS;
  input Medium2.ThermodynamicState state_wall_MS;
  input SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  input SI.MassFlowRate m_flow_MS "Molten-Salt mass flow rate";
  input SI.Length l_b "Baffle spacing";
  
  output SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";

protected
  parameter SI.ThermalInsulance R_ss = 8.808e-5 "Fouling resistance";
  parameter SI.Length t_tube=TubeThickness(d_o=d_o) "Tube Thickness";
  parameter SI.Length d_i = d_o - 2 * t_tube "Inner Tube diameter";
  parameter SI.Length P_t=1.25*d_o "Tube Pitch";
  parameter Real B=0.25 "Baffle cut";
  parameter Real N_ss=0.2 "Number of sealing strips";
  
  //Tube-Side
  Real Re_Na "Na Reynolds Number";
  Real Pr_Na "Na Prandtl Number";
  Real Pe_Na "Na Peclet Number";
  Real A "Correlation coefficient";
  Real Nu_Na "Na Nusselt number";
  Integer Tep "Tubes for each pass";
  SI.Area A_cs "Single Tube Cross-section Area";
  SI.Area A_cs_tot "Total Cross-section Area";
  Real M_Na(unit = "kg/m2/s") "Mass velocity of Na (tube-side)";
  
  //Shell-side
  SI.Length L_bb;
  SI.Length D_b;
  SI.Length D_s;
  SI.Length D_s_out;
  SI.Area S_m;
  SI.Velocity v_max_MS "Molten Salt Velocity";
  Real Re_MS "MS Reynolds Number";
  Real Pr_MS "MS Prandtl Number";
  Real Nu_MS "MS Nusselt Number";
  Real aa "Correlation coefficient";
  Real mm "Correlation coefficient";
  SI.CoefficientOfHeatTransfer h_s_id "Ideal shell-side Heat tranfer coefficient";
  SI.Length L_c "Baffle length";
  SI.Angle theta_ds "Centriangle of baffle cut";
  SI.Angle theta_ctl "Upper centriangle of baffle cut";
  Real F_w(unit = "") "Fraction of tubes in crossflow";
  Real F_c(unit = "") "Fraction of tubes in crossflow";
  Real J_C(unit = "") "Configuration correction factor";
  SI.Length L_sb "Shell-to-baffle diametral clearance";
  SI.Area S_b "Bypass flow area";
  SI.Area S_sb "Shell-to-baffle leakage area";
  SI.Area S_tb "Tube-to-baffle leakage area";
  SI.Length L_tb "Tube-to-baffle diametral clearance";
  Real r_lm(unit = "") "Non dimensional factor";
  Real r_s(unit = "") "Non dimensional factor";
  Real xx(unit = "") "Non dimensional factor";
  Real J_L(unit = "") "Leakage correction factor";
  Real F_bp(unit = "") "Bypass correction factor";
  Real N_c "Number of crossflow rows";
  Real r_ss "Fraction";
  Real J_B(unit = "") "Bypass correction factor";    
  
  //Fluid properties
  SI.Temperature Tm_Na "Mean Sodium Fluid Temperature";
  SI.Temperature Tm_MS "Mean Molten Salts Fluid Temperature";
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.Density rho_MS "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  SI.ThermalConductivity k_wall "Tube Thermal Conductivity";
  SI.Density rho_wall "HX material density";
  SI.Temperature Tm_wall "Mean Wall Temperature";
  
algorithm
  Tm_MS := Medium2.temperature(state_mean_MS);
  Tm_Na := Medium1.temperature(state_mean_Na);
  Tm_wall := (Tm_MS+Tm_Na)/2;
  (k_wall, rho_wall) := Haynes230_BaseProperties(Tm_wall);
  
  //Sodium properties
  rho_Na := Medium1.density(state_mean_Na);
  cp_Na := Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na := Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall := mu_Na;
  k_Na := Medium1.thermalConductivity(state_mean_Na);

//Chloride Salt properties
  rho_MS := Medium2.density(state_mean_MS);
  cp_MS := Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS := Medium2.dynamicViscosity(state_mean_MS);
  mu_MS_wall := Medium2.dynamicViscosity(state_wall_MS);
  k_MS := Medium2.thermalConductivity(state_mean_MS);


//Tube Side Heat Transfer Coefficient
  Tep:=integer(ceil(N_t/N_p));
  A_cs:=CN.pi/4*d_i^2;
  A_cs_tot:=Tep*A_cs;
  M_Na:=m_flow_Na/A_cs_tot;
  Re_Na:=M_Na*d_i/mu_Na;
  Pr_Na:=mu_Na*cp_Na/k_Na;
  Pe_Na:=Re_Na*Pr_Na;
  if (Pe_Na>0) then
      if Pe_Na<=1000 then
        A:=4.5;
      elseif Pe_Na>=2000  then
        A:=3.6;
      else
        A:=5.4-9e-4*Pe_Na;
      end if;
      Nu_Na:=A+0.018*Pe_Na;
      h_t:=Nu_Na*k_Na/d_i;
    else
      h_t:=0;
  end if;
  
//Shell-side heat transfer coefficient:
  (L_bb, D_b, D_s, D_s_out) := ShellDiameter(d_o=d_o, N_t=N_t, layout=layout, N_p=N_p);  
  S_m:=(l_b/N_sp)*(L_bb+(D_b/P_t)*(P_t-d_o));
  v_max_MS:=m_flow_MS/rho_MS/S_m;
  Re_MS:=rho_MS*d_o*v_max_MS/mu_MS;
  Pr_MS:=mu_MS*cp_MS/k_MS;
  if (Re_MS>0) and (Pr_MS>0) then
      if layout==1  then
          if (Re_MS<=300) then 
              aa:=0.742;
              mm:=0.431;
          elseif (Re_MS>300) and (Re_MS<2e5) then
              aa:=0.211;
              mm:=0.651;
          elseif (Re_MS>2e5) and (Re_MS<2e6)  then
              aa:=0.116;
              mm:=0.7;
          end  if;
      else
          if (Re_MS<=300)  then
              aa:=1.309;
              mm:=0.36;
          elseif (Re_MS>300) and (Re_MS<2e5)  then 
              aa:=0.273;
              mm:=0.635;
          elseif (Re_MS>2e5) and (Re_MS<2e6)  then
              aa:=0.124;
              mm:=0.7;
          end  if;
      end if;
      Nu_MS:=aa*(Re_MS^mm)*(Pr_MS^0.34)*((mu_MS/mu_MS_wall)^0.26);
      h_s_id:=Nu_MS*k_MS/d_o;
      L_c:=B*D_s;
      theta_ctl:=2*acos((D_s-2*L_c)/D_b);
      F_w:=theta_ctl/(2*CN.pi)-sin(theta_ctl)/(2*CN.pi);
      F_c:=1-2*F_w;
      J_C:=0.55+0.72*F_c;
      L_sb:=(3.1+0.004*D_s)/1000;
      theta_ds:=2*acos(1-2*B);
      S_sb:=(D_s/N_sp)*(CN.pi/2)*L_sb*((2*CN.pi-theta_ds)/(2*CN.pi));
      L_tb:=0.0008;
      S_tb:=(1/N_sp)*(CN.pi/4)*((d_o+L_tb)^2-d_o^2)*N_t*(1-F_w);
      r_lm:=(S_sb+S_tb)/S_m;
      r_s:=S_sb/(S_sb+S_tb);
      xx:=-0.15*(1+r_s)+0.8;
      J_L:=0.44*(1-r_s)+(1-0.44*(1-r_s))*exp(-2.2*r_lm);
      S_b:=L_bb*l_b;
      F_bp:=S_b/S_m;
      if layout==1  then
          N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t);
      else
          N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t/0.866);
      end if;
      r_ss:=N_ss/N_c;
      J_B:=exp(-1.35*F_bp*(1-(2*r_s)^(1/3)));
      h_s:=h_s_id*J_C*J_L*J_B;  
  else
      h_s:=0;
  end if; 
  
//Global heat transfer coefficient:
  if (Re_Na==0) or (Re_MS==0)  then
    U:=0;
  else
    U:=(1/h_s+R_ss+1/h_t*d_o/d_i+d_o*0.5/k_wall*log(d_o/d_i))^(-1);
  end if;

end HTCs;