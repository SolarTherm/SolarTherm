within SolarTherm.Models.Fluid.HeatExchangers;
model HX_sa_graphs_allvariables
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  import UF = SolarTherm.Models.Fluid.HeatExchangers.Utilities;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Currency;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  //Design Parameters
  parameter SI.HeatFlowRate Q_d_des = 50e6 "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1_des = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1_des = 500 + 273.15 "Desing Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2_des = 720 + 273.15 "Desing Molten Salt Hot Fluid Temperature";
  parameter SI.Pressure p_Na1_des = 101325 "Design Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1_des = 101325 "Design Molten Salt Inlet Pressure";
  
  //Input parameters
  parameter SI.Length d_o_input = 0.01588 "Optimal Outer Tube Diameter";
  parameter SI.Length L_input = 8 "Optimal Tube Length";
  parameter Integer N_p_input = 1 "Optimal Tube passes number";
  parameter Integer layout_input = 2 "Optimal Tube Layout";
  parameter SI.Temperature T_Na2_input = 560 + 273.15 "Optimal outlet sodium temperature";
  
  //Optimal Parameter Values
  parameter FI.MoneyPerYear TAC(fixed = false) "Minimum Total Annualized Cost";
  parameter SI.Area A_HX(fixed = false) "Optimal Exchange Area";
  parameter SI.CoefficientOfHeatTransfer U_design(fixed = false) "Optimal Heat tranfer coefficient";
  parameter Integer N_t(fixed = false) "Optimal Number of tubes";
  parameter SI.Pressure Dp_tube_design(fixed = false) "Optimal Tube-side pressure drop";
  parameter SI.Pressure Dp_shell_design(fixed = false) "Optimal Shell-side pressure drop";
  parameter SI.CoefficientOfHeatTransfer h_s_design(fixed = false) "Optimal Shell-side Heat tranfer coefficient";
  parameter SI.CoefficientOfHeatTransfer h_t_design(fixed = false) "Optimal Tube-side Heat tranfer coefficient";
  parameter SI.Length D_s(fixed = false) "Optimal Shell Diameter";
  parameter Integer N_baffles(fixed = false) "Number of Baffles"; //Should be N
  parameter SI.Velocity v_Na_design(fixed = false) "Optimal Sodium velocity in tubes";
  parameter SI.Velocity v_max_MS_design(fixed = false) "Optimal Molten Salt velocity in shell";
  parameter SI.Volume V_HX(fixed = false) "Optimal Heat-Exchanger Total Volume";
  parameter SI.Mass m_HX(fixed = false) "Optimal Heat-Exchanger Total Mass";
  parameter SI.Mass m_material_HX(fixed = false) "Optimal HX Material Mass";
  parameter FI.Money_USD C_BEC_HX(fixed = false) "Optimal Bare cost @2018";
  parameter FI.MoneyPerYear C_pump_design(fixed = false) "Optimal Annual pumping cost";
  parameter SI.Length d_o(fixed = false) "Optimal Outer Tube Diameter";
  parameter SI.Length L(fixed = false) "Optimal Tube Length";
  parameter Integer N_p(fixed = false) "Optimal Tube passes number";
  parameter Integer layout(fixed = false) "Optimal Tube Layout";
  parameter SI.Temperature T_Na2_design(fixed = false) "Optimal outlet sodium temperature";
  parameter SI.MassFlowRate m_flow_Na_design(fixed = false) "Optimal Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_MS_design(fixed = false) "Optimal Molten-Salt mass flow rate";
  parameter Real F_design(fixed = false) "Optimal Temperature correction factor";
  parameter SI.ThermalConductance UA_design(fixed = false) "Optimal UA";
  parameter Real ex_eff_design(fixed = false) "Optimal HX Exergetic Efficiency";
  parameter Real en_eff_design(fixed = false) "Optimal HX Energetic Efficiency";
  
  //Wall Parameters
  parameter SI.ThermalConductivity k_wall(fixed = false) "Tube Thermal Conductivity";
  parameter SI.Density rho_wall(fixed = false) "HX material density";
  parameter SI.Temperature Tm_wall(fixed = false) "Mean Wall Temperature";
  
  //Tube Side  
  parameter SI.Area A_st(fixed=false) "Single tube exchange area";
  parameter SI.Length d_i(fixed=false) "Inner Tube diameter";
  parameter Integer Tep(fixed = false) "Tubes for each pass";
  parameter SI.Area A_cs(fixed=false) "Single tube cross section area";
  parameter SI.Area A_cs_tot(fixed=false) "Total cross section area";
  parameter Real M_Na(unit= "kg/m2/s", fixed=false) "Mass velocity of Na (tube-side)";
  parameter Real Re_Na(fixed=false) "Na Reynolds Number";
  parameter Real Pr_Na(fixed=false) "Na Prandtl Number";
  parameter Real Pe_Na(fixed=false) "Na Peclet Number";
  parameter Real A(fixed=false) "Correlation coefficient";
  parameter Real Nu_Na(fixed=false) "Na Nusselt number";
  parameter Real j_f(fixed=false) "Friction factor";
  parameter Real m(fixed=false) "Correlation coefficient";
  
  //Shell Side
  parameter Real B=0.25 "Baffle cut";
  parameter Real N_ss=0.2 "Number of sealing strips per crossflow row";
  parameter SI.Length L_tb=0.0008 "Tube-to-baffle diametral clearance";
  parameter Real KK1(fixed = false) "Correlation coefficient";
  parameter Real nn1(fixed = false) "Correlation coefficient";
  parameter SI.Length L_bb(fixed = false) "Bundle-to-shell diametral clearance";
  parameter SI.Length D_b(fixed = false) "Bundle diameter";
  parameter SI.Length D_s_out(fixed=false) "Shell Outer Diameter";
  parameter SI.Length P_t(fixed=false)  "Tube pitch";
  parameter SI.Length t_b(fixed=false) "Baffle thickness";
  parameter SI.Length l_b(fixed=false) "Baffle spacing";
  parameter SI.Area S_m(fixed=false) "Minimal crossflow area at bundle centerline";
  parameter SI.Area S_b(fixed=false) "Bypass flow area";
  parameter Real Re_MS(fixed=false) "MS Reynolds Number";
  parameter Real Pr_MS(fixed=false) "MS Prandtl Number";
  parameter Real Nu_MS(fixed=false) "MS Nusselt Number";
  parameter Real aa(fixed=false) "Correlation coefficient";
  parameter Real mm(fixed=false) "Correlation coefficient";
  parameter SI.CoefficientOfHeatTransfer h_s_id(fixed=false) "Ideal shell-side Heat tranfer coefficient";
  parameter SI.Length L_c(fixed=false) "Baffle length";
  parameter Real F_c(fixed=false) "Fraction of tubes in crossflow";
  parameter Real J_C(fixed=false) "Configuration correction factor";
  parameter SI.Length L_sb(fixed=false) "Shell-to-baffle diametral clearance";
  parameter SI.Area S_sb(fixed=false) "Shell-to-baffle leakage area";
  parameter SI.Area S_tb(fixed=false) "Tube-to-baffle leakage area";
  parameter SI.Angle theta_ds(fixed=false) "Centriangle of baffle cut";
  parameter SI.Angle theta_ctl(fixed=false) "Upper centriangle of baffle cut";
  parameter Real r_lm(fixed=false) "Non dimensional factor";
  parameter Real r_s(fixed=false) "Non dimensional factor";
  parameter Real r_ss(fixed=false) "Non dimensional factor";
  parameter Real xx(fixed=false) "Non dimensional factor";
  parameter Real J_L(fixed=false) "Leakage correction factor";
  parameter Real F_bp(fixed=false) "Bypass correction factor";
  parameter Real F_w(fixed=false) "Fraction of tubes in crossflow";
  parameter Real N_c(fixed=false) "Number of crossflow rows";
  parameter Integer N_calc(fixed=false) "Number of Baffles calculated";
  parameter Real J_B(fixed=false) "Bypass correction factor";
  parameter Integer N_sp(fixed = false) "Number of Shell-Passes";
  parameter Real R_B(fixed = false) "Non dimensional factor";
  parameter Real R_L(fixed = false) "Non dimensional factor";
  parameter Real N_cw(fixed = false) "Number of effective crossflow rows in the window zone";
  parameter Real K_f(fixed = false) "Non dimensional factor";
  parameter SI.Area S_wg(fixed = false) "Window flow area";
  parameter SI.Area S_wt(fixed = false) "Window flow area";
  parameter SI.Area S_w(fixed = false) "Window flow area";
  
  //Other Pressure Losses
  parameter SI.Pressure Dp_c(fixed = false) "Ideal crossflow pressure drop";  
  parameter SI.Pressure Dp_w(fixed = false) "Pressure drop for the window zone";
  parameter SI.Pressure Dp_bi(fixed = false) "Pressure drop base";
  parameter SI.Pressure Dp_e(fixed = false) "Pressure drop base";

  //Cost Function
  parameter FI.EnergyPrice_kWh c_e(fixed=false) "Power cost";
  parameter Real r(fixed=false) "Real interest rate";
  parameter Real H_y(unit= "h", fixed=false) "Operating hours";
  parameter Real CEPCI_01=397 "CEPCI 2001";
  parameter Real CEPCI_18=603.1 "CEPCI 2018";
  parameter Real M_conv = if currency == Currency.USD then 1 else 0.9175 "Conversion factor";
  parameter Real eta_pump=0.75 "Pump efficiency";
  parameter Integer n=20 "Operating years";
  parameter Real k1(fixed=false) "Non dimensional factor";
  parameter Real k2(fixed=false) "Non dimensional factor";
  parameter Real k3(fixed=false) "Non dimensional factor";
  parameter SI.Area A_cost(fixed=false) "Area for cost function";
  parameter FI.Money_USD C_BM(fixed=false)  "Bare module cost @operating pressure and with material";
  parameter FI.Money_USD C_p0(fixed=false)  "Bare module cost @2001";
  parameter Real C1(fixed=false) "Non dimensional factor";
  parameter Real C2(fixed=false) "Non dimensional factor";
  parameter Real C3(fixed=false) "Non dimensional factor";
  parameter Real B1(fixed=false) "Non dimensional factor";
  parameter Real B2(fixed=false) "Non dimensional factor";
  parameter Real f(fixed=false) "Annualization factor";
  parameter Real Fp(fixed=false)"Cost pressure factor";
  parameter Real Fm(fixed=false)"Cost material factor";
  parameter Boolean both(fixed=false) "Condition for pressure factor correlation";
  parameter SI.Pressure P_shell(fixed=false) "Shell-side pressure";
  parameter SI.Pressure P_tubes(fixed=false) "Tube-side pressure";
  parameter Real P_tube_cost(unit= "barg", fixed=false) "Tube pressure in barg";
  parameter Real P_shell_cost(unit= "barg", fixed=false) "Shell pressure in barg";
  parameter Real P_cost(unit= "barg", fixed=false) "HX pressure in barg";
  
  //Other Parameters
  parameter SI.CoefficientOfHeatTransfer U_guess(fixed=false) "Heat tranfer coefficient guess";
  parameter SI.CoefficientOfHeatTransfer U_calc(fixed=false) "Heat tranfer coefficient guess";
  parameter Real tol=0.01 "Heat transfer coefficient tollerance";
  parameter Real condition(fixed=false) "When condition";
  parameter SI.CoefficientOfHeatTransfer U_calc_prev(fixed=false) "Heat tranfer coefficient guess";
  parameter SI.Length t_tube(fixed=false) "Tube thickness";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter SI.ThermalInsulance R_ss=8.808e-5 "Fouling resistance";
  
  //Volume_and_Weight
  parameter SI.Mass m_Na(fixed=false) "Mass of Sodium";
  parameter SI.Mass m_MS(fixed=false)"Mass of Molten Salts";
  parameter SI.Volume V_Na(fixed=false) "Volume of Sodium";
  parameter SI.Volume V_MS(fixed=false) "Volume of Molten Salt";
  parameter SI.Volume V_material(fixed=false) "Volume of HX material";
  parameter SI.Volume V_min(fixed=false) "Minimum HX Volume";
  parameter SI.Volume DV(fixed=false) "Volume difference";
  
  //Fluid Properties
  parameter SI.Temperature Tm_Na(fixed = false) "Mean Sodium Fluid Temperature";
  parameter SI.ThermalConductivity k_Na(fixed = false) "Sodium Conductivity @mean temperature";
  parameter SI.Density rho_Na(fixed = false) "Sodium density @mean temperature";
  parameter SI.DynamicViscosity mu_Na(fixed = false) "Sodium dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_Na_wall(fixed = false) "Sodium dynamic viscosity @wall temperature";
  parameter SI.SpecificHeatCapacity cp_Na(fixed = false) "Sodium specific heat capacity @mean temperature";
  parameter SI.SpecificEnthalpy h_Na1(fixed = false) "Sodium specific enthalpy @inlet temperature";
  parameter SI.SpecificEnthalpy h_Na2(fixed = false) "Sodium specific enthalpy @outlet temperature";
  parameter SI.SpecificEntropy s_Na1(fixed = false) "Sodium specific entropy @inlet temperature";
  parameter SI.SpecificEntropy s_Na2(fixed = false) "Sodium specific entropy @outlet temperature";
  parameter SI.Temperature Tm_MS(fixed = false) "Mean Molten Salts Fluid Temperature";
  parameter SI.ThermalConductivity k_MS(fixed = false) "Molten Salts Conductivity @mean temperature";
  parameter SI.Density rho_MS(fixed = false) "Molten Salts density @mean temperature";
  parameter SI.DynamicViscosity mu_MS(fixed = false) "Molten Salts  dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_MS_wall(fixed = false) "Molten salts dynamic viscosity @wall temperature";
  parameter SI.SpecificHeatCapacity cp_MS(fixed = false) "Molten Salts specific heat capacity @mean temperature";
  parameter SI.SpecificEnthalpy h_MS1(fixed = false) "Molten Salt specific enthalpy @inlet temperature";
  parameter SI.SpecificEnthalpy h_MS2(fixed = false) "Molten Salt specific enthalpy @outlet temperature";
  parameter SI.SpecificEntropy s_MS1(fixed = false) "Molten Salt specific entropy @inlet temperature";
  parameter SI.SpecificEntropy s_MS2(fixed = false) "Molten Salt specific entropy @outlet temperature";

  //Temperature differences
  parameter SI.TemperatureDifference DT1(fixed = false) "Sodium-Molten Salt temperature difference 1";
  parameter SI.TemperatureDifference DT2(fixed = false) "Sodium-Molten Salt temperature difference 2";
  parameter SI.TemperatureDifference LMTD(fixed = false) "Logarithmic mean temperature difference";

  
initial algorithm
  d_o := d_o_input;
  L := L_input;
  N_p := N_p_input;
  layout := layout_input;
  T_Na2_design := T_Na2_input;
  A_st:=CN.pi*d_o*L;
  t_tube:=UF.TubeThickness(d_o);
  d_i:=d_o-2*t_tube;
  U_guess:=1200;
  t_b:=t_tube;
  H_y:=4500;
  c_e:=0.13/0.9175;
  r:= 0.05;
  P_t:=1.25*d_o;
  N_sp:=N_p;
  
  Tm_Na:=(T_Na1_des+T_Na2_design)/2;
  Tm_MS:=(T_MS1_des+T_MS2_des)/2;
  Tm_wall:=(Tm_MS+Tm_Na)/2;
  
  (k_Na, rho_Na, mu_Na, mu_Na_wall, cp_Na, h_Na1, h_Na2, s_Na1, s_Na2, k_MS, rho_MS, mu_MS, mu_MS_wall, cp_MS, h_MS1, h_MS2, s_MS1, s_MS2):=UF.prop_fluids(T_Na1_des, T_Na2_design, T_MS1_des, T_MS2_des, p_Na1_des, p_MS1_des);
  
  DT1:=T_Na1_des-T_MS2_des;
  DT2:=T_Na2_design-T_MS1_des;
  if abs(DT1-DT2)<1e-6 then
    LMTD:=DT1;
  else
    LMTD:=(DT1-DT2)/MA.log(DT1 / DT2);
  end if;
  m_flow_Na_design:=Q_d_des/(cp_Na*(T_Na1_des-T_Na2_design));
  m_flow_MS_design:=Q_d_des/(cp_MS*(T_MS2_des - T_MS1_des));
  F_design:=1;
  UA_design:=Q_d_des/(F_design*LMTD);
  ex_eff_design:=(m_flow_MS_design*((h_MS2-h_MS1)-(25+273.15)*cp_MS*(MA.log(T_MS2_des/T_MS1_des))))/(m_flow_Na_design*((h_Na1-h_Na2)-(25+273.15)*cp_Na*(MA.log(T_Na1_des/T_Na2_design))));
  if (cp_Na*m_flow_Na_design)>(cp_MS*m_flow_MS_design) then
    en_eff_design:=(T_MS2_des-T_MS1_des)./(T_Na1_des-T_MS1_des);
  else
    en_eff_design:=(T_Na1_des-T_Na2_design)./(T_Na1_des-T_MS1_des);
  end if;
  
  U_calc_prev:=U_guess;
  condition:=10;
  
while noEvent(condition>tol) loop
  A_HX:=UA_design/U_calc_prev;
  N_t:=integer(ceil(A_HX/A_st));
  Tep:=integer(ceil(N_t/N_p));
  N_t:=Tep*N_p;
  
  A_cs:=CN.pi/4*d_i^2;
  A_cs_tot:=Tep*A_cs;
  M_Na:=m_flow_Na_design/A_cs_tot;
  v_Na_design:=M_Na/rho_Na;
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
    h_t_design:=Nu_Na*k_Na/d_i;
  else
    h_t_design:=0;
  end if;
  
  //Shell-side heat transfer coefficient:
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
  l_b:=D_s;
  N_calc:=integer(ceil((L/(l_b+t_b)-1)*N_sp));
  N_baffles:= if N_calc<10 then 10 else N_calc;
  l_b:=L/(N_baffles/N_sp+1);
  S_m:=(l_b/N_sp)*(L_bb+(D_b/P_t)*(P_t-d_o));
  v_max_MS_design:=m_flow_MS_design/rho_MS/S_m;
  Re_MS:=rho_MS*d_o*v_max_MS_design/mu_MS;
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
      h_s_design:=h_s_id*J_C*J_L*J_B;  
    else
      h_s_design:=0;
    end if;
  
  //Global heat transfer coefficient:
  (k_wall, rho_wall):=UF.Haynes230_BaseProperties(Tm_wall);
  if noEvent(Re_Na==0) or noEvent(Re_MS==0) then
    U_calc:=0;
  else
    U_calc:=(1/h_s_design+R_ss+1/h_t_design*d_o/d_i+d_o*0.5/k_wall*log(d_o/d_i))^(-1);
  end if;
  condition:=abs(U_calc-U_calc_prev)/U_calc_prev;
  U_calc_prev:=U_calc;
end while;
  U_design:=U_calc;
  
  //Pressure Losses
  //Tube-side pressure drop:
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
    Dp_tube_design:=(N_p*(2.5+8*j_f*(L/d_i)*(mu_Na/mu_Na_wall)^(-m)))*0.5*rho_Na*v_Na_design^2;
  else
    Dp_tube_design:=0;
  end if;
  
  //Shell-side pressure drop:  
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

    Dp_bi:=N_c*K_f*0.5*rho_MS*v_max_MS_design^2;    
    R_L:=Modelica.Math.exp(-1.23*(1+r_s))*r_lm^xx;
    R_B:=Modelica.Math.exp(-3.7*F_bp*(1-r_ss^(1/3)));
    Dp_c:=Dp_bi*(N_baffles-1)*R_B*R_L;
    S_wg:=(CN.pi/4)*(D_s^2/N_sp)*(theta_ds/(2*CN.pi)-sin(theta_ds)/(2*CN.pi));
    S_wt:=(N_t/N_sp)*F_w*(CN.pi/4)*d_o^2;
    S_w:=S_wg-S_wt;
    Dp_w:=(0.2+0.6*N_cw)/(2*S_m*S_w*rho_MS)*m_flow_MS_design^2;
    Dp_e:=2*Dp_bi*R_B*(1+N_cw/N_c);
    Dp_shell_design:=N_sp*(((N_baffles-1)*Dp_bi*R_B+N_baffles*Dp_w)*R_L+Dp_e);
  else
    Dp_shell_design:=0;
  end if;

  //Volume and Mass HX
  D_s_out:=D_s+0.01; //1cm external thickness
  V_min:=CN.pi/4*(D_s^2)*L;
  V_Na:=CN.pi/4*(d_i^2)*L*N_t;
  V_MS:=(D_s^2-(d_o^2)*N_t)*CN.pi/4*L;
  DV:=V_min-V_Na-V_MS;
  V_material:=DV+(D_s_out^2-(D_s^2))*CN.pi/4*L;
  V_HX:=V_material+V_MS+V_Na;
  (k_wall, rho_wall):=UF.Haynes230_BaseProperties(Tm_wall);
  m_Na:=V_Na*rho_Na;
  m_MS:=V_MS*rho_MS;
  m_material_HX:=V_material*rho_wall;
  m_HX:=m_material_HX+m_MS+m_Na;
  
  //Cost function
  P_shell:=p_MS1_des;
  P_tubes:=p_Na1_des;
  P_tube_cost:=(P_tubes/10^5)-1;
  P_shell_cost:=(P_shell/10^5)-1;
  if ((P_tube_cost>5 and P_shell_cost>5)or(P_tube_cost<5 and P_shell_cost>5)) then
    both:=true;
    P_cost:=max(P_tube_cost,P_shell_cost);
    else
    both:=false;
    P_cost:=P_tube_cost;
  end if;
  k1:=4.3247;
  k2:=-0.3030;
  k3:=0.1634;
  if both then
        C1:=0.03881;
        C2:=-0.11272;
        C3:=0.08183;
    else
    if P_cost<5 then
      C1:=0;
      C2:=0;
      C3:=0;
      else
        C1:=-0.00164;
        C2:=-0.00627;
        C3:=0.0123;
    end if;
  end if;
  Fp:=10^(C1+C2*log10(P_cost)+C3*(log10(P_cost))^2);
  Fm:=3.7;
  B1:=1.63;
  B2:=1.66;
  if noEvent(A_HX>1000) then
    A_cost:=1000;    
    elseif noEvent(A_HX<10) then
    A_cost:=10;    
    else
    A_cost:=A_HX;    
  end if;
  C_p0:=10^(k1+k2*log10(A_cost)+k3*(log10(A_cost))^2);
  C_BM:=C_p0*(CEPCI_18/CEPCI_01)*(B1+B2*Fm*Fp);
  C_BEC_HX:=C_BM*M_conv*(A_HX/A_cost)^0.7;
  C_pump_design:=c_e*H_y/eta_pump*(m_flow_MS_design*Dp_shell_design/rho_MS+m_flow_Na_design*Dp_tube_design/rho_Na)/(1000);
  f:=(r*(1+r)^n)/((1+r)^n-1);
  if (v_max_MS_design<0.49 or v_max_MS_design>1.51 or v_Na_design<0.99 or v_Na_design>3) then
    TAC:=10e10;
  else
    if noEvent(C_BEC_HX>0) and noEvent(C_pump_design>0) then
      TAC:=f*C_BEC_HX+C_pump_design;
    else
      TAC:=10e10;
    end if;
  end if;

end HX_sa_graphs_allvariables;