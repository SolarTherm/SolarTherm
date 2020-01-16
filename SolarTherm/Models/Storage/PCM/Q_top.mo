within SolarTherm.Models.Storage.PCM;

function Q_top
	input Real T_HTF;
    input Real T_PCM;
    input Real A; // Cross Sectional Area
    input Real dz_PCM; //Thickness of bottom PCM element
    input Real k_PCM; //Thermal conductivity pf bottom PCM element
    output Real Q; //RAte of heat transfer (J/s)
protected
    Real R_PCM; //Thermal resistivity componennt of half the PCM element's top node
algorithm
    R_PCM := 0.5*dz_PCM/k_PCM;
    Q := A*(T_HTF-T_PCM)/R_PCM;
end Q_top;