within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2 "A sCO2 cycle regression model (Tco=45)"
	extends Cycle;
equation
	k_q=if T_ND<=1 then (-1.429342371 + 2.429236371*T_ND) else (0.695947936 + 0.303946064*T_ND);
	k_w=if T_ND<=1 then (-1.800050594 + 2.799941594*T_ND) else (0.30824912 + 0.69164188*T_ND);
end sCO2;
