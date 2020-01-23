model State "A model which calculates state and properties"
    parameter SI.SpecificEnthalpy h_start;
    SI.Density rho;
    SI.SpecificEnthalpy h (start=h_start);
    SI.Temperature T;
    SI.DynamicViscosity mu;
    SI.SpecificHeatCapacity cp;
    SI.ThermalConductivity k;
  equation
    k = 0.57;
    cp = 1550.0;
    mu = 0.0021;
    rho = 1733.0;
    h = 1550.0*T;
  end State;