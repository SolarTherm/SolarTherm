within SolarTherm.Models.PowerBlocks.Correlation;
model sCO2_test "A sCO2 cycle regression model (Tco=45)"
	extends Cycle;

protected
	Real T_ND "Non-dimensional temperature";

equation
	T_ND=(T_in)/(T_in_ref);
	k_q=if T_ND<=1 then (1.464495 -1.57142 *T_ND + 0.930642 *T_ND^2) else (0.695947936 + 0.303946064*T_ND);
	k_w=if T_ND<=1 then (0.927163 - 1.23535*T_ND + 1.35823 *T_ND^2) else (0.30824912 + 0.69164188*T_ND);
end sCO2_test;