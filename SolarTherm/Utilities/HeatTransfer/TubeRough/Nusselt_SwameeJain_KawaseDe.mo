within SolarTherm.Utilities.HeatTransfer.TubeRough;

function Nusselt_SwameeJain_KawaseDe "Nu = f(Re,Pr,E/d), calculates Nusselt number of a gas flowing through a rough pipe"
  input Real Re "Reynolds Number (-)";
  input Real Pr "Prandtl Number (-)";
  input Real E_div_d "Ratio of surface roughness to hydraulic diameter of channel (-)";
  output Real Nu "Nusselt Number (-)";
protected
  Real f "Friction Factor (-)";
  //Real Pr_t "Turbulent Prandtl Number (assumed relation for Pr <= 145)";
algorithm
  f := SolarTherm.Utilities.HeatTransfer.TubeRough.f_Darcy_SwameeJain(Re, E_div_d);
  //Pr_t := 1.01 - 0.09*(Pr^0.36);
  
  if Re <= 2300.0 then //Laminar
    Nu := 3.66;
    
  elseif Re >= 5000.0 then
    Nu := 0.0471*Re*(Pr^0.5)*((0.25*f)^0.5)*(1.11 + 0.44*(Pr^(-1.0/3.0)) - 0.7*(Pr^(-1.0/6.0))); 

  else //Use Phis
    Nu := 3.66 + SolarTherm.Utilities.Transition.Phis((Re - 2300.0) / 2700.0)* (0.0471*5000*(Pr^0.5)*((0.25*f)^0.5)*(1.11 + 0.44*(Pr^(-1.0/3.0)) - 0.7*(Pr^(-1.0/6.0))) - 3.66);
    //Nu := max(3.66,((Re - 1000.0)*Pr*f/8.0) / (1.0 + ((f/8.0)^0.5)*((17.42 - 13.77*(Pr_t^0.8))*((Re*E_div_d)^0.5) - 8.48 ) ));
  end if;
//Laminar
//Turbulent
//Transition
//Nu = Nu_low + Phis*(Nu_high-Nu_low)
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html><head></head><body><div>Nusselt number for internal flow of gases through rough circular tubes.</div><div><br></div><div>Friction factor is calculated using the function SolarTherm.Utilities.TubeRough.f_Darcy_SwameeJain</div><div><br></div><div><div><b>Re &lt;= 2300</b></div><div>For laminar flow, the Nusselt number is constant, based on the constant-temperature approximation:</div><div><br></div><div>Nu = 3.66</div><div>Re &lt;= 2300</div><div><br></div><div><b>Re &gt;= 5000</b></div><div>For turbulent flow, the Nusselt number is calculated based on the Kawase &amp; De's correlation for fully developed turbulent flow in the fully rough flow regime of a circular duct:</div><div><b><br></b></div><div>Nu = 0.0471*Re*(Pr^0.5)*[(f/4)^0.5]*[1.11+0.44*(Pr^(-1/3))-0.7*(Pr^(-1/6))];</div><div><br></div><div>0.0024 &lt;= E_div_d &lt;= 0.165</div><div>5.1 &lt;= Pr &lt;= 390</div><div>5000 &lt;= Rev &lt;= 5e5</div><div><br></div><div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>2300 &lt; Re &lt; 5000</b></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The Phis function is used to transition the value of Nu:</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Nu =&nbsp;Nu(2300) + [&nbsp;Nu((Re-2300)/(5000-2300)) ] * [&nbsp;Nu(5000) -&nbsp;Nu(2300) ]</div></div></div><div><br></div><img width=\"500\" src=\"modelica://SolarTherm/Resources//Utilities/HT_TubeRough_Nu_SwameeJain_KawaseDe.png\"></body></html>"));
end Nusselt_SwameeJain_KawaseDe;