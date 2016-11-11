within SolarTherm.Media.MoltenSalt;
package MoltenSalt_Utilities
   extends Modelica.Icons.UtilitiesPackage;
  function rho_T "Density as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature K "Temperature";
    output Modelica.SIunits.Density rho "Density";
  protected
    Modelica.SIunits.Temp_C T=Modelica.SIunits.Conversions.to_degC(K)
      "Temperature in degCelsius";
  algorithm
    rho:=2090-0.636*T;

  annotation(derivative=rho_T_der);
  end rho_T;

  function cp_T "Specific heat capacity as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature K "Temperature";
    output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity";
  protected
    Modelica.SIunits.Temp_C T=Modelica.SIunits.Conversions.to_degC(K)
      "Temperature in degCelsius";
  algorithm
    cp:=1396.0182+2*0.086*T;//1443+0.172*T;
  end cp_T;

  function h_T "Specific enthalpy as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature";
    output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
  algorithm
    //h:=(1443-0.172*273.15)*T+(0.172/2)*T^2;
    h:=1396.0182*T+0.086*T^2;
  end h_T;

  function T_h "Temperature as a function of specific enthalpy"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    output Modelica.SIunits.Temperature T "Temperature";
  algorithm
    //h:=1396.0182*T+0.086*T^2;
    T:=(-1396.0182+sqrt(abs(1396.0182^2+4*0.086*h)))/(2*0.086);
    annotation(derivative=T_h_der);
  end T_h;

  function lamda_T "Thermal conductivity as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature K "Temperature";
    output Modelica.SIunits.ThermalConductivity lamda "Thermal conductivity";
  protected
    Modelica.SIunits.Temp_C T=Modelica.SIunits.Conversions.to_degC(K)
      "Temperature in degCelsius";
  algorithm
    //h:=(1443-0.172*273.15)*T+(0.172/2)*T^2;
    lamda:=0.443+1.9e-4*T;
  end lamda_T;

  function eta_T "Dynamic viscosity as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature K "Temperature";
    output Modelica.SIunits.DynamicViscosity eta "Dynamic viscosity";
  protected
    Modelica.SIunits.Temp_C T=Modelica.SIunits.Conversions.to_degC(K)
      "Temperature in degCelsius";
  algorithm
    eta:=1000*(22.714-0.120*T+2.281e-4*T^2-1.474e-7*T^3);
  end eta_T;

  function s_T "Specific entropy as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature";
    output Modelica.SIunits.SpecificEntropy s "Specific heat capacity";
  algorithm
    s:=1396.0182*log(T)+0.172*T;
  end s_T;

  function rho_T_der "Density as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature";
    input Real der_T;
    output Real der_rho "Density";
  algorithm
    der_rho:=drho_dT_T(T)*der_T;
  end rho_T_der;

  function dh_dT_T "Specific enthalpy as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature";
    output Real dh "Specific enthalpy";
  algorithm
    //h:=(1443-0.172*273.15)*T+(0.172/2)*T^2;
    dh:=cp_T(T);
  end dh_dT_T;

  function T_h_der "Temperature as a function of specific enthalpy"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
    input Real der_h;
    output Real der_T "Temperature";
  protected
    Modelica.SIunits.Temperature T;
  algorithm
    //h:=1396.0182*T+0.086*T^2;
    T:=T_h(h);
    der_T:=(1/dh_dT_T(T))*der_h;
  end T_h_der;

  function drho_dT_T "Density as a function of temperature"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature";
    output Modelica.SIunits.Density rho "Density";
  algorithm
    rho:=2090;
  end drho_dT_T;
  annotation ();
end MoltenSalt_Utilities;
