within SolarTherm.Models.Storage.PCM;

function Q_bot
	input Real T_HTF;
    input Real T_PCM;
    input Real A; // Cross Sectional Area
    input Real dz_PCM; //Thickness of bottom PCM element
    input Real k_PCM; //Thermal conductivity pf bottom PCM element
	input Real k_gas;
	input Real C_convection;
	input Real D_tray;
    output Real Q; //RAte of heat transfer (J/s)
protected
    Real R_PCM; //Thermal resistivity componennt of half the PCM element's top node
	Real h_conv;
	Real R_total;
algorithm
    R_PCM := 0.5*dz_PCM/k_PCM;
	if T_HTF - T_PCM > 0.0 then //condensation heat transfer
		h_conv := 0.0;
		R_total := R_PCM;
		Q := A*(T_HTF-T_PCM)/R_total;
	else //convection heat transfer
		h_conv := 2.08*(k_gas/D_tray)*((C_convection*abs(T_PCM-T_HTF)*(D_tray^3.0))^0.2);
		R_total := R_PCM + 1.0/h_conv;
		Q := A*(T_HTF-T_PCM)/R_total;
	end if;
end Q_bot;