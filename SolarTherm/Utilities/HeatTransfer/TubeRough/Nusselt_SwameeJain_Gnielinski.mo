within SolarTherm.Utilities.HeatTransfer.TubeRough;

function Nusselt_SwameeJain_Gnielinski "Nu = f(Re,Pr,E/d), Nusselt number of a fluid flowing through a rough pipe"
  input Real Re "Reynolds Number (-)";
  input Real Pr "Prandtl Number (-)";
  input Real E_div_d "Ratio of surface roughness to hydraulic diameter of channel (-)";
  output Real Nu "Nusselt Number (-)";
protected
  Real f "Friction Factor (-)";
algorithm
  f := SolarTherm.Utilities.HeatTransfer.TubeRough.f_Darcy_SwameeJain(Re, E_div_d);

  if Re <= 2300.0 then //Laminar Flow
    Nu := 3.66;
    
  elseif Re >= 3000.0 then //Turbulent Flow
    Nu := ((f/8.0)*(Re-1000.0)*Pr)/(1.0+1.27*((f/8.0)^0.5)*((Pr^(2.0/3.0))-1.0));
    
  else //Transition Flow
    Nu := 3.66 + SolarTherm.Utilities.Transition.Phis((Re - 2300.0) / 700.0)*(((f/8.0)*(2000.0)*Pr)/(1.0+1.27*((f/8.0)^0.5)*((Pr^(2.0/3.0))-1.0)) - 3.66);
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html><head></head><body><div>Nusselt Number for a fluid flowing through a rough tube. Turbulent heat-transfer assumes the Gnielinski correlation developed for smooth tubes, but using the Darcy friction factor obtained via the Swamee Jain approximation of the implicit Coolbrook equation.</div><div><br></div><div>This leads to an overestimation of the Nusselt number. According to Incropera, <i>h</i>&nbsp;increases with wall roughness, and as a first approximation, it may be computed using the Gnielinski equation with <i>f</i>&nbsp;obtained from the Moody diagram. Although <i>h</i>&nbsp;generally increases with <i>f</i>, the increase in <i>f</i>&nbsp;is proportionally larger.</div><div><br></div><div><div><b>Re &lt;= 2300</b></div><div>For laminar flow, the Nusselt number is constant, based on the constant-temperature approximation:</div><div><br></div><div>Nu = 3.66</div><div>Re &lt; 2300</div><div><br></div><div><b>Re &gt;= 3000</b></div><div>For turbulent flow, the Nusselt number is calculated based on the Gnielinski correlation &nbsp;(approximate) for fully developed turbulent flow in smooth circular duct:</div><div><b><br></b></div><div>Nu = (Re*Pr*(f/8))/&nbsp;( 4.5 + (( 0.155*(Re*((f/8.0)^0.5))^0.54) + ((8.0/f)^0.5))*(Pr^0.5));</div><div><br></div><div>0.5 &lt;= Pr &lt;= 2000.0</div><div>3000 &lt;= Re &lt;= 5e6</div><div><br></div><div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>2300 &lt; Re &lt; 3000</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The Phis function is used to transition the value of Nu:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Nu =&nbsp;Nu(2300) + [&nbsp;Nu((Re-2300)/(3000-2300)) ] * [&nbsp;Nu(3000) -&nbsp;Nu(2300) ]</div></div></div><div><br></div><div><br></div><img width=\"500\" src=\"modelica://SolarTherm/Resources//Utilities/HT_TubeRough_Nu_Gas.png\"></body></html>"));
end Nusselt_SwameeJain_Gnielinski;