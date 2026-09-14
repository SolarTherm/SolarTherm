within SolarTherm.Utilities.HeatTransfer.TubeSmooth;

function f_Darcy_Petukhov "f_Darcy = f(Re), calculates the Darcy friction factor according to Petukhov's correlation for smooth tubes."
  input Real Re "Reynolds";
  output Real f "Darcy Friction Factor";
algorithm
  if Re <= 2300.0 then //Laminar
    f := 64.0/max(Re, 1.0e-6);
    
  elseif Re >= 3000.0 then //Petukhov's correlation for smooth tube
    f := (0.790*log(Re) - 1.64)^(-2.0);
    
  else //Transition
    f := (64.0/2300.0) + SolarTherm.Utilities.Transition.Phis((Re - 2300.0) / 700.0)*((0.790*log(3000.0) - 1.64)^(-2.0) - (64.0/2300.0)); //f = f_low + Phis*(f_high-f_low)
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info= "<html><head></head><body><div>Darcy friction factor for internal flow of gases through smooth circular tubes.</div><div><br></div><div><b>Re &lt;= 2300</b></div><div>The Darcy friction factor for laminar flow is used.</div><div>f_Darcy = 64/Re</div><div><br></div><div><b>Re &gt;= 3000</b></div><div>The Darcy friction factor for smooth surface condition developed by Petukhov was used:</div><div><br></div><div>f_Darcy = (0.790*ln(Re)-1.64)^(-2)</div><div>3000 &lt;= Re &lt;= 5.0e6</div><div><br></div><div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>2300 &lt; Re &lt; 3000</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The Phis function is used to transition the value of f.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">f_Darcy =&nbsp;f_Darcy(2300) + [ Phis((Re-2300)/(3000-2300)) ] * [&nbsp;f_Darcy(3000) -&nbsp;f_Darcy(2300) ]</div></div><div><br></div><img width=\"500\" src=\"modelica://SolarTherm/Resources//Utilities/HT_TubeSmooth_f.png\"></body></html>"));
end f_Darcy_Petukhov;