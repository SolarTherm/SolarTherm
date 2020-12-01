within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2NREL_100MWe_700C_510C "SCO2 cycle based on regression of NREL PB"
	extends Cycle;
	import Modelica.SIunits.Conversions.*;
	input SI.Temperature T_amb;
    SI.Temperature T_ND "Non-dimensional temperature";
    //These constants are for eta_Q or k_q
    constant Real A = -14.86838446;
    constant Real B = 26.57635636;
    constant Real C = -11.56320512;
    constant Real D = 0.799613122;
    //These constants are for eta_gross or k_w
    constant Real E = 7.65551271;
    constant Real F = 6.43977203;
    constant Real G = -3.1100735;
    constant Real H = -0.11754550;
    constant Real I = 0.00043190;
    constant Real J = -5.28275e-7;
    constant Real K = 0.3118237;
    constant Real L = -0.14789011;
    
equation
    //Note that k_q and k_w get passed as eta_Q and eta_gross
    T_ND = T_in/T_in_ref;

    k_q = A + B*(T_ND) + C*(T_ND^2) + D*load;
    k_w = E + F*(T_ND) + G*(T_ND^2) + H*(T_amb) + I*(T_amb^2) + J*(T_amb^3) + K*(load) + L*(load^2);
end sCO2NREL_100MWe_700C_510C;