within SolarTherm.Models.Storage.PCM.PCMsalt;

package PartialSalt
  extends Modelica.Icons.MaterialPropertiesPackage;
  constant Modelica.SIunits.Temperature T_melting;
  constant Modelica.SIunits.SpecificEnthalpy L_melting;
  record State
    extends Modelica.Icons.Record;
    Modelica.SIunits.Temperature T;
  end State;

  replaceable partial function setState_T
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T;
    output State state;
  algorithm
    state := State(T = T);
  end setState_T;

  replaceable partial function specificHeat_liquid
    extends Modelica.Icons.Function;
  end specificHeat_liquid;

  replaceable partial function specificHeat_solid
    extends Modelica.Icons.Function;
  end specificHeat_solid;

  replaceable partial function density
    extends Modelica.Icons.Function;
  end density;

end PartialSalt;
