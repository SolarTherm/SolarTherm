within SolarTherm.SolarPaces2019;

model PumpSimple_Sodium
function Hfg_Na //Enthalpy of vaporization of Sodium
    input Real T_Na;
    output Real h_fg;
algorithm
    h_fg := (393.37*(1.0-(T_Na/2503.7))+4398.6*((1.0-(T_Na/2503.7))^0.29302))*1.0E3;
end Hfg_Na;

	extends SolarTherm.SolarPaces2019.Pump_Energy;
	parameter Real k_loss(unit="J/kg")=0.55e3;
	parameter Real x_max = 0.2 "Maximum vapor quality of sodium";
	SI.Power W_loss "Parasitic work loss rate";
	SI.Temperature T_Na "Absolute Temperature of sodium pumped";
	SI.MassFlowRate m_flow "Mass Flow Rate of sodium pumped";
equation
	heat_a.Q_flow = -1.0*heat_b.Q_flow;
	heat_a.T = T_Na;
	heat_b.T = T_Na;
	m_flow = heat_a.Q_flow/(Hfg_Na(T_Na)*x_max);
	W_loss = k_loss*m_flow;
end PumpSimple_Sodium;