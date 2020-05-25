within SolarTherm.Media.Materials;
package Sodium2P
  extends SolarTherm.Media.Materials.PartialMaterial(MM = 22.989769e-3, T_melt = 97.79 + 273.15, cost = 3.0);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;

  //constant SI.MolarMass MM = 22.989769e-3 "Molar mass (kg/mol)";
  //constant SI.Temperature T_melt = 97.79 + 273.15 "Melting point (K)"; 
  //constant Real cost = 3.0 "USD/kg";

  redeclare model State "A model which calculates state and properties"
  //Thermodynamic state properties
    SI.Temperature T;
    Real x;
    SI.Density rho;
    SI.SpecificVolume v;
    SI.SpecificEnthalpy h;
    SI.AbsolutePressure p;
    
  //Phasewise properties
    SI.Density rho_l;
    SI.Density rho_v;
    SI.SpecificVolume v_l;
    SI.SpecificVolume v_v;
    SI.SpecificEnthalpy h_l;
    SI.SpecificEnthalpy h_v;
    
  //Thermophysical properties
    SI.DynamicViscosity mu_l;
    SI.DynamicViscosity mu_v;
    SI.ThermalConductivity k_l;
    SI.ThermalConductivity k_v;
  
  algorithm
    mu_l := mu_T(T);
    mu_v := mu_v_T(T);
    k_l := k_T(T);
    k_v := k_v_T(T);
    p := p_v(T);
    
  equation
    rho_l = rho_T(T);
    rho_v = rho_v_T(T);
    v_l = 1.0/rho_l;
    v_v = 1.0/rho_v;
    h_l = h_T(T);
    h_v = h_v_T(T);
    
    rho = (1.0-x)*rho_l + x*rho_v;
    h = (1.0-x)*h_l + x*h_v;
    v = 1.0/rho;
  end State;
  
  /*A model of sodium in two-phase liquid-vapor equilibrium */
  function h_T "Specific enthalpy of liquid sodium vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    if T < 2000.0 then
      h := 1000 * (-365.77 + 1.6582 * T - 4.2395e-4 * T ^ 2 + 1.4847e-7 * T ^ 3 + 2992.6 / T - 104.90817873321107);
    else
      h := h_avg_T(T) - 0.5*h_fg_T(T);
    end if;
  end h_T;
  
  function h_Tf "Specific enthalpy of liquid sodium vs Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    if T < 2000.0 then
      h := 1000 * (-365.77 + 1.6582 * T - 4.2395e-4 * T ^ 2 + 1.4847e-7 * T ^ 3 + 2992.6 / T - 104.90817873321107);
    else
      h := h_avg_T(T) - 0.5*h_fg_T(T);
    end if;
  end h_Tf;
  
  function h_avg_T "Average specific enthalpy of sodium liquid and gas above 2000K"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.SpecificEnthalpy h_avg "Specific Enthalpy (J/kg)";
  algorithm
    h_avg := (2128.4 + 0.86496*T)*1.0e3;
  end h_avg_T;
  
  function h_fg_T "Enthalpy of vaporization"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.SpecificEnthalpy h_fg "Specific Enthalpy of vaporization (J/kg)";
  algorithm
    h_fg := (393.37*(1.0-(T/2503.7))+4398.6*((1.0-(T/2503.7))^0.29302))*1.0e3;
  end h_fg_T;
  
  function h_v_T "Specific enthalpy of sodium vapor"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    if T < 2000.0 then
      h := h_T(T) + h_fg_T(T);
    else
      h := h_avg_T(T) + 0.5*h_fg_T(T);
    end if;  
  end h_v_T;
  
  function gamma_T "Devivative of vapor pressure wrt temperature along saturation curve"
    input SI.Temperature T "Absolute temperature (K)";
    output Real gamma "Derivative of vapor pressure w.r.t temperature (Pa/K)";
  protected
    	constant Real b = -12633.7;
	constant Real c = -0.4672;
  algorithm
    gamma := (-b / (T ^ 2) + c / T) * p_v(T);
  end gamma_T;
  
  function p_v "Vapor pressure of saturated sodium"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.AbsolutePressure p "Pressure (Pa)";
  protected
	constant Real a = 11.9463;
	constant Real b = -12633.7;
	constant Real c = -0.4672;
  algorithm
	p := (1e+6) * exp(a + b / T + c * log(T));
  end p_v;
  
  function k_T "Thermal conductivity of liquid sodium as a function of temperature"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  algorithm
    k := 124.67 - 0.11381 * T + 5.5226e-5 * T ^ 2 - 1.1842e-8 * T ^ 3;
  end k_T;
  
  function k_v_T "Thermal conductivity of saturated sodium vapor"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.ThermalConductivity k "Thermal conductivity (W/mK)";
  protected
	constant Real p1 = -1.260801088007033e-04;
	constant Real p2 = 2.265624999999752e-04;
	constant Real p3 = 1.069770620126767e-04;
	constant Real p4 = -4.671474358973460e-04;
	constant Real p5 = 0.001173894960486;
	constant Real p6 = -0.002735622571873;
	constant Real p7 = 0.009016230552265;
	constant Real p8 = 0.049212509712510;
	constant Real T_mean = 1100;
	constant Real T_std = 273.9;
	Real x;
  algorithm
	//Ref: https://www.thermalfluidscentral.org/encyclopedia/index.php/Thermophysical_Properties:_Sodium
	// Valid from 700K to 1500K
	x := (T - T_mean) / T_std; //T_norm
	k := p1 * x ^ 7 + p2 * x ^ 6 + p3 * x ^ 5 + p4 * x ^ 4 + p5 * x ^ 3 + p6 * x ^ 2 + p7 * x + p8;  
  end k_v_T;
  
  function rho_T "Density of liquid sodium"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 219 + 275.32 * (1 - T / 2503.7) + 511.58 * sqrt(1 - T / 2503.7);
  end rho_T;
  
  function rho_Tf "Density of liquid sodium"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f = 0 "Liquid mass melt fraction (No effect on result)";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 219 + 275.32 * (1 - T / 2503.7) + 511.58 * sqrt(1 - T / 2503.7);
  end rho_Tf;
  
  function rho_v_T "Density of sodium gas"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := 1 / (((1 * h_fg_T(T)) / (T * gamma_T(T))) + (1 / rho_T(T)));
  end rho_v_T;
  
  function mu_T "Dynamic viscosity of sodium liquid"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.DynamicViscosity mu "Dynamic viscosity";
  algorithm
    mu := exp(-6.4406 - 0.3958 * log(T) + 556.835 / T);
  end mu_T;
  
  function mu_v_T "Dynamic viscosity of sodium gas"
    input SI.Temperature T "Absolute temperature (K)";
    output SI.DynamicViscosity mu "Dynamic viscosity";
  protected
	constant Real p1 = 7.670352421272374e-08;
	constant Real p2 = -1.013685486531908e-07;
	constant Real p3 = -3.058015819964534e-07;
	constant Real p4 = 7.173018256913402e-06;
	constant Real p5 = 2.580480049362403e-05;
	constant Real T_mean = 1200;
	constant Real T_std = 389.4;
	Real x;
  algorithm
	//Ref: https://www.thermalfluidscentral.org/encyclopedia/index.php/Thermophysical_Properties:_Sodium
	// Valid from 600K to 1800K
	x := (T - T_mean) / T_std; //T_norm
	mu := p1 * x ^ 4 + p2 * x ^ 3 + p3 * x ^ 2 + p4 * x + p5;
  end mu_v_T;
  
end Sodium2P;