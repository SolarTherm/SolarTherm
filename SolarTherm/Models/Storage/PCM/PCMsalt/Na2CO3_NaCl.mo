within SolarTherm.Models.Storage.PCM.PCMsalt;

package Na2CO3_NaCl
  extends PCM.PCMsalt.PartialSalt(T_melting=635 + 273.15, L_melting=
        311.6e3);

  redeclare function extends specificHeat_liquid
      extends Modelica.Icons.Function;
      input State state;
      output Modelica.SIunits.SpecificHeatCapacity cp;
  algorithm
      cp := 1.5e3;
  end specificHeat_liquid;

    redeclare function extends specificHeat_solid
      extends Modelica.Icons.Function;
      input State state;
      output Modelica.SIunits.SpecificHeatCapacity cp;
    algorithm
      cp := 1.2e3;
    end specificHeat_solid;

  redeclare function extends density
      extends Modelica.Icons.Function;
      input State state;
      output Modelica.SIunits.Density rho;
  algorithm
      rho:=2.2e3;
  end density;

end Na2CO3_NaCl;
