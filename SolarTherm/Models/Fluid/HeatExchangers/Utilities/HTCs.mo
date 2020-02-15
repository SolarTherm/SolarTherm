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
  input SI.Length L "Tube length";
  input SI.Length l_b "Baffle spacing";
   
  output SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  
  protected
  parameter SI.ThermalInsulance R_ss=8.808e-5 "Fouling resistance";
  parameter SI.Length d_i=d_o-2*t_tube "Inner Tube diameter";
  SI.ThermalConductivity k_wall "Tube Thermal Conductivity";
  SI.Density rho_wall "HX material density";
  SI.Temperature Tm_wall "Mean Wall Temperature";
  parameter SI.Length t_tube=TubeThickness(d_o) "Tube thickness";
  
  //Tube-side heat transfer coefficient:
  SI.Temperature Tm_Na "Na Mean Temperature";
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  Integer Tep(start=7962) "Tubes for each pass";
  SI.Area A_cs(start=0.000174834657720518) "Single tube cross section area";
  SI.Area A_cs_tot(start=1.39203354477076) "Total cross section area";
  Real M_Na(unit= "kg/m2/s",start=287.349397220073,min=0) "Mass velocity of Na (tube-side)";
  Real Re_Na(start=23551.4178716723,min=0) "Na Reynolds Number";
  Real Pr_Na(unit= "",min=0) "Na Prandtl Number";
  Real Pe_Na(unit= "",min=0) "Na Peclet Number";
  Real A(unit= "") "Correlation coefficient";
  Real Nu_Na(unit= "",min=0) "Na Nusselt number";
  
  //Shell-side heat transfer coefficient:
  SI.Temperature Tm_MS "MS Mean Temperature";
  SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  SI.Density rho_MS "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  SI.Length D_s "Shell Diameter";
  SI.Velocity v_max_MS(min=0) "Molten Salt velocity in shell";
  parameter SI.Length P_t=1.25*d_o "Tube pitch";
  parameter Real B=0.25 "Baffle cut";
  SI.Length D_b(start=4.42) "Bundle diameter";
  Real KK1(unit= "",start=0.158) "Correlation coefficient";
  Real nn1(unit= "",start=2.263) "Correlation coefficient";
  SI.Length L_bb(start=0.0342502444061721) "Bundle-to-shell diametral clearance";
  SI.Area S_m(start=1.62588760919663) "Minimal crossflow area at bundle centerline";
  SI.Area S_b "Bypass flow area";
  Real Re_MS(start=100,min=0) "MS Reynolds Number";
  Real Pr_MS(unit= "",min=0) "MS Prandtl Number";
  Real Nu_MS(unit= "",min=0) "MS Nusselt Number";
  Real aa(unit= "") "Correlation coefficient";
  Real mm(unit= "") "Correlation coefficient";
  SI.CoefficientOfHeatTransfer h_s_id "Ideal shell-side Heat tranfer coefficient";
  SI.Length L_c(start=1.11251222030861) "Baffle length";
  Real F_c(unit= "") "Fraction of tubes in crossflow";
  Real J_C(unit= "") "Configuration correction factor";
  SI.Length L_sb "Shell-to-baffle diametral clearance";
  SI.Area S_sb "Shell-to-baffle leakage area";
  SI.Area S_tb "Tube-to-baffle leakage area";
  SI.Length L_tb "Tube-to-baffle diametral clearance";
  SI.Angle theta_ds "Centriangle of baffle cut";
  SI.Angle theta_ctl "Upper centriangle of baffle cut";
  Real r_lm(unit= "") "Non dimensional factor";
  Real r_s(unit= "") "Non dimensional factor";
  Real xx(unit= "") "Non dimensional factor";
  Real J_L(unit= "") "Leakage correction factor";
  Real F_bp(unit= "") "Bypass correction factor";
  Real F_w(unit= "") "Fraction of tubes in crossflow";
  Real N_c(start=90) "Number of crossflow rows";
  //Integer N_calc "Number of Baffles calculated";
//  Integer N "Number of baffles";
  Real r_ss "Fraction";
  parameter Real N_ss=0.2 "Number of sealing strips per crossflow row";
  Real J_B(unit= "") "Bypass correction factor";
  SI.Length t_baffle "Baffle thickness";

algorithm
  
  //Tube-side heat transfer coefficient:
  Tm_Na:=Medium1.temperature(state_mean_Na);
  rho_Na:=Medium1.density(state_mean_Na);
  cp_Na:=Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na:=Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall:=mu_Na;
  k_Na:=Medium1.thermalConductivity(state_mean_Na);
  Tep:=integer(ceil(N_t/N_p));
  A_cs:=CN.pi/4*d_i^2;
  A_cs_tot:=Tep*A_cs;
  M_Na:=m_flow_Na/A_cs_tot;
  Re_Na:=M_Na*d_i/mu_Na;
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
  
  //Shell-side heat transfer coefficient:
  Tm_MS:=Medium2.temperature(state_mean_MS);
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
    else
       KK1:=0.0365;
       nn1:=2.675;
    end if;
  end if;
  D_b:=(N_t/KK1)^(1/nn1)*d_o;
  L_bb:=(12+5*(D_b+d_o))/995;
  D_s:=L_bb+D_b+d_o;  
  S_m:=(l_b/N_sp)*(L_bb+(D_b/P_t)*(P_t-d_o));
  v_max_MS:=m_flow_MS/rho_MS/S_m;
  Re_MS:=rho_MS*d_o*v_max_MS/mu_MS;
  Pr_MS:=mu_MS*cp_MS/k_MS;
  if noEvent(Re_MS>0) then
      if layout==1 then
        if noEvent(Re_MS<=300) then
           aa:=0.742;
           mm:=0.431;
        elseif noEvent(Re_MS>300) and noEvent(Re_MS<2e5)  then
           aa:=0.211;
           mm:=0.651;
        elseif noEvent(Re_MS>2e5) and noEvent(Re_MS<2e6) then
           aa:=0.116;
           mm:=0.7;
        end if;
      else
        if noEvent(Re_MS<=300) then
           aa:=1.309;
           mm:=0.36;
        elseif noEvent(Re_MS>300) and noEvent(Re_MS<2e5)  then
           aa:=0.273;
           mm:=0.635;
        elseif noEvent(Re_MS>2e5) and noEvent(Re_MS<2e6) then
           aa:=0.124;
           mm:=0.7;
        end if;
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
      J_L:=0.44*(1-r_s)+(1-0.44*(1-r_s))*Modelica.Math.exp(-2.2*r_lm);
      S_b:=L_bb*l_b;
      F_bp:=S_b/S_m;
      if layout==1 then
        N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t);
        else
        N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t/0.866);
      end if;
      r_ss:=N_ss/N_c;
      J_B:=Modelica.Math.exp(-1.35*F_bp*(1-(2*r_s)^(1/3)));
      h_s:=h_s_id*J_C*J_L*J_B;  
    else
      h_s:=0;
    end if;
  
  //Global heat transfer coefficient:
  Tm_wall:=(Tm_MS+Tm_Na)/2;
  (k_wall, rho_wall):=Haynes230_BaseProperties(Tm_wall);
  if noEvent(Re_Na==0) or noEvent(Re_MS==0) then
    U:=0;
  else
    U:=(1/h_s+R_ss+1/h_t*d_o/d_i+d_o*0.5/k_wall*log(d_o/d_i))^(-1);
  end if;

end HTCs;
