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

  output SI.Pressure Dp_tube(min=0) "Tube-side pressure drop";
  output SI.Pressure Dp_shell(min=0) "Shell-side pressure drop";
  output SI.Velocity v_Na(min=0) "Sodium velocity in tubes";
  output SI.Velocity v_max_MS(min=0) "Molten Salt velocity in shell";
  output Integer N "Number of baffles";
  
  protected
  parameter SI.Length t_tube=TubeThickness(d_o) "Tube thickness";
  
  //Tube Side  
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  parameter SI.Length d_i=d_o-2*t_tube "Inner Tube diameter";
  Real M_Na(unit= "kg/m2/s",start=287.349397220073,min=0) "Mass velocity of Na (tube-side)";
  Real Re_Na(start=23551.4178716723,min=0) "Na Reynolds Number";
  Real j_f(unit= "") "Friction factor";
  Real m(unit= "") "Correlation coefficient";
  Integer Tep(start=7962) "Tubes for each pass";
  SI.Area A_cs(start=0.000174834657720518) "Single tube cross section area";
  SI.Area A_cs_tot(start=1.39203354477076) "Total cross section area";
  
  //Shell-side heat transfer coefficient:
  SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  SI.Density rho_MS "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  parameter SI.Length t_b=t_tube "Baffle thickness";
  parameter SI.Length P_t=1.25*d_o "Tube pitch";
  parameter Real B=0.25 "Baffle cut";
  parameter SI.Length L_tb=0.0008 "Tube-to-baffle diametral clearance";
  parameter Real N_ss=0.2 "Number of sealing strips per crossflow";
  Real KK1(unit= "",start=0.158) "Correlation coefficient";
  Real nn1(unit= "",start=2.263) "Correlation coefficient";
  SI.Length L_bb(start=0.0342502444061721) "Bundle-to-shell diametral clearance";
  SI.Length D_b(start=4.42) "Bundle diameter";
  SI.Length D_s "Shell Diameter";
  SI.Length l_b "Baffle spacing";
  Integer N_calc "Number of Baffles calculated";
  SI.Area S_m(start=1.62588760919663) "Minimal crossflow area at bundle centerline";
  Real Re_MS(start=100,min=0) "MS Reynolds Number";
  SI.Area S_b "Bypass flow area";
  SI.Length L_c(start=1.11251222030861) "Baffle length";
  SI.Angle theta_ds "Centriangle of baffle cut";
  SI.Angle theta_ctl "Upper centriangle of baffle cut";
  SI.Length L_sb "Shell-to-baffle diametral clearance";
  SI.Area S_sb "Shell-to-baffle leakage area";
  SI.Area S_tb "Tube-to-baffle leakage area";
  Real r_s(unit= "") "Non dimensional factor";
  Real r_ss(unit= "") "Non dimensional factor";
  Real r_lm(unit= "") "Non dimensional factor";
  Real xx(unit= "") "Non dimensional factor";
  Real N_c(start=90) "Number of crossflow rows";  
  Real F_w(unit= "") "Fraction of tubes in crossflow";
  Real F_bp(unit= "") "Bypass Factor";
  Real F_c(unit= "") "Fraction of tubes in crossflow";
  
  Real N_cw "Number of effective crossflow rows in the window zone";
  Real K_f "Non dimensional factor";
  SI.Area S_wg "Window flow area";
  SI.Area S_wt "Window flow area";
  SI.Area S_w(start=3.04066566915712) "Window flow area";
  SI.Pressure Dp_c "Ideal crossflow pressure drop";  
  SI.Pressure Dp_w "Pressure drop for the window zone";
  SI.Pressure Dp_bi "Pressure drop base";
  SI.Pressure Dp_e "Pressure drop base";
  Real R_B(unit= "") "Non dimensional factor";
  Real R_L(unit= "") "Non dimensional factor";



  
algorithm

  //Tube-side pressure drop:
  rho_Na:=Medium1.density(state_mean_Na);
  cp_Na:=Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na:=Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall:=mu_Na;
  k_Na:=Medium1.thermalConductivity(state_mean_Na);
  Tep:=integer(ceil(N_t/N_p));
  A_cs:=CN.pi/4*d_i^2;
  A_cs_tot:=Tep*A_cs;
  M_Na:=m_flow_Na/A_cs_tot;
  v_Na:=M_Na/rho_Na;
  Re_Na:=M_Na*d_i/mu_Na;
  if noEvent(Re_Na>0) then
    if noEvent(Re_Na<=855) then
      j_f:=8.1274*Re_Na^(-1.011);
    else
      j_f:=0.046*Re_Na^(-0.244);
    end if;
    if noEvent(Re_Na<=2100) then
      m:=0.25;
    else
      m:=0.14;
    end if;
    Dp_tube:=(N_p*(2.5+8*j_f*(L/d_i)*(mu_Na/mu_Na_wall)^(-m)))*0.5*rho_Na*v_Na^2;
  else
    Dp_tube:=0;
  end if;
  
  //Shell-side heat transfer coefficient:
  rho_MS:=Medium2.density(state_mean_MS);
  cp_MS:=Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS:=Medium2.dynamicViscosity(state_mean_MS);
  mu_MS_wall:=Medium2.dynamicViscosity(state_wall_MS);
  k_MS:=Medium2.thermalConductivity(state_mean_MS);
  if layout==1 then
    if N_p==1 then
      KK1:=0.215;
      nn1:=2.207;
    elseif N_p==2 then
      KK1:=0.156;
      nn1:=2.291;
    elseif N_p==4 then
      KK1:=0.158;
      nn1:=2.263;
    elseif N_p==6 then
      KK1:=0.0402;
      nn1:=2.617;
    elseif N_p==8 then
      KK1:=0.0331;
      nn1:=2.643;
    end if;
  else
    if N_p==1 then
      KK1:=0.319;
      nn1:=2.142;
    elseif N_p==2 then
      KK1:=0.249;
      nn1:=2.207;
    elseif N_p==4 then
      KK1:=0.175;
      nn1:=2.285;
    elseif N_p==6 then
      KK1:=0.0743;
      nn1:=2.499;
    elseif N_p==8 then
      KK1:=0.0365;
      nn1:=2.675;
    end if;
  end if;
  D_b:=(N_t/KK1)^(1/nn1)*d_o;
  L_bb:=(12+5*(D_b+d_o))/995;
  D_s:=L_bb+D_b+d_o;
  L_c:=B*D_s;
  l_b:=D_s;
  N_calc:=integer(ceil((L/(l_b+t_b)-1)*N_sp));
  N:= if N_calc<10 then 10 else N_calc;
  l_b:=L/(N/N_sp+1);
  S_m:=(l_b/N_sp)*(L_bb+(D_b/P_t)*(P_t-d_o));
  v_max_MS:=m_flow_MS/rho_MS/S_m;
  Re_MS:=rho_MS*d_o*v_max_MS/mu_MS;
  
  if noEvent(Re_MS>0) then
    if layout==1 then
      N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t);
    else
      N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t/0.866);
    end if;
    if layout==1 then
      N_cw:=ceil(0.8/P_t*(L_c-(D_s-D_b)/2));
    else
      N_cw:=ceil(0.8/(0.866*P_t)*(L_c-(D_s-D_b)/2));
    end if;

    if layout==1 then
      if noEvent(Re_MS<2300) then
        K_f:=0.272+(0.207e3/Re_MS)+(0.102e3/Re_MS^2)-(0.286e3/Re_MS^3);
      else
        K_f:=0.267+(0.249e4/Re_MS)-(0.927e7/Re_MS^2)+(10^10/Re_MS^3);
      end if;
    else
      if noEvent(Re_MS>4000) then
        K_f:=0.245+(0.339e4/Re_MS)-(0.984e7/Re_MS^2)+(0.133e11/Re_MS^3)-(0.599e13/Re_MS^4);
      else
        K_f:=11.474*Re_MS^(-0.34417);
      end if; 
    end if;
                        //    if noEvent(Re_MS<2300) then
                        //      K_f:=0.795+(0.247e3/Re_MS)+(0.335e4/Re_MS^2)-(0.155e4/Re_MS^3)+(0.241e4/Re_MS^4);
                        //    else
                        //      K_f:=0.245+(0.339e4/Re_MS)-(0.984e7/Re_MS^2)+(0.133e11/Re_MS^3)-(0.599e13/Re_MS^4);
                        //    end if;
  
    Dp_bi:=N_c*K_f*0.5*rho_MS*v_max_MS^2;
    S_b:=L_bb*l_b;
    L_sb:=(3.1+0.004*D_s)/1000;
    theta_ds:=2*acos(1-2*B);
    S_sb:=(D_s/N_sp)*(CN.pi/2)*L_sb*((2*CN.pi-theta_ds)/(2*CN.pi));
    theta_ctl:=2*acos((D_s-2*L_c)/D_b);
    F_w:=theta_ctl/(2*CN.pi)-sin(theta_ctl)/(2*CN.pi);
    F_c:=1-2*F_w;
    S_tb:=(1/N_sp)*(CN.pi/4)*((d_o+L_tb)^2-d_o^2)*N_t*(1-F_w);
    r_s:=S_sb/(S_sb+S_tb);
    r_lm:=(S_sb+S_tb)/S_m;
    xx:=-0.15*(1+r_s)+0.8;
    R_L:=Modelica.Math.exp(-1.23*(1+r_s))*r_lm^xx;
    F_bp:=S_b/S_m;
    r_ss:=N_ss/N_c;
    R_B:=Modelica.Math.exp(-3.7*F_bp*(1-r_ss^(1/3)));
    Dp_c:=Dp_bi*(N-1)*R_B*R_L;
    S_wg:=(CN.pi/4)*(D_s^2/N_sp)*(theta_ds/(2*CN.pi)-sin(theta_ds)/(2*CN.pi));
    S_wt:=(N_t/N_sp)*F_w*(CN.pi/4)*d_o^2;
    S_w:=S_wg-S_wt;
    Dp_w:=(0.2+0.6*N_cw)/(2*S_m*S_w*rho_MS)*m_flow_MS^2;
    Dp_e:=2*Dp_bi*R_B*(1+N_cw/N_c);
    Dp_shell:=N_sp*(((N-1)*Dp_bi*R_B+N*Dp_w)*R_L+Dp_e);
  else
    Dp_shell:=0;
  end if;
end Dp_losses;
