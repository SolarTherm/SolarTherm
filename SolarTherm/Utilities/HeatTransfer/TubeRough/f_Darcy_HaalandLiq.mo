within SolarTherm.Utilities.HeatTransfer.TubeRough;

function f_Darcy_HaalandLiq "f_Darcy = f(Re, E_div_d), calculates Nusselt number based on Haaland approximation for liquids."
  input Real Re "Reynolds";
  input Real E_div_d "Ratio of surface roughness to hydraulic diameter of channel (-)";
  //input Real T_f "Fluid temperature";
  //input Real T_s "Wall temperature";
  output Real f "Friction Factor";
algorithm
  if Re <= 2300.0 then //Laminar
    f := 64.0/max(Re, 1.0e-6);
    
  elseif Re >= 4000.0 then //Turbulent
    //f := (0.790*log(Re) - 1.64)^(-2.0);
    f := 1.0/(((-1.8)*log10(((6.9/max(Re, 1.0e-6)) + (E_div_d/3.7)^1.11)))^2.0);
    
  else //Transition
    f := 64.0/2300.0 + SolarTherm.Utilities.Transition.Phis((Re - 2300.0) / 1700.0)*(1.0/(((-1.8)*log10(((6.9/4000.0) + (E_div_d/3.7)^1.11)))^2.0) - 64.0/2300.0);
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info= "<html><head></head><body><div><div>Darcy friction factor for internal flow of liquids through rough circular tubes.</div><div><br></div><div><div><b>Re &lt;= 2300</b></div><div>For laminar flow, the Darcy friction factor is 64/Re:</div><div>f_Darcy = 64/Re</div><div><br></div><div><b>Re &gt;= 4000</b></div><div>The Darcy friction factor for turbulent flow is calculated using the Haaland approximation of the implicit Coolbrook equation where n = 1 for liquids:</div><div><br></div><div>1/sqrt(f_Darcy) = (-1.8/n)*( log10( (6.9/Re)^3 + ((E/D)/3.7)^(1.11*n))</div><div>4000 &gt;= Re&nbsp;</div><div><br></div><div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>2300 &lt; Re &lt; 4000</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The Phis function is used to transition the value of f_Darcy.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">f_Darcy =&nbsp;f_Darcy(2300) + [ Phis((Re-2300)/(4000-2300)) ] * [&nbsp;f_Darcy(4000) -&nbsp;f_Darcy(2300) ]</div></div></div></div><div><br></div><img width=\"500\" src=\"modelica://SolarTherm/Resources//Utilities/HT_TubeRough_f_Liq.png\"></body></html>"));
end f_Darcy_HaalandLiq;