within SolarTherm.Models.Fluid.Flows;
function DarcyFrictionFactor "Computes the Darcy friction factor from mass flow rate"
    import SI = Modelica.SIunits;
    import Modelica.Math;
    import Modelica.Constants.pi;
    // Inputs  
    input SI.MassFlowRate m_flow;
    input SI.Area area;
    input SI.Density rho;
    input SI.DynamicViscosity mu;
    input SI.Diameter diameter;
    input SI.Length roughness;
    input SI.Length length;
    input SI.ReynoldsNumber Re_turbulent = 4000 "Turbulent flow if Re >= Re_turbulent (dummy if use_Re_turbulent = false)";
    output SI.Pressure dp "Pressure loss (dp = port_a.p - port_b.p)";
protected
    SI.ReynoldsNumber Re;
    SI.ReynoldsNumber Re1 = min(745*Math.exp(if Delta <= 0.0065 then 1 else 0.0065/Delta), Re_turbulent) "Re leaving laminar curve";    
    SI.ReynoldsNumber Re2 = Re_turbulent "Re entering turbulent curve";
    Real Delta = roughness/diameter "Relative roughness";
    Real lambda2 "Modified friction coefficient (= lambda*Re^2)";

    function interpolateInRegion2
       input SI.ReynoldsNumber Re;
       input SI.ReynoldsNumber Re1;
       input SI.ReynoldsNumber Re2;
       input Real Delta;
       output Real lambda2;
      // point lg(lambda2(Re1)) with derivative at lg(Re1)
    protected
      Real x1 = Math.log10(Re1);
      Real y1 = Math.log10(64*Re1);
      Real yd1=1;

      // Point lg(lambda2(Re2)) with derivative at lg(Re2)
      Real aux1=(0.5/Math.log(10))*5.74*0.9;
      Real aux2=Delta/3.7 + 5.74/Re2^0.9;
      Real aux3=Math.log10(aux2);
      Real L2=0.25*(Re2/aux3)^2;
      Real aux4=2.51/sqrt(L2) + 0.27*Delta;
      Real aux5=-2*sqrt(L2)*Math.log10(aux4);
      Real x2 =  Math.log10(Re2);
      Real y2 =  Math.log10(L2);
      Real yd2 = 2 + 4*aux1/(aux2*aux3*(Re2)^0.9);

      // Constants: Cubic polynomial between lg(Re1) and lg(Re2)
      Real diff_x=x2 - x1;
      Real m=(y2 - y1)/diff_x;
      Real c2=(3*m - 2*yd1 - yd2)/diff_x;
      Real c3=(yd1 + yd2 - 2*m)/(diff_x*diff_x);
      Real dx;
    algorithm
       dx := Math.log10(Re/Re1);
       lambda2 := 64*Re1*(Re/Re1)^(1 + dx*(c2 + dx*c3));
       annotation(smoothOrder=1);
    end interpolateInRegion2;
algorithm
    Re := diameter*abs(m_flow)/(area*mu);
    lambda2 := if Re <= Re1 then 64*Re else
              (if Re >= Re2 then 0.25*(Re/Math.log10(Delta/3.7 + 5.74/Re^0.9))^2 else
               interpolateInRegion2(Re, Re1, Re2, Delta));
    dp :=length*mu*mu/(2*rho*diameter*diameter*diameter)*(if m_flow >= 0 then lambda2 else -lambda2);

end DarcyFrictionFactor;