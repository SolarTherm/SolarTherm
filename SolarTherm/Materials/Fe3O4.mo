within SolarTherm.Materials;
package Fe3O4
  extends SolarTherm.Materials.PartialMaterial(MM = 231.533e-3, T_melt = 1583.0+273.15, cost = 0.0, year = 2020);
  import SolarTherm.Utilities.Interpolation.Interpolate1D;
  
  redeclare model State "A model which calculates state and properties"
	
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";

	
  equation
	T = SolarTherm.Media.SolidParticles.Fe3O4_utilities.T_h(h);
    rho = SolarTherm.Media.SolidParticles.Fe3O4_utilities.rho_T(T);
    k = SolarTherm.Media.SolidParticles.Fe3O4_utilities.lamda_T(T); //some genius spelt it like that, not Zeb
    f = 0.0; //Never melts
  end State;
  
  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  algorithm
    T := SolarTherm.Media.SolidParticles.Fe3O4_utilities.T_h(h);
    f := 0.0;
    //T := Interpolate1D(h_data,T_data,h);
    //f := 0.0;
  end Tf_h;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := SolarTherm.Media.SolidParticles.Fe3O4_utilities.h_T(T);
    //h := Interpolate1D(T_data,h_data,T);
  end h_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := SolarTherm.Media.SolidParticles.Fe3O4_utilities.lamda_T(T); //because some genius decided to spell it that way
    //k := Interpolate1D(T_data,k_data,T);
  end k_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := SolarTherm.Media.SolidParticles.Fe3O4_utilities.rho_T(T);
    //rho := Interpolate1D(T_data,rho_data,T);
  end rho_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Assumptions:</b><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b><br></b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Property lookup tables were constructed at Temperature&nbsp;<i>T</i>&nbsp;intervals of 10 K based on data from the following sources:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">FactSage [1]:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Specific enthalpy,&nbsp;<i>h</i>&nbsp;(J/kg) measured relative to 298.15 K</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Specific heat capacity&nbsp;<i>c_p&nbsp;</i>(J/kgK)</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Absolute specific entropy&nbsp;<i>s&nbsp;</i>(J/kgK) measured relative to a perfect crystal at 0 K</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Beygelzimer [2]:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Density,&nbsp;<i>rho</i>&nbsp;(kg/m3)</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Beygelzimer [3]:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Thermal conductivity,&nbsp;<i>k</i>&nbsp;(W/mK)</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Caution: No unit cost is provided at the moment.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>References:</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b><br></b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">[1] C.W. Bale, E. Bélisle, P. Chartrand, S.A. Decterov, G. Eriksson, A.E. Gheribi, K. Hack, I.H. Jung, Y.B. Kang, J. Melançon, A.D. Pelton, S. Petersen, C. Robelin, J. Sangster, P. Spencer, M.-A. Van Ende,&nbsp;<i>FactSage Thermochemical Software and Databases</i>, Calphad 54 (2016) 35–53.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">[2]&nbsp;<font face=\"DejaVu Sans Mono\">E. Beygelzimer, Y. Beygelzimer, Generalized estimates for the density of oxide scale in the range from 0 C to 1300 C, (2021).&nbsp;</font>https://doi.org/10.48550/arXiv.2110.09791.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">[3]&nbsp;<font face=\"DejaVu Sans Mono\">E. Beygelzimer, Y. Beygelzimer, Thermal conductivity of oxide scale and its components in the range from 0 C to 1300 C:&nbsp;</font>Generalized estimates with account for movability of phase transitions, (2021). http://arxiv.org/abs/2110.11632 (accessed March 14,&nbsp;2024).</div></body></html>"));
end Fe3O4;