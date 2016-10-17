within SolarTherm.Media.MoltenSalt;
package MoltenSalt_Utilities
   extends Modelica.Icons.UtilitiesPackage;
  function rho_T "Density as a function of temperature"
    extends Modelica.Icons.Function;
    input SI.Temperature K "Temperature";
    output SI.Density rho "Density";
  protected
    SI.Temp_C T=to_degC(K) "Temperature in degCelsius";
  algorithm
    rho:=2090-0.636*T;
  end rho_T;

  function cp_T "Specific heat capacity as a function of temperature"
    extends Modelica.Icons.Function;
    input SI.Temperature K "Temperature";
    output SI.SpecificHeatCapacity cp "Specific heat capacity";
  protected
    SI.Temp_C T=to_degC(K) "Temperature in degCelsius";
  algorithm
    cp:=1443+0.172*T;
  end cp_T;

  function h_T "Specific enthalpy as a function of temperature"
    extends Modelica.Icons.Function;
    input SI.Temperature T "Temperature";
    output SI.SpecificEnthalpy h "Specific enthalpy";
  algorithm
    //h:=(1443-0.172*273.15)*T+(0.172/2)*T^2;
    h:=1396.0182*T+0.086*T^2;
  end h_T;

  function T_h "Temperature as a function of specific enthalpy"
    extends Modelica.Icons.Function;
    input SI.SpecificEnthalpy h "Specific enthalpy";
    output SI.Temperature T "Temperature";
  algorithm
    //h:=1396.0182*T+0.086*T^2;
    T:=(-1396.0182+sqrt(abs(1396.0182^2+4*0.086*h)))/(2*0.086);
  end T_h;

  function lamda_T "Thermal conductivity as a function of temperature"
    extends Modelica.Icons.Function;
    input SI.Temperature K "Temperature";
    output SI.ThermalConductivity lamda "Thermal conductivity";
  protected
    SI.Temp_C T=to_degC(K) "Temperature in degCelsius";
  algorithm
    //h:=(1443-0.172*273.15)*T+(0.172/2)*T^2;
    lamda:=0.443+1.9e-4*T;
  end lamda_T;

  function eta_T "Dynamic viscosity as a function of temperature"
    extends Modelica.Icons.Function;
    input SI.Temperature K "Temperature";
    output SI.DynamicViscosity eta "Dynamic viscosity";
  protected
    SI.Temp_C T=to_degC(K) "Temperature in degCelsius";
  algorithm
    eta:=1000*(22.714-0.120*T+2.281e-4*T^2-1.474e-7*T^3);
  end eta_T;

  function s_T "Specific entropy as a function of temperature"
    extends Modelica.Icons.Function;
    input SI.Temperature T "Temperature";
    output SI.SpecificEntropy s "Specific heat capacity";
  algorithm
    s:=1396.0182*log(T)+0.172*T;
  end s_T;
end MoltenSalt_Utilities;
