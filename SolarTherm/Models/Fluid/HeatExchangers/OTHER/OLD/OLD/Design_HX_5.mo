within SolarTherm.Models.Fluid.HeatExchangers;
model Design_HX_5

  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import Modelica.Math;
  
  parameter SI.Length d_o=20*10^(-3) "Outer Tube diameter";
  parameter SI.Length L=4 "Tube length";
  parameter Integer N_p=4 "Number of passes";
  parameter Integer layout=1 "Tube layout";
  // if layout=1(one) is square, while if layout=2(two) it is triangular //
  parameter SI.Pressure P_shell=101325 "Shell-side pressure";
  parameter SI.Pressure P_tubes=101325 "Tube-side pressure";
  parameter SI.ThermalConductance UA=396826 "UA";
  parameter SI.MassFlowRate m_flow_Na=400 "Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_MS=85 "Molten-Salt mass flow rate";
  parameter Real c_e(unit = "€/year")=0.13 "Power cost";
  parameter Real r=0.05 "Real interest rate";
  parameter Real CEPCI_18=603.1 "CEPCI 2018";
  parameter Real H_y(unit= "h")=4500 "Operating hours";
  parameter Real M_conv(unit= "€/USD")=0.9175 "Conversion factor";
  parameter SI.ThermalConductivity k_wall=24 "Tube Thermal Conductivity";
  parameter SI.ThermalConductivity k_Na=54.5113 "Sodium Conductivity @mean temperature";
  parameter SI.ThermalConductivity k_MS=0.447185 "Molten Salts Conductivity @mean temperature";
  parameter SI.Density rho_Na=782.473 "Sodium density @mean temperature";
  parameter SI.Density rho_MS=1634.34 "Molten Salts density @mean temperature";
  parameter SI.DynamicViscosity mu_Na=0.000182038 "Sodium dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_MS=0.00341597 "Molten Salts  dynamic viscosity @mean temperature";
  parameter SI.DynamicViscosity mu_Na_wall=0.000182038 "Sodium dynamic viscosity @wall temperature";
  parameter SI.DynamicViscosity mu_MS_wall=0.00260711 "Molten salts dynamic viscosity @wall temperature";
  parameter SI.SpecificHeatCapacity cp_Na=1252.4 "Sodium specific heat capacity @mean temperature";
  parameter SI.SpecificHeatCapacity cp_MS=1072.4 "Molten Salts specific heat capacity @mean temperature";
  
  
  
  SI.Area A_tot(start=4000) "Exchange Area";
  Real N_t(start=31848) "Number of tubes";
  SI.CoefficientOfHeatTransfer U_calc "Heat tranfer coefficient";
  SI.Pressure Dp_tube "Tube-side pressure drop";
  SI.Pressure Dp_shell "Shell-side pressure drop";
  SI.Pressure Dp_tot "Total pressure drop";
  Real TAC(unit= "€/year") "Total Annualized Cost";
  SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  SI.Length D_s(start=4.45004888123442) "Shell Diameter";
  SI.Velocity v_Na "Sodium velocity in tubes";
  SI.Velocity v_max_MS "Molten Salt velocity in shell";
  
  parameter SI.Length t_tube=2.54*10^(-3) "Tube thickness";
  parameter SI.Length d_i=d_o-2*t_tube "Inner Tube diameter";
  parameter SI.CoefficientOfHeatTransfer U_guess=1000 "Heat tranfer coefficient guess";
  parameter SI.Area A_st=CN.pi*d_o*L "Single tube exchange area";
  parameter Real B=0.25 "Baffle cut";
  parameter Real tol=0.15 "Heat transfer coefficient tollerance";
  parameter Real SS=0.2 "Sealing strips per crossflow row";
  parameter SI.Length t_b=t_tube "Baffle thickness";
  parameter SI.Length P_t=1.25*d_o "Tube pitch";
  parameter Real CEPCI_01=397 "CEPCI 2001";
  parameter Real eta_pump=0.75 "Pump efficiency";
  parameter SI.ThermalInsulance R_ss=8.808*10^(-5) "Fouling resistance";
  parameter Integer n=20 "Operating years";
  
  SI.CoefficientOfHeatTransfer U_calc_prev "Heat tranfer coefficient guess";
  Real Tep(start=7962) "Tubes for each pass";
  SI.Area A_cs(start=0.000174834657720518) "Single tube cross section area";
  SI.Area A_cs_tot(start=1.39203354477076) "Total cross section area";
  Real M_Na(unit= "kg/m2/s",start=287.349397220073) "Mass velocity of Na (tube-side)";
  Real Re_Na(start=23551.4178716723) "Na Reynolds Number";
  Real Pr_Na(unit= "") "Na Prandtl Number";
  Real Pe_Na(unit= "") "Na Peclet Number";
  Real A(unit= "") "Correlation coefficient";
  Real Nu_Na(unit= "") "Na Nusselt number";
  Real j_f(unit= "") "Friction factor";
  Real m(unit= "") "Correlation coefficient";
  SI.Length D_b(start=4.42) "Bundle diameter";
  Real KK1(unit= "",start=0.158) "Correlation coefficient";
  Real nn1(unit= "",start=2.263) "Correlation coefficient";
  SI.Length L_bb(start=0.0342502444061721) "Bundle-to-shell diametral clearance";
  SI.Length l_b "Baffle spacing";
  SI.Area S_m(start=1.62588760919663) "Minimal crossflow area at bundle centerline";
  Real Re_MS(start=100) "MS Reynolds Number";
  Real Pr_MS(unit= "") "MS Prandtl Number";
  Real Nu_MS(unit= "") "MS Nusselt Number";
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
  Real r_lm(unit= "") "Non dimensional factor";
  Real r_s(unit= "") "Non dimensional factor";
  Real xx(unit= "") "Non dimensional factor";
  Real J_L(unit= "") "Leakage correction factor";
  Real F_bp(unit= "") "Bypass correction factor";
  Real N_c(start=90) "Number of crossflow rows";
  Real N_ss "Number of sealing strips";
  Real J_B(unit= "") "Bypass correction factor";
  Real condition(unit= "") "When condition";
  Real N_cw "Number of effective crossflow rows in the window zone";
  Real N "Number of baffles";
  Real K_f(unit= "") "Non dimensional factor";
  SI.Area S_w(start=3.04066566915712) "Window flow area";
  SI.Area S_b "Bypass flow area";
  SI.Pressure Dp_c "Ideal crossflow pressure drop";  
  SI.Pressure Dp_w "Pressure drop for the window zone";  
  Real R_B(unit= "") "Non dimensional factor";
  Real R_L(unit= "") "Non dimensional factor";
  Real k1(unit= "") "Non dimensional factor";
  Real k2(unit= "") "Non dimensional factor";
  Real k3(unit= "") "Non dimensional factor";
  SI.Area A_cost "Area for cost function";
  Real C_p0(unit= "USD")  "Bare cost @2001";
  Real C_BM(unit= "USD")  "Bare module cost @operating pressure and with material";
  Real C_BEC(unit= "USD")  "HX Cost @operating area";
  Real C_pump(unit= "€")  "Annual pumping cost";
  Real C1(unit= "") "Non dimensional factor";
  Real C2(unit= "") "Non dimensional factor";
  Real C3(unit= "") "Non dimensional factor";
  Real B1(unit= "") "Non dimensional factor";
  Real B2(unit= "") "Non dimensional factor";
  Real f(unit= "") "Annualization factor";
  Real Fp(unit= "") "Cost pressure factor";
  Real Fm(unit= "") "Cost material factor";
  Boolean both "Condition for pressure factor correlation";
  Real P_tube_cost(unit= "barg") "Tube pressure in barg";
  Real P_shell_cost(unit= "barg") "Shell pressure in barg";
  Real P_cost(unit= "barg") "HX pressure in barg";
  
  algorithm
  U_calc_prev:=U_guess;
  condition:=10;
  
while condition>tol loop
  A_tot:=UA/U_calc_prev;
  N_t:=ceil(A_tot/A_st);
  Tep:=ceil(N_t/N_p);
  N_t:=Tep*N_p;
  A_cs:=CN.pi/4*d_i^2;
  A_cs_tot:=Tep*A_cs;
  M_Na:=m_flow_Na/A_cs_tot;
  v_Na:=M_Na/rho_Na;
  
  //Tube-side heat transfer coefficient:
  Re_Na:=M_Na*d_i/mu_Na;
  Pr_Na:=mu_Na*cp_Na/k_Na;
  Pe_Na:=Re_Na*Pr_Na;
    if Pe_Na<=1000 then
      A:=4.5;
    elseif Pe_Na>=2000 then
      A:=3.6;
    else
      A:=5.4-9*10^(-4)*Pe_Na;
    end if;
  Nu_Na:=A+0.018*Pe_Na;
  h_t:=Nu_Na*k_Na/d_i;
  
  //Shell-side heat transfer coefficient:
    if layout==1 then
      if N_p==4 then
         KK1:=0.158;
         nn1:=2.263;
      elseif N_p==6 then
         KK1:=0.0402;
         nn1:=2.617;
      else
         KK1:=0.0331;
         nn1:=2.643;
      end if;
    else
      if N_p==4 then
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
  L_bb:=(12+5*D_b)/995;
  D_s:=L_bb+D_b;
  l_b:=0.4*D_s;
  S_m:=l_b*(D_s-D_b+(D_b-d_o)*(P_t-d_o)/P_t);
  v_max_MS:=m_flow_MS/rho_MS/S_m;
  Re_MS:=rho_MS*d_o*v_max_MS/mu_MS;
  Pr_MS:=mu_MS*cp_MS/k_MS;
    if layout==1 then
      if Re_MS<=300 then
         aa:=0.742;
         mm:=0.431;
      elseif Re_MS>300 and Re_MS<2*10^5  then
         aa:=0.211;
         mm:=0.651;
      elseif Re_MS>2*10^5 and Re_MS<2*10^6 then
         aa:=0.116;
         mm:=0.7;
      end if;
    else
      if Re_MS<=300 then
         aa:=1.309;
         mm:=0.36;
      elseif Re_MS>300 and Re_MS<2*10^5  then
         aa:=0.273;
         mm:=0.635;
      elseif Re_MS>2*10^5 and Re_MS<2*10^6 then
         aa:=0.124;
         mm:=0.7;
      end if;
    end if;
  Nu_MS:=aa*(Re_MS^mm)*(Pr_MS^0.34)*((mu_MS/mu_MS_wall)^0.26);
  h_s_id:=Nu_MS*k_MS/d_o;
  L_c:=B*D_s;
  F_c:=1/CN.pi*(CN.pi+2*((D_s-2*L_c)/D_b)*sin(acos((D_s-2*L_c)/D_b))-2*acos((D_s-2*L_c)/D_b));
  J_C:=0.55+0.72*F_c;
  L_sb:=(3.1+0.004*D_s)/1000;
  S_sb:=D_s*L_sb*0.5*(CN.pi-acos(1-2*L_c/D_s));
  L_tb:=0.0008;
  S_tb:=CN.pi*d_o*L_tb*0.5*N_t*0.5*(1+F_c);
  r_lm:=(S_sb+S_tb)/S_m;
  r_s:=S_sb/(S_sb+S_tb);
  xx:=-0.15*(1+r_s)+0.8;
  J_L:=0.44/(1-r_s)+(1-0.44*(1-r_s))*Modelica.Math.exp(-2.2*r_lm);
  F_bp:=(D_s-D_b)*l_b/S_m;
    if layout==1 then
      N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t);
      else
      N_c:=ceil(D_s*(1-2*L_c/D_s)/P_t/0.866);
    end if;
  N_ss:=ceil(0.2*N_c);
  J_B:=Modelica.Math.exp(-1.35*F_bp*(1-2*r_s)^(1/3));
  h_s:=h_s_id*J_C*J_L*J_B;
  
  //Global heat transfer coefficient:
  U_calc:=(1/h_s+R_ss+1/h_t*d_o/d_i+d_o*0.5/k_wall*log(d_o/d_i))^(-1);
  condition:=abs(U_calc-U_calc_prev)/U_calc_prev;
  U_calc_prev:=U_calc;
end while;

equation
  //Tube-side pressure drop:
    if Re_Na<=855 then
      j_f=8.1274*Re_Na^(-1.011);
    else
      j_f=0.046*Re_Na^(-0.244);
    end if;
    if Re_Na<=2100 then
      m=0.25;
    else
      m=0.14;
    end if;
  Dp_tube=N_p*(2.5+8*j_f*(L/d_i)*(mu_Na/mu_Na_wall)^(-m))*0.5*rho_Na*v_Na^2;
  
  //Shell-side pressure drop:
  N_cw=ceil(0.8*L_c/P_t);
    if layout==1 then
      if Re_MS<=2300 then
           K_f=0.272+(0.207*10^3/Re_MS)+(0.102*10^3/Re_MS^2)-(0.286*10^3/Re_MS^3);
        //elseif Re_MS>2300 and Re_MS<2*10^6  then
        else
           K_f=0.267+(0.249*10^4/Re_MS)-(0.927*10^7/Re_MS^2)+(10^10/Re_MS^3);
      end if;
      else
        if Re_MS<=2300 then
             K_f=0.795+(0.247*10^3/Re_MS)+(0.335*10^4/Re_MS^2)-(0.155*10^4/Re_MS^3)+(0.241*10^4/Re_MS^4);
          //elseif Re_MS>2300 and Re_MS<2*10^6  then
          else
             K_f=0.245+(0.339*10^4/Re_MS)-(0.984*10^7/Re_MS^2)+(0.133*10^11/Re_MS^3)-(0.599*10^13/Re_MS^4);
        end if;
    end if;
  Dp_c=N_c*K_f*0.5*rho_MS*v_max_MS^2;
  N=ceil(L/(l_b+t_b)-1);
  S_w=D_s^2/4*(acos(1-(2*L_c/D_s))-(1-(2*L_c/D_s))*(1-(1-(2*L_c/D_s))^2)^0.5)-N_t/8*(1-F_c)*CN.pi*d_o^2;
  Dp_w=(0.2+0.6*N_cw)/(2*S_m*S_w*rho_MS)*m_flow_MS;
  S_b=L_bb*l_b;
  R_B=Modelica.Math.exp(-3.7*S_b/S_m*(1-r_s^(1/3)));
  R_L=Modelica.Math.exp(-1.23*(1+r_s))*r_lm^xx;
  Dp_shell=((N-1)*Dp_c*R_B+N*Dp_w)*R_L+2*Dp_c*R_B*(1+N_cw/N_c);
  
  //Total pressure drop:
  Dp_tot=Dp_shell+Dp_tube;
  
  //Cost function
  P_tube_cost=(P_tubes/10^5)-1;
  P_shell_cost=(P_shell/10^5)-1;
  if ((P_tube_cost>5 and P_shell_cost>5)or(P_tube_cost<5 and P_shell_cost>5)) then
    both=true;
    P_cost=max(P_tube_cost,P_shell_cost);
    else
    both=false;
    P_cost=P_tube_cost;
  end if;
  k1=4.3247;
  k2=-0.3030;
  k3=0.1634;
  if both then
        C1=0.03881;
        C2=-0.11272;
        C3=0.08183;
    else
    if P_cost<5 then
      C1=0;
      C2=0;
      C3=0;
      else
        C1=-0.00164;
        C2=-0.00627;
        C3=0.0123;
    end if;
  end if;
  Fp=10^(C1+C2*log10(P_cost)+C3*(log10(P_cost))^2);
  Fm=3.7;
  B1=1.63;
  B2=1.66;
  if A_tot>1000 then
    A_cost=1000;    
    elseif A_tot<10 then
    A_cost=10;    
    else
    A_cost=A_tot;    
  end if;
  C_p0=10^(k1+k2*log10(A_cost)+k3*(log10(A_cost))^2);
  C_BM=C_p0*(CEPCI_18/CEPCI_01)*(B1+B2*Fm*Fp);
  C_BEC=C_BM*(A_tot/A_cost)^0.6;
  C_pump=c_e*H_y/eta_pump*(m_flow_MS*Dp_shell/rho_MS+m_flow_Na*Dp_tube/rho_Na);
  f=(r*(1+r)^n)/((1+r)^n-1);
  TAC=f*C_BEC*M_conv+C_pump;


end Design_HX_5;