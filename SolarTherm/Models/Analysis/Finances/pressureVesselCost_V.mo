within SolarTherm.Models.Analysis.Finances;
function pressureVesselCost_V "Capital cost of a horizontal cylindrical pressure vessel with elipsoidal heads (2:1 semi-elliptical heads) as a function of volume"
	import SI = Modelica.SIunits;
	import nSI = Modelica.SIunits.Conversions.NonSIunits;
	import CN = Modelica.Constants;
	import CV = Modelica.SIunits.Conversions;
	import FI = SolarTherm.Models.Analysis.Finances;

	type Pressure_psi = Real(final quantity = "Pressure", final unit = "psi");
	type Density_lb_in = Real(final quantity = "Density", final unit = "lb/in3", min = 0);
	type Mass_lb = Real(quantity = "Mass", final unit = "lb", min = 0);
	type Length_in = Real(final quantity = "Length", final unit = "in", min = 0);

	extends Modelica.Icons.Function;

	input Modelica.SIunits.Volume V "Tank volume";
	output Real outputs[2] "The outputs vector consisitng n_st and C_cap"; 

	function volume_d "Tank volume as a function of internal diameter"
		extends Modelica.Icons.Function;
		input Length_in d1 "Tank internal diameter";
		output Modelica.SIunits.Volume V1 "Tank volume";
	algorithm
		V1 := 19.0*CN.pi*((d1*0.0254)^3)/12.0;
	end volume_d;

	function diameter_v "Tank internal diameter as a function of volume"
		extends Modelica.Icons.Function;
		input Modelica.SIunits.Volume V2 "Tank volume";
		output Length_in d6 "Tank internal diameter";
	algorithm
		d6 := 39.3701 * (((12.0*V2) / (19.0*CN.pi))^(1.0/3.0));
	end diameter_v;

	function pressure "Tank internal design gauge pressure as a function of tank operating gauge pressure"
		extends Modelica.Icons.Function;
		input Pressure_psi p1 "Tank operating gauge pressure";
		output Pressure_psi p_des "Tank internal design gauge pressure";
	algorithm
		p_des := exp(0.60608 + 0.91615*log(p1) + 0.0015655*(log(p1)^2.0));
	end pressure;

	function thickness "Wall thickness to withstand the internal pressure"
		extends Modelica.Icons.Function;
		input Pressure_psi p2 "Tank internal design gauge pressure";
		input Length_in d2 "Tank internal diameter";
		input Pressure_psi s1 "Maximum allowable stress of the shell material at the design temperature";
		input Real e1 "Fractional weld efficiency";
		output Length_in t1 "Tank thickness";
	algorithm
		t1 := (p2 * d2) / (2.0*s1*e1 - 1.2*p2);
	end thickness;

	function thickness_min "Minimum thickness allowed at the diameter given"
		extends Modelica.Icons.Function;
		input Length_in d3 "Tank internal diameter";
		output Length_in t2 "Tank minimum thickness";
	algorithm
		if (d3*0.0833333) > 12.0 then // i.e. d3 > 12 ft
			t2 := 5.0/8.0;
		elseif (d3*0.0833333) <= 12.0 and (d3*0.0833333) > 10.0 then // i.e. 10 < d3 <= 12 ft
			t2 := 1.0/2.0;
		elseif (d3*0.0833333) <= 10.0 and (d3*0.0833333) > 8.0 then // i.e. 8 < d3 <= 10 ft
			t2 := 7.0/16.0;
		elseif (d3*0.0833333) <= 8.0 and (d3*0.0833333) > 6.0 then // i.e. 6 < d3 <= 8 ft
			t2 := 3.0/8.0;
		elseif (d3*0.0833333) <= 6.0 and (d3*0.0833333) > 4.0 then // i.e. 4 < d3 <= 6 ft
			t2 := 5.0/16.0;
		else // i.e. 0 < d3 <= 4 ft
			t2 := 0.25;
		end if;
	end thickness_min;

	function weight "Weight of the shell and the two 2:1 elliptical heads"
		extends Modelica.Icons.Function;
		input Length_in d4 "Tank internal diameter";
		input Length_in t3 "Tank thickness";
		input Length_in l1 "Tank length accounting for the cylinder only";
		input Density_lb_in rho1 "Density of the tank material";
		output Mass_lb w1 "Tank weight";
	algorithm
		w1 := CN.pi* (d4 + t3) * (l1 + 0.8*d4) * t3*rho1;
	end weight;

	function CostEmpty_st "The f.o.b purchase cost of the empty vessel"
		extends Modelica.Icons.Function;
		input Mass_lb w2 "Tank weight";
		input Real uf1 "Update factor";
		input Real r_cur1 "The currency rate from AUD to USD";
		output FI.Money C_v "The f.o.b purchase cost of the empty vessel in AUD";
	algorithm
		C_v :=  exp(8.9552 - 0.2330 * log(w2) + 0.04333*(log(w2)^2.0)) * uf1 / r_cur1;
	end CostEmpty_st;

	function CostAdd_st "The added cost of the platforms and ladders"
		extends Modelica.Icons.Function;
		input Length_in d5 "Tank internal diameter";
		input Real uf2 "Update factor";
		input Real r_cur2 "The currency rate from AUD to USD";
		output FI.Money C_pl "The added cost of the platforms and ladders in AUD";
	algorithm
		C_pl :=  2005 * (d5^0.20294) * uf2 / r_cur2;
	end CostAdd_st;

	function Cost_st "The total f.o.b. purchase cost of the vessel"
		extends Modelica.Icons.Function;
		input Real fm1 "Material factor ";
		input FI.Money C_v1 "The f.o.b purchase cost of the empty vessel";
		input FI.Money C_pl1 "The added cost of the platforms and ladders";
		output FI.Money C_st "The f.o.b. purchase cost of the vessel in AUD";
	algorithm
		C_st :=  fm1 * C_v1 + C_pl1;
	end Cost_st;

protected
	//Parameters:
	parameter Real ar = 6.0 "Tank aspect ration";

	parameter Pressure_psi p_amb = 1 * 14.5038 "The atmospheric pressure";
	parameter Pressure_psi p_st_a = 3 * 14.5038 "Tank operating absolute pressure";
	parameter Pressure_psi p_st_g = p_st_a - p_amb "Tank operating gauge pressure";
	parameter nSI.Temperature_degF T_st = (9.0/5.0) * 25.0 + 32.0  "Tank medium temperature";

	parameter Pressure_psi s = 15000.0 "Maximum allowed stress of the shell material at the design temperature";
	parameter Real e = 0.85 "Fractional weld efficiency";

	parameter Density_lb_in rho = 0.284 "Density of low-alloy steel";
	parameter Real fm = 1.2 "Material factor for Low-alloy steel";

	parameter Mass_lb w_lb = 1000.0 "Minimum weight possible for one single tank";
	parameter Mass_lb w_ub = 920000.0 "Maximum weight possible for one single tank";

	parameter Real ci_present =  556.8 "Chemical engineering plant cost index (CI) at present"; // i.e. for 2016
	parameter Real ci_ref = 500 "Chemical engineering plant cost index (CI) at the reference year"; // Ref: Seider's texbook
	parameter Real uf = ci_present/ci_ref "Update factor";
	parameter Real r_cur = 0.7617 "The currency rate from AUD to USD"; // Valid for 2016

	parameter Length_in d_lb = 50.0 "Minimum internal diameter allowed constrained by w_lb";
	parameter Length_in d_ub = 455.2 "Maximum internal diameter allowed constrained by w_ub";

	parameter SI.Volume V_lb = volume_d(d_lb) "Minimum volume allowed constrained by w_lb";
	parameter SI.Volume V_ub = volume_d(d_ub) "Maximum volume allowed constrained by w_ub";

	parameter Length_in l_lb = ar * d_lb "Minimum length of the vessel allowed constrained by w_lb";
	parameter Length_in l_ub = ar * d_ub "Maximum length of the vessel allowed constrained by w_ub";

	parameter Pressure_psi p_d = pressure(p_st_g) "Tank internal design gauge pressure";
	parameter nSI.Temperature_degF T_d = T_st + 50.0 "Tank design temperature";

	parameter Length_in t_p_ub = thickness(p_d,d_ub, s, e) "Wall thickness for the largest tank allowed";
	parameter Length_in t_ub_min = thickness_min(d_ub) "Minimum thickness at the diameter given for the largest tank allowed";
	parameter Length_in t_d_ub = if t_p_ub < t_ub_min then t_ub_min elseif t_p_ub > 3.1 then 3.1 else t_p_ub "Thickness of steel plate required for the largest tank allowed";

	parameter Length_in t_p_lb = thickness(p_d,d_lb, s, e) "Wall thickness for the smallest tank allowed";
	parameter Length_in t_lb_min = thickness_min(d_lb) "Minimum thickness at the diameter given for the smallest tank allowed";
	parameter Length_in t_d_lb = if t_p_lb < t_lb_min then t_lb_min elseif t_p_lb > 3.1 then 3.1 else t_p_lb "Thickness of steel plate required for the smallest tank allowed";

	parameter Real w_lb_check = weight(d_lb, t_d_lb, l_lb, rho) "Weight of the shell and the two heads for the smallest tank allowed";
	parameter Real w_ub_check = weight(d_ub, t_d_ub, l_ub, rho) "Weight of the shell and the two heads for the largest tank allowed";

	//Variables:
	Integer n_st "Number of tanks required";
	FI.Money C_cap "Capital cost in AUD";
	Modelica.SIunits.Volume V_unit "Volume of each tank"; 
	Length_in d_unit "Internal diameter of each tank";
	Length_in l_unit "Length of each tank";
	Length_in t_p_unit "Wall thickness of each tank"; 
	Length_in t_p_unit_min "Minimum thickness at the diameter given for each tank"; 
	Length_in t_d_unit "Thickness of steel plate required at design for each tank";
	Mass_lb w_unit "Weight of the shell and the two heads of each tank"; 
	FI.Money C_v_unit "The f.o.b purchase cost of the empty vessel of each tank in AUD";
	FI.Money C_pl_unit "The added cost of the platforms and ladders of each tank in AUD";
	FI.Money C_p_unit "The total f.o.b. purchase cost of each tank in AUD";

algorithm
	//Refs: "Product and Process Design Principles: Synthesis, Analysis and Design", W.D. Seider et al., 3rd Edition 2008 and "Pressure Vessel Design Manual", D.R. Moss, 4th Edition 2012.
	// Capital cost of horizontal cylindrical pressure vessel with elipsoidal heads (2:1 semi-elliptical heads): valid for operating pressure from 10 to 1000 psig and weight from 1000 lb to 920000 lb.
	if V <> 0.0 then
		assert(w_lb_check > w_lb , "Tank weight may be below the minimum limit! You may need check the value of minimum diamater allowed.", level = AssertionLevel.warning);
		assert(abs((w_ub_check - w_ub) / w_ub) <= 0.001, "Tank weight is beyond the maximum limit! The maximum diamater allowed may need to be changed.", level = AssertionLevel.warning);

		n_st := integer(ceil(V/V_ub));

		if V < V_lb then
			V_unit := V_lb;
		else
			V_unit := V / n_st;
		end if;

		d_unit := diameter_v(V_unit);
		l_unit := ar * d_unit;
		t_p_unit := thickness(p_d,d_unit, s, e);
		t_p_unit_min := thickness_min(d_unit);
		t_d_unit := if t_p_unit < t_p_unit_min then t_p_unit_min elseif t_p_unit > 3.1 then 3.1 else t_p_unit;
		w_unit := weight(d_unit, t_d_unit, l_unit, rho);
		C_v_unit := CostEmpty_st(w_unit, uf, r_cur);
		C_pl_unit := CostAdd_st(d_unit, uf, r_cur);
		C_p_unit := Cost_st(fm, C_v_unit, C_pl_unit);

		C_cap := n_st * C_p_unit;
		outputs := {n_st, C_cap};
	else
		outputs := {0, 0.0};
	end if;
end pressureVesselCost_V;
