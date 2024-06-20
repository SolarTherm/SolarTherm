within SolarTherm.Models.Fluid.HeatExchangers;

package HRSG_eNTU
  function k_eff
  import SI = Modelica.SIunits;
    import CN = Modelica.Constants;
    import CV = Modelica.SIunits.Conversions;
    
    //Imposed conditions
    input SI.Temperature T "Particle stream temperature (K)";
    input SI.Diameter d_p "Particle diameter (m)";  
    output SI.ThermalConductivity k_eff "Effective thermal conductivity (W/mK)";
  protected
    constant SI.Pressure P = 1.0e5 "Gas pressure (Pa)";
    
  algorithm

  annotation(
      Diagram(coordinateSystem(preserveAspectRatio = false)));end k_eff;

  model U_overall
    import CN = Modelica.Constants;
    import CV = Modelica.SIunits.Conversions;
    
    //Parameters
    parameter SI.Diameter d_p = 0.01 "Solid particle diameter (m)";
    parameter Real epsilon_s = 0.50 "Solid particle void fraction (-)";
    parameter Real em_1 = 0.8 "Solid surface emissivity (-)";
    parameter SI.Length t_HX = 0.1 "Thickness of the HX separator wall (m)";
    
    //Variables
    SI.Temperature T_p "Temperature of particles (K)";
    SI.Temperature T_g "Temperature of gas (K)";
    SI.Pressure P "Pressure of gas (Pa)";
    
    //Material Properties
    SI.ThermalConductivity k_p "Thermal conductivity of particles (W/mK)";
    SI.ThermalConductivity k_g "Thermal conductivity of gas (W/mK)";
    Real Pr_g "Prandtl number of gas (-)";
    Real mu_g "Dynamic viscosity of gas (Pa.s)";
  
  equation
  //I'll come back to this shit later
    annotation(
      Diagram(coordinateSystem(preserveAspectRatio = false)));
  end U_overall;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end HRSG_eNTU;