within SolarTherm.Materials;
package Fe
  extends SolarTherm.Materials.PartialMaterial(MM = 55.845e-3, T_melt = 1809.0, cost = 0.5, year = 2020);
  import SolarTherm.Utilities.Interpolation.Interpolate1D; 
  
  redeclare model State "A model which calculates state and properties"
	SI.SpecificEnthalpy h "Specific Enthalpy wrt 298.15K (J/kg)";
	SI.Temperature T "Temperature (K)";
	Real f "Liquid Mass Fraction";
	SI.Density rho "Density (kg/m3)";
	SI.ThermalConductivity k "Thermal conductivity (W/mK)";

  equation
	T = SolarTherm.Media.SolidParticles.Fe_utilities.T_h(h);
    rho = SolarTherm.Media.SolidParticles.Fe_utilities.rho_T(T);
    k = SolarTherm.Media.SolidParticles.Fe_utilities.lamda_T(T); //some genius spelt it like that, not Zeb
    f = 0.0; //Never melts
  end State;
  
  function Tf_h "Find temperature and liquid fraction from temperature"
    input SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
    output SI.Temperature T "Absoulte temperature (K)";
    output Real f "mass liquid fraction";
  algorithm
    T := SolarTherm.Media.SolidParticles.Fe_utilities.T_h(h);
    f := 0.0;
  end Tf_h;

  redeclare function h_Tf "find specific enthalpy from Temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.SpecificEnthalpy h "Specific Enthalpy (J/kg)";
  algorithm
    h := SolarTherm.Media.SolidParticles.Fe_utilities.h_T(T);
  end h_Tf;
  
  function k_Tf "find thermal conductivity from temperature"
    input SI.Temperature T;
    input Real f;
    output SI.ThermalConductivity k;
  algorithm
    k := SolarTherm.Media.SolidParticles.Fe_utilities.lamda_T(T); //because some genius decided to spell it that way
  end k_Tf;
    
  redeclare function rho_Tf "find density from temperature"
    input SI.Temperature T "Absolute temperature (K)";
    input Real f "Liquid mass fraction";
    output SI.Density rho "Density (kg/m3)";
  algorithm
    rho := SolarTherm.Media.SolidParticles.Fe_utilities.rho_T(T);
  end rho_Tf;
  annotation(
    Documentation(info = "<html><head></head><body><b>Assumptions:</b><div><b><br></b></div><div>Property lookup tables were constructed at Temperature&nbsp;<i>T</i>&nbsp;intervals of 10 K based on data from the following sources:</div><div><br></div><div>FactSage [1]:</div><div>Specific enthalpy, <i>h</i>&nbsp;(J/kg) measured relative to 298.15 K</div><div>Specific heat capacity <i>c_p </i>(J/kgK)</div><div>Absolute specific entropy <i>s </i>(J/kgK) measured relative to a perfect crystal at 0 K</div><div><br></div><div>Touloukian [2]:</div><div>Density, <i>rho</i>&nbsp;(kg/m3)</div><div><br></div><div>Kozlovskii [3]:</div><div>Thermal conductivity, <i>k</i>&nbsp;(W/mK)</div><div><br></div><div><br></div><div>Unit Cost of 0.50 USD_2020/kg (private comm.) assumed the same as pig iron, use with caution.</div><div><br></div><div><b>References:</b></div><div><b><br></b></div><div>[1] C.W. Bale, E. Bélisle, P. Chartrand, S.A. Decterov, G. Eriksson, A.E. Gheribi, K. Hack, I.H. Jung, Y.B. Kang, J. Melançon, A.D. Pelton, S. Petersen, C. Robelin, J. Sangster, P. Spencer, M.-A. Van Ende, <i>FactSage Thermochemical Software and Databases</i>, Calphad 54 (2016) 35–53.</div><div><br></div><div>[2]&nbsp;S. Touloukian, Metallic Elements and Alloys, n.d.</div><div><br></div><div>[3] Y.M. Kozlovskii, S.V. Stankus, The linear thermal expansion coefficient of iron in the temperature range of 130–1180 K, J. <i>Phys. Conf. Ser.</i> 1382 (2019) 012181. https://doi.org/10.1088/1742-6596/1382/1/012181.</div></body></html>"));
end Fe;