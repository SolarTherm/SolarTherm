within SolarTherm.Models.Fluid.HeatExchangers.Utilities;
function Design_HX
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Currency;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  input SI.HeatFlowRate Q_d "Design Heat Flow Rate";
  input SI.Temperature T_Na1 "Desing Sodium Hot Fluid Temperature";
  input SI.Temperature T_MS1 "Desing Molten Salt Cold Fluid Temperature";
  input SI.Temperature T_MS2 "Desing Molten Salt Hot Fluid Temperature";
  input SI.Length d_o "Outer Tube diameter";
  input Integer N_p "Number of passes";
  input Integer N_sp "Number of passes";
  input Integer layout "Tube layout"; // if layout=1(one) is square, while if layout=2(two) it is triangular //
  input SI.Temperature T_Na2 "Sodium Cold Fluid Temperature";
  input SI.Pressure p_Na1 "Sodium Inlet Pressure";
  input SI.Pressure p_MS1 "Molten Salt Inlet Pressure";
  input FI.EnergyPrice_kWh c_e "Power cost";
  input Real r "Real interest rate";
  input Real H_y(unit = "h") "Operating hours";
  input Integer n(unit = "h") "Operating years";
  input FI.MassPrice material_sc /*= 84*/ "Material HX Specific Cost";
  input Real ratio_max "Maximum L/D_s ratio";
  input Boolean ratio_cond "Activate ratio constraint";
  input Boolean L_max_cond "Activate maximum HX length constraint";
  input SI.Length L_max_input "Maximum HX length";
  input Boolean N_t_input_on "Activate maximum HX length constraint";
  input Integer N_t_input "Number of tubes";
  
  output SI.MassFlowRate m_flow_Na "Sodium mass flow rate";
  output SI.MassFlowRate m_flow_MS "Molten-Salt mass flow rate";
  output Real F(unit = "") "Temperature correction factor";
  output SI.ThermalConductance UA "UA";
  output SI.Area A_tot "Exchange Area";
  output SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";
  output Integer N_t "Number of tubes";
  output SI.Pressure Dp_tube "Tube-side pressure drop";
  output SI.Pressure Dp_shell "Shell-side pressure drop";
  output SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  output SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  output SI.Length D_s "Shell Diameter";
  output SI.Length D_s_out "Outer Shell Diameter";
  output Integer N_baffles "Number of baffles";
  output SI.Length l_b "Baffle spacing";
  output SI.Velocity v_Na "Sodium velocity in tubes";
  output SI.Velocity v_max_MS "Molten Salt velocity in shell";
  output SI.Volume V_HX "Heat-Exchanger Total Volume";
  output SI.Mass m_HX "Heat-Exchanger Total Mass";
  output SI.Mass m_material_HX "Heat-Exchanger Material Mass";
  output FI.Money_USD C_BEC "Bare cost @2018";
  output FI.MoneyPerYear C_pump "Annual pumping cost";
  output FI.MoneyPerYear TAC "Total Annualized Cost";
  output Real ex_eff(unit = "") "HX Exergetic Efficiency";
  output Real en_eff(unit = "") "HX Energetic Efficiency";
  output SI.Length L "Tube length";
  output Real ratio;
  output Real penalty;
  output Integer N_t_min "Minimum Number of tubes";
  output Integer N_t_max "Maximum Number of tubes";
  
  protected
  //Other Parameters
  parameter Real tol = 1e-3 "Heat transfer coefficient tollerance";
  parameter Real tol2 = 1e-2 "Heat transfer coefficient tollerance";
  parameter Real iter_max = 10;
  parameter Real iter_max_2 = 10;
  parameter Integer l_vec1=if N_t_input_on then 1 else 2000;
  parameter Integer l_vec2=5;
  parameter Integer l_vec=l_vec1*l_vec2;
  SI.CoefficientOfHeatTransfer U_calc;
  Real condition "When condition";
  Real iter;
  Real iter_2;
  Real geom_error;
  Integer result;
  Integer result_des_L;
  Integer skip;
  Integer length_vec_U;
  Real v_constrain;
  Real l_constrain;
  Real UA_constrain;
  FI.MoneyPerYear TAC_min;
  
  //Velocity limits
  parameter SI.Velocity v_max_MS_lim_min = 0.50;
  parameter SI.Velocity v_max_MS_lim_max = 1.50;
  parameter SI.Velocity v_Na_lim_min = 4/3.281;
  parameter SI.Velocity v_Na_lim_max = 8/3.281;
  parameter Integer max_length_N_b=10;
  Integer N_t_vec[l_vec1];
  SI.Length L_max;
  SI.Length LL;
  SI.Length L_max_constrain;
  SI.Length L_input[l_vec2];
  SI.Length l_b_min;
  SI.Length l_b_max;
  SI.Length t_baffle_max;
  SI.Length t_baffle_min;
  Integer N_baffles_min "Minimum Number of Baffles";
  Integer N_baffles_max "Maximum Number of Baffles";
  Integer N_baffles_vec[max_length_N_b];
  Real N_t_real[l_vec1];
  Real N_t_input_corr[l_vec1];
  
  //Tube-side
  parameter SI.Length t_tube = TubeThickness(d_o=d_o);
  parameter SI.Length d_i = d_o - 2 * t_tube;
  parameter SI.Area A_cs = CN.pi * d_i ^ 2 / 4;
  parameter SI.Length P_t = 1.25 * d_o;
  Integer Tep "Tubes for each pass";
  SI.Area A_st;
  
  //Shell-side
  parameter Real B = 0.25;
  SI.Length L_bb "Bundle-to-shell diametral clearance";
  SI.Length D_b "Bundle diameter";
  SI.Length t_baffle;
  SI.Length l_b_approx;
  Real min_condition;
  Integer pos_min_condition;
  
  Integer vec_Nb[max_length_N_b];
  SI.Length vec_lb[max_length_N_b];
  SI.Length vec_tb[max_length_N_b];
  SI.CoefficientOfHeatTransfer vec_U[max_length_N_b];
  SI.CoefficientOfHeatTransfer vec_h_s[max_length_N_b];
  SI.CoefficientOfHeatTransfer vec_h_t[max_length_N_b];
  Real vec_condition[max_length_N_b];
  
  //Cost Function
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  FI.AreaPrice sc_A = material_sc*8.6*1.1;
  parameter Real mmm = 0.37;
  parameter Real c2 = 11;
  parameter Real M_conv = if currency == Currency.USD then 1 else 0.9175 "Conversion factor";
  parameter Real eta_pump = 0.75 "Pump efficiency";
  Real F_ma "Manufacturing Factor";
  parameter Real F_ma_min = 1.65 "Manufacturing Factor";
  Real f(unit = "") "Annualization factor";
  
  //Turton Cost Function
  parameter Real CEPCI_01=397 "CEPCI 2001";
  parameter Real CEPCI_18=603.1 "CEPCI 2018";
  Real k1(unit= "") "Non dimensional factor";
  Real k2(unit= "") "Non dimensional factor";
  Real k3(unit= "") "Non dimensional factor";
  SI.Area A_cost "Area for cost function";
  FI.Money_USD C_BM  "Bare module cost @operating pressure and with material";
  FI.Money_USD C_p0  "Bare module cost @2001";
  Real C1(unit= "") "Non dimensional factor";
  Real C2(unit= "") "Non dimensional factor";
  Real C3(unit= "") "Non dimensional factor";
  Real B1(unit= "") "Non dimensional factor";
  Real B2(unit= "") "Non dimensional factor";
  Real Fp(unit= "") "Cost pressure factor";
  Real Fm(unit= "") "Cost material factor";
  Boolean both "Condition for pressure factor correlation";
  SI.Pressure P_shell "Shell-side pressure";
  SI.Pressure P_tubes "Tube-side pressure";
  Real P_tube_cost(unit= "barg") "Tube pressure in barg";
  Real P_shell_cost(unit= "barg") "Shell pressure in barg";
  Real P_cost(unit= "barg") "HX pressure in barg";
  FI.Money_USD C_BEC_Turton  "Bare cost @2018";
  
  //Volume_and_Weight
  SI.Mass m_Na "Mass of Sodium";
  SI.Mass m_MS "Mass of Molten Salts";
  SI.Volume V_Na "Volume of Sodium";
  SI.Volume V_MS "Volume of Molten Salt";
  SI.Volume V_material "Volume of HX material";
  SI.Volume V_tubes "Tube Material Volume";
  SI.Volume V_baffles "Baffles Material Volume";
  SI.Volume V_ShellThickness "External Material Volume HX";

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
  SI.SpecificEnthalpy h_Na1 "Sodium specific enthalpy @inlet temperature";
  SI.SpecificEnthalpy h_Na2 "Sodium specific enthalpy @outlet temperature";
  SI.SpecificEnthalpy h_MS1 "Molten Salt specific enthalpy @inlet temperature";
  SI.SpecificEnthalpy h_MS2 "Molten Salt specific enthalpy @outlet temperature";
  Medium1.ThermodynamicState state_mean_Na;
  Medium1.ThermodynamicState state_input_Na;
  Medium1.ThermodynamicState state_output_Na;
  Medium2.ThermodynamicState state_mean_MS;
  Medium2.ThermodynamicState state_wall_MS;
  Medium2.ThermodynamicState state_input_MS;
  Medium2.ThermodynamicState state_output_MS;
  SI.ThermalConductivity k_wall "Tube Thermal Conductivity";
  SI.Density rho_wall "HX material density";
  SI.Temperature Tm_wall "Mean Wall Temperature";
  
  //Temperature differences
  SI.TemperatureDifference DT1 "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2 "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD "Logarithmic mean temperature difference";
  
  //Design Parameters
  SI.MassFlowRate m_flow_Na_vec_des[l_vec1] "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS_vec_des[l_vec1] "Molten-Salt mass flow rate";
  Real F_vec_des[l_vec1] "Temperature correction factor";
  SI.ThermalConductance UA_vec_des[l_vec1] "UA";
  SI.Area A_vec_des[l_vec1] "Exchange Area";
  SI.CoefficientOfHeatTransfer U_vec_des[l_vec1] "Heat tranfer coefficient";
  Integer N_t_vec_des[l_vec1] "Number of tubes";
  SI.Pressure Dp_tube_vec_des[l_vec1] "Tube-side pressure drop";
  SI.Pressure Dp_shell_vec_des[l_vec1] "Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s_vec_des[l_vec1] "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t_vec_des[l_vec1] "Tube-side Heat tranfer coefficient";
  SI.Length D_s_vec_des[l_vec1] "Shell Diameter";
  SI.Length D_s_out_vec_des[l_vec1] "Shell Diameter";
  Integer N_baffles_vec_des[l_vec1] "Number of baffles";
  SI.Length l_b_vec_des[l_vec1];
  SI.Velocity v_Na_vec_des[l_vec1] "Sodium velocity in tubes";
  SI.Velocity v_max_MS_vec_des[l_vec1] "Molten Salt velocity in shell";
  SI.Volume V_HX_vec_des[l_vec1] "Heat-Exchanger Total Volume";
  SI.Mass m_HX_vec_des[l_vec1] "Heat-Exchanger Total Mass";
  SI.Mass m_material_HX_vec_des[l_vec1] "Heat-Exchanger Material Mass";
  FI.Money_USD C_BEC_vec_des[l_vec1] "Bare cost @2018";
  FI.MoneyPerYear C_pump_vec_des[l_vec1] "Annual pumping cost";
  FI.MoneyPerYear TAC_vec_des[l_vec1] "Total Annualized Cost";
  Real ex_eff_vec_des[l_vec1] "HX Exergetic Efficiency";
  Real en_eff_vec_des[l_vec1] "HX Energetic Efficiency";
  SI.Length L_vec_des[l_vec1];
  Real ratio_vec_des[l_vec1];
  FI.MoneyPerYear penalty_vec_des[l_vec1] "penalty";
  
  //Design Parameters_des_L
  SI.MassFlowRate m_flow_Na_vec_des_L[l_vec2] "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS_vec_des_L[l_vec2] "Molten-Salt mass flow rate";
  Real F_vec_des_L[l_vec2] "Temperature correction factor";
  SI.ThermalConductance UA_vec_des_L[l_vec2] "UA";
  SI.Area A_vec_des_L[l_vec2] "Exchange Area";
  SI.CoefficientOfHeatTransfer U_vec_des_L[l_vec2] "Heat tranfer coefficient";
  Integer N_t_vec_des_L[l_vec2] "Number of tubes";
  SI.Pressure Dp_tube_vec_des_L[l_vec2] "Tube-side pressure drop";
  SI.Pressure Dp_shell_vec_des_L[l_vec2] "Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s_vec_des_L[l_vec2] "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t_vec_des_L[l_vec2] "Tube-side Heat tranfer coefficient";
  SI.Length D_s_vec_des_L[l_vec2] "Shell Diameter";
  SI.Length D_s_out_vec_des_L[l_vec2] "Shell Diameter";
  Integer N_baffles_vec_des_L[l_vec2] "Number of baffles";
  SI.Length l_b_vec_des_L[l_vec2];
  SI.Velocity v_Na_vec_des_L[l_vec2] "Sodium velocity in tubes";
  SI.Velocity v_max_MS_vec_des_L[l_vec2] "Molten Salt velocity in shell";
  SI.Volume V_HX_vec_des_L[l_vec2] "Heat-Exchanger Total Volume";
  SI.Mass m_HX_vec_des_L[l_vec2] "Heat-Exchanger Total Mass";
  SI.Mass m_material_HX_vec_des_L[l_vec2] "Heat-Exchanger Material Mass";
  FI.Money_USD C_BEC_vec_des_L[l_vec2] "Bare cost @2018";
  FI.MoneyPerYear C_pump_vec_des_L[l_vec2] "Annual pumping cost";
  FI.MoneyPerYear TAC_vec_des_L[l_vec2] "Total Annualized Cost";
  Real ex_eff_vec_des_L[l_vec2] "HX Exergetic Efficiency";
  Real en_eff_vec_des_L[l_vec2] "HX Energetic Efficiency";
  SI.Length L_vec_des_L[l_vec2];
  Real ratio_vec_des_L[l_vec2];
  FI.MoneyPerYear penalty_vec_des_L[l_vec2] "penalty";
  
  SI.MassFlowRate m_flow_Na_des_L "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS_des_L "Molten-Salt mass flow rate";
  Real F_des_L(unit = "") "Temperature correction factor";
  SI.ThermalConductance UA_des_L "UA";
  SI.Area A_tot_des_L "Exchange Area";
  SI.CoefficientOfHeatTransfer U_des_L "Heat tranfer coefficient";
  Integer N_t_des_L "Number of tubes";
  SI.Pressure Dp_tube_des_L "Tube-side pressure drop";
  SI.Pressure Dp_shell_des_L "Shell-side pressure drop";
  SI.CoefficientOfHeatTransfer h_s_des_L "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t_des_L "Tube-side Heat tranfer coefficient";
  SI.Length D_s_des_L "Shell Diameter";
  SI.Length D_s_out_des_L "Outer Shell Diameter";
  Integer N_baffles_des_L "Number of baffles";
  SI.Length l_b_des_L "Baffle spacing";
  SI.Velocity v_Na_des_L "Sodium velocity in tubes";
  SI.Velocity v_max_MS_des_L "Molten Salt velocity in shell";
  SI.Volume V_HX_des_L "Heat-Exchanger Total Volume";
  SI.Mass m_HX_des_L "Heat-Exchanger Total Mass";
  SI.Mass m_material_HX_des_L "Heat-Exchanger Material Mass";
  FI.Money_USD C_BEC_des_L "Bare cost @2018";
  FI.MoneyPerYear C_pump_des_L "Annual pumping cost";
  FI.MoneyPerYear TAC_des_L "Total Annualized Cost";
  Real ex_eff_des_L(unit = "") "HX Exergetic Efficiency";
  Real en_eff_des_L(unit = "") "HX Energetic Efficiency";
  SI.Length L_des_L "Tube length";
  Real ratio_des_L;
  Real penalty_des_L;                

algorithm
  Tm_Na := (T_Na1 + T_Na2) / 2;
  Tm_MS := (T_MS1 + T_MS2) / 2;
  Tm_wall := (Tm_MS + Tm_Na) / 2;
  (k_wall, rho_wall) := Haynes230_BaseProperties(Tm_wall);
  
//Sodium properties
  state_mean_Na := Medium1.setState_pTX(p_Na1, Tm_Na);
  state_input_Na := Medium1.setState_pTX(p_Na1, T_Na1);
  state_output_Na := Medium1.setState_pTX(p_Na1, T_Na2);
  rho_Na := Medium1.density(state_mean_Na);
  cp_Na := Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na := Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall := mu_Na;
  k_Na := Medium1.thermalConductivity(state_mean_Na);
  h_Na1 := Medium1.specificEnthalpy(state_input_Na);
  h_Na2 := Medium1.specificEnthalpy(state_output_Na);
  
//Chloride Salt properties
  state_mean_MS := Medium2.setState_pTX(Medium2.p_default, Tm_MS);
  state_wall_MS := Medium2.setState_pTX(Medium2.p_default, Tm_Na);
  state_input_MS := Medium2.setState_pTX(p_Na1, T_MS1);
  state_output_MS := Medium2.setState_pTX(p_Na1, T_MS2);
  rho_MS := Medium2.density(state_mean_MS);
  cp_MS := Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS := Medium2.dynamicViscosity(state_mean_MS);
  mu_MS_wall := Medium2.dynamicViscosity(state_wall_MS);
  k_MS := Medium2.thermalConductivity(state_mean_MS);
  h_MS1 := Medium2.specificEnthalpy(state_input_MS);
  h_MS2 := Medium2.specificEnthalpy(state_output_MS);
  
//Temperature Differences
  DT1 := T_Na1 - T_MS2;
  DT2 := T_Na2 - T_MS1;
  if abs(DT1 - DT2) < 1e-6 then
    LMTD := DT1;
  else
    LMTD := (DT1 - DT2) / log(DT1 / DT2);
  end if;
  m_flow_Na := Q_d / (cp_Na * (T_Na1 - T_Na2));
  m_flow_MS := Q_d / (cp_MS * (T_MS2 - T_MS1));
  F := 1;
  UA := Q_d / (F * LMTD);
  ex_eff := m_flow_MS * (h_MS2 - h_MS1 - (25 + 273.15) * cp_MS * MA.log(T_MS2 / T_MS1)) / (m_flow_Na * (h_Na1 - h_Na2 - (25 + 273.15) * cp_Na * MA.log(T_Na1 / T_Na2)));
  if cp_Na * m_flow_Na > cp_MS * m_flow_MS then
    en_eff := (T_MS2 - T_MS1) ./ (T_Na1 - T_MS1);
  else
    en_eff := (T_Na1 - T_Na2) ./ (T_Na1 - T_MS1);
  end if;

  //Minimum Nt
  N_t_min:=integer(ceil(m_flow_Na*N_p/(rho_Na*A_cs*v_Na_lim_max)));
  N_t_max:=integer(floor(m_flow_Na*N_p/(rho_Na*A_cs*v_Na_lim_min)));
  N_t_input_corr:=min(N_t_max,max(N_t_input,N_t_min))*ones(l_vec1);
  N_t_real:= if N_t_input_on then N_t_input_corr else (linspace(N_t_min,N_t_max,l_vec1));
  for qq in 1:l_vec1 loop
    N_t:=integer(N_t_real[qq]);
    if N_p>1 then
        Tep:=integer(floor(N_t/N_p));
        N_t:=Tep*N_p;
    else
        Tep:=integer(ceil(N_t/N_p));
    end if;
    (L_bb, D_b, D_s, D_s_out):= ShellDiameter(d_o=d_o, N_t=N_t, layout=layout, N_p=N_p);
    l_b_min:=m_flow_MS/(rho_MS*v_max_MS_lim_max)/(L_bb+(D_b/P_t)*(P_t-d_o));
    l_b_max:=m_flow_MS/(rho_MS*v_max_MS_lim_min)/(L_bb+(D_b/P_t)*(P_t-d_o));
    l_b:=l_b_max;
    t_baffle_max:= BaffleThickness(D_s=D_s, l_b=l_b_max);
    t_baffle_min:= BaffleThickness(D_s=D_s, l_b=l_b_min);
    L_max_constrain:=D_s_out*ratio_max;
    L_max:=(if (ratio_cond and L_max_cond) then min(L_max_constrain, L_max_input) else 
                        if L_max_cond then L_max_input else 
                        if ratio_cond then L_max_constrain else 
                        100);
    L_input:=linspace(2,L_max,l_vec2);
    for iu in 1:l_vec2 loop
      LL:=L_input[iu];
      A_st:=LL*CN.pi*d_o;
      A_tot:=A_st*N_t;
      U_calc:=UA/A_tot;
      condition:=10;
      iter:=0;
      while condition>tol and iter<iter_max loop
        A_tot:=UA/U_calc;
        A_st:=A_tot/N_t;
        L:=A_st/(CN.pi*d_o);
        A_st:=CN.pi*d_o*L;
        A_tot:=A_st*N_t;
        (L_bb, D_b, D_s) := ShellDiameter(d_o=d_o, N_t=N_t, layout=layout, N_p=N_p);
        N_baffles_min:=max(1,integer(ceil((L/(l_b_max+t_baffle_max)-1))));
        N_baffles_max:=max(1,integer(floor((L/(l_b_min+t_baffle_min)-1))));
        N_baffles_vec:=integer(linspace(N_baffles_min,N_baffles_max,max_length_N_b));
        skip:=0;
        for yy in 1:size(N_baffles_vec,1) loop
          N_baffles:=N_baffles_vec[yy];
          geom_error:=10;
          iter_2:=0;
          l_b_approx:=L/(N_baffles+1);
          while noEvent(geom_error>tol2 or iter_2>iter_max_2) loop
            if N_baffles<1 then
                t_baffle:=0;
            else
                t_baffle:=BaffleThickness(D_s=D_s,l_b=l_b_approx);
            end if;
            l_b:=L/(N_baffles+1)-t_baffle;
            geom_error:=abs(l_b-l_b_approx)/l_b;
            l_b_approx:=l_b;
            iter_2:=iter_2+1;
          end while;
          if noEvent(geom_error<tol2) then
            vec_Nb[yy-skip]:=N_baffles;
            vec_lb[yy-skip]:=l_b;
            vec_tb[yy-skip]:=t_baffle;
          else
              skip:=skip+1;
          end if;
        end for;
        length_vec_U:=(size(vec_tb,1)-skip);
        for uu in 1:length_vec_U loop
          N_baffles:=vec_Nb[uu];
          l_b:=vec_lb[uu];
          t_baffle:=vec_tb[uu];
          (U, h_s, h_t):=HTCs(d_o=d_o, N_p=N_p, N_sp=N_p, layout=layout, N_t=N_t, state_mean_Na = state_mean_Na, state_mean_MS = state_mean_MS, state_wall_MS = state_wall_MS,m_flow_Na=m_flow_Na, m_flow_MS=m_flow_MS, l_b=l_b);
          condition:=abs(U*A_tot-UA)/UA;
          vec_U[uu]:=U;
          vec_h_s[uu]:=h_s;
          vec_h_t[uu]:=h_t;
          vec_condition[uu]:=condition;
        end for;
        min_condition := min(vec_condition[1:length_vec_U]);
        pos_min_condition := Vectors.find(min_condition, vec_condition);
        N_baffles:=vec_Nb[pos_min_condition];
        l_b:=vec_lb[pos_min_condition];
        t_baffle:=vec_tb[pos_min_condition];
        U:=vec_U[pos_min_condition];
        h_s:=vec_h_s[pos_min_condition];
        h_t:=vec_h_t[pos_min_condition];
        condition:=vec_condition[pos_min_condition];
        U_calc:=U;
        iter:=iter+1;
    end while;
      (Dp_tube, Dp_shell, v_Na, v_max_MS):=Dp_losses(d_o=d_o, N_p=N_p, N_sp=N_sp, layout=layout, N_t=N_t, L=L, state_mean_Na = state_mean_Na, state_mean_MS = state_mean_MS, state_wall_MS = state_wall_MS, m_flow_Na=m_flow_Na, m_flow_MS=m_flow_MS,l_b=l_b, N=N_baffles);
      V_ShellThickness:=(D_s_out^2-(D_s^2))*CN.pi/4*L;
      V_tubes:=CN.pi*(d_o^2-d_i^2)/4*L*N_t;
      V_baffles:=(CN.pi*D_s^2)/4*(1-B)*N_baffles*t_baffle+t_baffle*D_s*L*(N_sp-1);
      V_material:=V_ShellThickness+V_tubes+V_baffles;
      V_Na:=CN.pi/4*(d_i^2)*L*N_t;
      V_MS:=(D_s^2-(d_o^2)*N_t)*CN.pi/4*L-V_baffles;
      V_HX:=V_material+V_MS+V_Na;
      m_Na:=V_Na*rho_Na;
      m_MS:=V_MS*rho_MS;
      m_material_HX:=V_material*rho_wall;
      m_HX:=m_material_HX+m_MS+m_Na;
    
      //Turton Cost function
      P_shell:=p_MS1;
      P_tubes:=p_Na1;
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
      if noEvent(A_tot>1000) then
        A_cost:=1000;
        elseif noEvent(A_tot<10) then
        A_cost:=10;    
        else
        A_cost:=A_tot;    
      end if;
      C_p0:=10^(k1+k2*log10(A_cost)+k3*(log10(A_cost))^2);
      C_BM:=C_p0*(CEPCI_18/CEPCI_01)*(B1+B2*Fm*Fp);
      C_BEC_Turton:=C_BM*(A_tot/A_cost)^0.7;
  
      //Cost Fucntion
      F_ma:=F_ma_min+c2.*A_tot.^(-mmm);
      C_BEC:=max(sc_A*A_tot*F_ma,C_BEC_Turton);
      C_pump:=c_e*H_y/eta_pump*(m_flow_MS*Dp_shell/rho_MS+m_flow_Na*Dp_tube/rho_Na)/(1000);
      f:=(r*(1+r)^n)/((1+r)^n-1);
      ratio:=L/D_s_out;
      l_constrain:=(if L>L_max then 1 else 0);
      v_constrain:=(if v_max_MS<v_max_MS_lim_min then 1 else 0)+(if v_max_MS>v_max_MS_lim_max then 1 else 0)+(if v_Na<v_Na_lim_min then 1 else 0) + ( if v_Na>v_Na_lim_max then 1 else 0);
      UA_constrain:=(if condition>0.05 then 1 else 0)+(if geom_error>tol2 then 1 else 0);
      if noEvent((v_constrain+UA_constrain+l_constrain)>0) then
          TAC:=10e10;
          C_BEC:=10e10;
          penalty:=10e10;
      elseif noEvent(condition<tol) then
          if noEvent(C_BEC>0 and C_pump>0) then
            C_BEC:=max(sc_A*A_tot*F_ma,C_BEC_Turton);
            TAC:=f*C_BEC+C_pump;
            penalty:=0;
          else
            TAC:=10e10;
            C_BEC:=10e10;
            penalty:=10e10;
          end if;
      else
          if noEvent(C_BEC>0 and C_pump>0) then
            TAC:=(f*C_BEC+C_pump);
            penalty:=(condition*50)*TAC;
            C_BEC:=max(sc_A*A_tot*F_ma,C_BEC_Turton);
            TAC:=(f*C_BEC+C_pump)+penalty;
          else
            TAC:=10e10;
            C_BEC:=10e10;
            penalty:=10e10;
          end if;
      end if;
      
      m_flow_Na_vec_des_L[iu]:=m_flow_Na;
      m_flow_MS_vec_des_L[iu]:=m_flow_MS;
      F_vec_des_L[iu]:=F;
      UA_vec_des_L[iu]:=UA;
      A_vec_des_L[iu]:=A_tot;
      U_vec_des_L[iu]:=U;
      N_t_vec_des_L[iu]:=N_t;    
      Dp_tube_vec_des_L[iu]:=Dp_tube;
      Dp_shell_vec_des_L[iu]:=Dp_shell;
      h_s_vec_des_L[iu]:=h_s;
      h_t_vec_des_L[iu]:=h_t;
      D_s_vec_des_L[iu]:=D_s;
      D_s_out_vec_des_L[iu]:=D_s_out;
      N_baffles_vec_des_L[iu]:=N_baffles;
      l_b_vec_des_L[iu]:=l_b;
      v_Na_vec_des_L[iu]:=v_Na;
      v_max_MS_vec_des_L[iu]:=v_max_MS;
      V_HX_vec_des_L[iu]:=V_HX;
      m_HX_vec_des_L[iu]:=m_HX;
      m_material_HX_vec_des_L[iu]:=m_material_HX;
      C_BEC_vec_des_L[iu]:=C_BEC;
      C_pump_vec_des_L[iu]:=C_pump;
      TAC_vec_des_L[iu]:=TAC;
      ex_eff_vec_des_L[iu]:=ex_eff;
      en_eff_vec_des_L[iu]:=en_eff;
      L_vec_des_L[iu]:=L;
      ratio_vec_des_L[iu]:=ratio;
      penalty_vec_des_L[iu]:=penalty;
      
    end for;
    
    TAC_des_L := min(TAC_vec_des_L);
    result_des_L := Vectors.find(TAC_des_L, TAC_vec_des_L);
    A_tot_des_L := A_vec_des_L[result_des_L];
    U_des_L := U_vec_des_L[result_des_L];
    N_t_des_L := N_t_vec_des_L[result_des_L];
    m_flow_Na_des_L := m_flow_Na_vec_des_L[result_des_L];
    m_flow_MS_des_L := m_flow_MS_vec_des_L[result_des_L];
    F_des_L := F_vec_des_L[result_des_L];
    UA_des_L := UA_vec_des_L[result_des_L];
    L_des_L:=L_vec_des_L[result_des_L];
    Dp_tube_des_L := Dp_tube_vec_des_L[result_des_L];
    Dp_shell_des_L := Dp_shell_vec_des_L[result_des_L];
    h_s_des_L := h_s_vec_des_L[result_des_L];
    h_t_des_L := h_t_vec_des_L[result_des_L];
    D_s_des_L := D_s_vec_des_L[result_des_L];
    D_s_out_des_L := D_s_out_vec_des_L[result_des_L];
    N_baffles_des_L := N_baffles_vec_des_L[result_des_L];
    l_b_des_L:=l_b_vec_des_L[result_des_L];
    v_Na_des_L := v_Na_vec_des_L[result_des_L];
    v_max_MS_des_L := v_max_MS_vec_des_L[result_des_L];
    V_HX_des_L := V_HX_vec_des_L[result_des_L];
    m_HX_des_L := m_HX_vec_des_L[result_des_L];
    m_material_HX_des_L := m_material_HX_vec_des_L[result_des_L];
    C_BEC_des_L := C_BEC_vec_des_L[result_des_L];
    C_pump_des_L := C_pump_vec_des_L[result_des_L];
    ex_eff_des_L := ex_eff_vec_des_L[result_des_L];
    en_eff_des_L := en_eff_vec_des_L[result_des_L];
    ratio_des_L := ratio_vec_des_L[result_des_L];
    penalty_des_L :=penalty_vec_des_L[result_des_L];
    
    m_flow_Na_vec_des[qq]:=m_flow_Na_des_L;
    m_flow_MS_vec_des[qq]:=m_flow_MS_des_L;
    F_vec_des[qq]:=F_des_L;
    UA_vec_des[qq]:=UA_des_L;
    A_vec_des[qq]:=A_tot_des_L;
    U_vec_des[qq]:=U_des_L;
    N_t_vec_des[qq]:=N_t_des_L;    
    Dp_tube_vec_des[qq]:=Dp_tube_des_L;
    Dp_shell_vec_des[qq]:=Dp_shell_des_L;
    h_s_vec_des[qq]:=h_s_des_L;
    h_t_vec_des[qq]:=h_t_des_L;
    D_s_vec_des[qq]:=D_s_des_L;
    D_s_out_vec_des[qq]:=D_s_out_des_L;
    N_baffles_vec_des[qq]:=N_baffles_des_L;
    l_b_vec_des[qq]:=l_b_des_L;
    v_Na_vec_des[qq]:=v_Na_des_L;
    v_max_MS_vec_des[qq]:=v_max_MS_des_L;
    V_HX_vec_des[qq]:=V_HX_des_L;
    m_HX_vec_des[qq]:=m_HX_des_L;
    m_material_HX_vec_des[qq]:=m_material_HX_des_L;
    C_BEC_vec_des[qq]:=C_BEC_des_L;
    C_pump_vec_des[qq]:=C_pump_des_L;
    TAC_vec_des[qq]:=TAC_des_L;
    ex_eff_vec_des[qq]:=ex_eff_des_L;
    en_eff_vec_des[qq]:=en_eff_des_L;
    L_vec_des[qq]:=L_des_L;
    ratio_vec_des[qq]:=ratio_des_L;
    penalty_vec_des[qq]:=penalty_des_L;
  end for;
  
  TAC := min(TAC_vec_des);
  result := Vectors.find(TAC, TAC_vec_des);
  A_tot := A_vec_des[result];
  U := U_vec_des[result];
  N_t := N_t_vec_des[result];
  m_flow_Na := m_flow_Na_vec_des[result];
  m_flow_MS := m_flow_MS_vec_des[result];
  F := F_vec_des[result];
  UA := UA_vec_des[result];
  L:=L_vec_des[result];
  Dp_tube := Dp_tube_vec_des[result];
  Dp_shell := Dp_shell_vec_des[result];
  h_s := h_s_vec_des[result];
  h_t := h_t_vec_des[result];
  D_s := D_s_vec_des[result];
  D_s_out := D_s_out_vec_des[result];
  N_baffles := N_baffles_vec_des[result];
  l_b:=l_b_vec_des[result];
  v_Na := v_Na_vec_des[result];
  v_max_MS := v_max_MS_vec_des[result];
  V_HX := V_HX_vec_des[result];
  m_HX := m_HX_vec_des[result];
  m_material_HX := m_material_HX_vec_des[result];
  C_BEC := C_BEC_vec_des[result];
  C_pump := C_pump_vec_des[result];
  ex_eff:= ex_eff_vec_des[result];
  en_eff := en_eff_vec_des[result];
  ratio:= ratio_vec_des[result];
  penalty:=penalty_vec_des[result];
  
end Design_HX;
