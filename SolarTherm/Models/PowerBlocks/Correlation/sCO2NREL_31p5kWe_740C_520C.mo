within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL_31p5kWe_740C_520C "SCO2 cycle based on regression of NREL PB, Chloride Salt HTF"
	extends Cycle(T_in_ref = 740.0 + 273.15);
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;
	parameter SI.Temperature T_amb_ref = 35.0 + 273.15 "Design ambient temperature";
    Real T_ND "Non-dimensional inlet temperature";
    Real T_amb_ND "Non-dimensional ambient temperature";
    //These constants are for eta_Q or k_q
    constant Real a_0 = -7.14893581;
    constant Real a_1 = 3.420073792;
    constant Real a_2 = 8.116621923;
    constant Real a_3 = -4.5094076;
    constant Real a_4 = 1.450317705;
    constant Real a_5 = -0.37954592;
    //These constants are for eta_gross or k_w
    constant Real b_0 = 10.86336187;
    constant Real b_1 = 0.3199253;
    constant Real b_2 = -37.52268409;
    constant Real b_3 = 42.46572701;
    constant Real b_4 = -15.99742766;
    constant Real b_5 = 0.917931794;
    constant Real b_6 = -0.885512156;
    constant Real b_7 = 0.28552641;
    //Regression design values (when all variables are 1)
    parameter Real eta_q_des = 0.949124086 "Design HX efficiency";
    parameter Real eta_w_des = 0.446848478 "Design Cycle efficiency";
    parameter Real eta_gross_des = 0.424114654 "Design gross efficiency, product of eta_q and eta_w";
    
equation
    //Note that k_q and k_w get passed as eta_Q and eta_gross
    T_ND = T_in/T_in_ref;
    T_amb_ND = T_amb/T_amb_ref;

    k_q = a_0 + a_1*(T_ND) + a_2*(T_amb_ND) + a_3*(T_amb_ND^2) + a_4*(load) + a_5*(load^2);
    k_w = b_0 + b_1*(T_ND) + b_2*(T_amb_ND) + b_3*(T_amb_ND^2) + b_4*(T_amb_ND^3) + b_5*(load) + b_6*(load^2) + b_7*(load^3);
end sCO2NREL_31p5kWe_740C_520C;