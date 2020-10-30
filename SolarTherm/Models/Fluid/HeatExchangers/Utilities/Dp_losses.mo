within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function Dp_losses
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  input SI.Length d_o "Outer Tube diameter";
  input Integer N_p "Number of passes";
  input Integer N_sp "Number of shell-passes";
  input Integer layout "Tube layout";
  input Integer N_t "Number of tubes";
  input SI.Length L "Tube length";
  input Medium1.ThermodynamicState state_mean_Na;
  input Medium2.ThermodynamicState state_mean_MS;
  input Medium2.ThermodynamicState state_wall_MS;
  input SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  input SI.MassFlowRate m_flow_MS "Molten-Salt mass flow rate";
  input SI.Length l_b "Baffle spacing";
  input Integer N "Number of baffles";
  
  output SI.Pressure Dp_tube(min = 0) "Tube-side pressure drop";
  output SI.Pressure Dp_shell(min = 0) "Shell-side pressure drop";
  output SI.Velocity v_Na(min = 0) "Sodium velocity in tubes";
  output SI.Velocity v_max_MS(min = 0) "Molten Salt velocity in shell";
  
protected

  parameter SI.Length t_tube=TubeThickness(d_o=d_o);
  parameter SI.Length d_i = d_o - 2 * t_tube "Inner Tube diameter";
  parameter SI.Length P_t=1.25*d_o;
  parameter Real B=0.25;
  parameter Real N_ss=0.2;
  parameter SI.Length L_tb=0.0008;
  
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
  
  //Tube-side pressure drop:
  Real Re_Na "Na Reynolds Number";
  Integer Tep "Tubes for each pass";
  SI.Area A_cs;
  SI.Area A_cs_tot;
  Real M_Na(unit = "kg/m2/s") "Mass velocity of Na (tube-side)";
  Real j_f(unit = "") "Friction factor";
  Real m(unit = "") "Correlation coefficient";
  Real N_c "Number of crossflow rows";

  //Shell-side pressure drop:
  SI.Length L_bb "Bundle-to-shell diametral clearance";
  SI.Length D_b "Bundle diameter";
  SI.Length D_s "Shell Diameter";
  SI.Length D_s_out "Shell Diameter";
  SI.Length L_c "Baffle length";
  SI.Area S_m;
  Real Re_MS "MS Reynolds Number";
  Real N_cw "Number of effective crossflow rows in the window zone";
  SI.Area S_b "Bypass flow area";
  SI.Length L_sb "Shell-to-baffle diametral clearance";
  SI.Angle theta_ds "Centriangle of baffle cut";
  SI.Angle theta_ctl "Upper centriangle of baffle cut";
  SI.Area S_sb "Shell-to-baffle leakage area";
  SI.Area S_tb "Tube-to-baffle leakage area";
  Real F_w(unit = "") "Fraction of tubes in crossflow";
  Real F_c(unit = "") "Fraction of tubes in crossflow";  
  Real F_bp(unit = "") "Bypass Factor";
  Real r_lm(unit = "") "Non dimensional factor";
  Real r_s(unit = "") "Non dimensional factor";
  Real xx(unit = "") "Non dimensional factor";
  Real r_ss "Fraction";
  Real R_L(unit = "") "Non dimensional factor";
  Real R_B(unit = "") "Non dimensional factor";
  Real K_f "Non dimensional factor";
  SI.Area S_wg "Window flow area";
  SI.Area S_wt "Window flow area";
  SI.Area S_w "Window flow area";
  SI.Pressure Dp_c "Ideal crossflow pressure drop";
  SI.Pressure Dp_w "Pressure drop for the window zone";
  SI.Pressure Dp_bi "Pressure drop base";
  SI.Pressure Dp_e "Pressure drop base";
  
algorithm
  Tm_MS := Medium2.temperature(state_mean_MS);
  Tm_Na := Medium1.temperature(state_mean_Na);
  Tm_wall:=(Tm_MS+Tm_Na)/2;
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
    
  //Tube-side pressure drop:
  Tep:=integer(ceil(N_t/N_p));
  A_cs:=pi/4*d_i^2;
  A_cs_tot:=Tep*A_cs;
  M_Na:=m_flow_Na/A_cs_tot;
  Re_Na:=M_Na*d_i/mu_Na;
  v_Na:=M_Na/rho_Na;
  if (Re_Na>0)  then
    if (Re_Na<=855) then 
      j_f:=8.1274*Re_Na^(-1.011);
    else
      j_f:=0.046*Re_Na^(-0.244);
    end  if;
    if (Re_Na<=2100)  then 
      m:=0.25;
    else
      m:=0.14;
    end  if;
      Dp_tube:=(N_p*(2.5+8*j_f*(L/d_i)*(mu_Na/mu_Na_wall)^(-m)))*0.5*rho_Na*v_Na^2;
    else
      Dp_tube:=0;
    end if;  

  //Shell-side heat transfer coefficient:
  (L_bb, D_b, D_s, D_s_out) := ShellDiameter(d_o=d_o, N_t=N_t, layout=layout, N_p=N_p);  
  L_c:=B*D_s;
  S_m:=(l_b/N_sp)*(L_bb+(D_b/P_t)*(P_t-d_o));
  v_max_MS:=m_flow_MS/rho_MS/S_m;
  Re_MS:=rho_MS*d_o*v_max_MS/mu_MS;
  if (Re_MS>0) then
      if layout==1  then
          N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t);
      else
          N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t/0.866);
      end  if;
  if layout==1  then
      N_cw:=ceil(0.8/P_t*(L_c-(D_s-D_b)/2));
  else
      N_cw:=ceil(0.8/(0.866*P_t)*(L_c-(D_s-D_b)/2));
  end  if;
  if layout==1  then
    if (Re_MS<2300) then  
      K_f:=0.272+(0.207e3/Re_MS)+(0.102e3/Re_MS^2)-(0.286e3/Re_MS^3);
    else
      K_f:=0.267+(0.249e4/Re_MS)-(0.927e7/Re_MS^2)+(10^10/Re_MS^3);
    end if;
  else
    if (Re_MS>4000)  then
      K_f:=0.245+(0.339e4/Re_MS)-(0.984e7/Re_MS^2)+(0.133e11/Re_MS^3)-(0.599e13/Re_MS^4);
    else
      K_f:=11.474*Re_MS^(-0.34417);
    end if;
  end if;
      Dp_bi:=N_c*K_f*0.5*rho_MS*v_max_MS^2;
      S_b:=L_bb*l_b;
      L_sb:=(3.1+0.004*D_s)/1000;
      theta_ds:=2*acos(1-2*B);
      S_sb:=(D_s/N_sp)*(pi/2)*L_sb*((2*pi-theta_ds)/(2*pi));
      theta_ctl:=2*acos((D_s-2*L_c)/D_b);
      F_w:=theta_ctl/(2*pi)-sin(theta_ctl)/(2*pi);
      F_c:=1-2*F_w;
      S_tb:=(1/N_sp)*(pi/4)*((d_o+L_tb)^2-d_o^2)*N_t*(1-F_w);
      r_s:=S_sb/(S_sb+S_tb);
      r_lm:=(S_sb+S_tb)/S_m;
      xx:=-0.15*(1+r_s)+0.8;
      R_L:=exp(-1.23*(1+r_s))*r_lm^xx;
      F_bp:=S_b/S_m;
      r_ss:=N_ss/N_c;
      R_B:=exp(-3.7*F_bp*(1-r_ss^(1/3)));
      Dp_c:=Dp_bi*(N-1)*R_B*R_L;
      S_wg:=(pi/4)*(D_s^2/N_sp)*(theta_ds/(2*pi)-sin(theta_ds)/(2*pi));
      S_wt:=(N_t/N_sp)*F_w*(pi/4)*d_o^2;
      S_w:=S_wg-S_wt;
      Dp_w:=(0.2+0.6*N_cw)/(2*S_m*S_w*rho_MS)*m_flow_MS^2;
      Dp_e:=2*Dp_bi*R_B*(1+N_cw/N_c);
      Dp_shell:=N_sp*(((N-1)*Dp_bi*R_B+N*Dp_w)*R_L+Dp_e);
    else
      Dp_shell:=0;
  end if;

end Dp_losses;
