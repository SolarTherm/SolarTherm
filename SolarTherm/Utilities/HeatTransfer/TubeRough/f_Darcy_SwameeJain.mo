within SolarTherm.Utilities.HeatTransfer.TubeRough;

function f_Darcy_SwameeJain "f_Darcy = f(Re, E_div_d), calculates Nusselt number based on Swamee & Jain approximation for gases."
  input Real Re "Reynolds";
  input Real E_div_d "Ratio of surface roughness to hydraulic diameter of channel (-)";
  output Real f "Friction Factor";
algorithm
  if Re <= 2300.0 then //Laminar
    f := 64.0/max(Re, 1.0e-6);
    
  elseif Re >= 4000.0 then //Turbulent
    f := (-2.0*log10((E_div_d/3.7) + (5.74/(Re^0.9))))^(-2.0);

  else //Transition
    f := 64.0/2300.0 + SolarTherm.Utilities.Transition.Phis((Re - 2300.0) / 1700.0)*( (-2.0*log10((E_div_d/3.7) + (5.74/(4000.0^0.9))))^(-2.0) - 64.0/2300.0);
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info= "<html><head></head><body><div>Darcy friction factor for internal flow of gases through rough circular tubes.</div><div><br></div><div><div><b>Re &lt;= 2300</b></div><div>For laminar flow, the Darcy friction factor is 64/Re:</div><div>f_Darcy = 64/Re</div><div><br></div><div><b>Re &gt;= 4000</b></div><div>The Darcy friction factor for turbulent flow is calculated using the Haaland approximation of the implicit Coolbrook equation where n = 3 for gases:</div><div><br></div><div>1/sqrt(f_Darcy) = -2 log10 [(E/3.7*D) + (5.74/(Re^0.9))]</div><div>4000 &lt;= Re &lt;= 1e8&nbsp;</div><div>2e-8 &lt;= E/D &lt;= 0.1</div><div><br></div><div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>2300 &lt; Re &lt; 4000</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The Phis function is used to transition the value of f_Darcy.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">f_Darcy =&nbsp;f_Darcy(2300) + [ Phis((Re-2300)/(4000-2300)) ] * [&nbsp;f_Darcy(4000) -&nbsp;f_Darcy(2300) ]</div></div></div><div><br></div><div><br></div><img width=\"500\" src=\"modelica://SolarTherm/Resources//Utilities/HT_TubeRough_f_Darcy_SwameeJain.png\"></body></html>"));
end f_Darcy_SwameeJain;