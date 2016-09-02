within SolarTherm.Models.Fluid.HeatExchangers;
model SHE "Simplified Heat Exchanger"
  extends SolarTherm.Interfaces.Models.HeatExchangerFluid;
  constant Real pi = Modelica.Constants.pi;
  constant Real g_n = Modelica.Constants.g_n;
  parameter SI.Area A=5 "Exchanger area" annotation(Dialog(group="Heat transfer parameters"));
  parameter SI.CoefficientOfHeatTransfer U=2500
    "Overall heat-transfer coefficient"                                             annotation(Dialog(group="Heat transfer parameters"));
  parameter SI.MassFlowRate tol=1e-7 "Minimun mass flow rate tolerance" annotation(Dialog(group="Heat transfer parameters"));

  MA.ThermodynamicState state_a1=MA.setState_phX(port_a_in.p,inStream(port_a_in.h_outflow),inStream(port_a_in.Xi_outflow));
  MB.ThermodynamicState state_b1=MB.setState_phX(port_b_in.p,inStream(port_b_in.h_outflow),inStream(port_b_in.Xi_outflow));
  MA.ThermodynamicState state_a2=MA.setState_pTX(port_a_out.p,T_a2,actualStream(port_a_out.Xi_outflow));
  MB.ThermodynamicState state_b2=MB.setState_pTX(port_b_out.p,T_b2,actualStream(port_b_out.Xi_outflow));

  SI.Temperature T_a1=MA.temperature(state_a1);
  SI.Temperature T_b1=MB.temperature(state_b1);
  SI.Temperature T_a2;
  SI.Temperature T_b2;

  SI.SpecificHeatCapacity Cp_a=MA.specificHeatCapacityCp(state_a1);
  SI.SpecificHeatCapacity Cp_b=MB.specificHeatCapacityCp(state_b1);
  SI.MassFlowRate m_flow_a=port_a_in.m_flow;
  SI.MassFlowRate m_flow_b=port_b_in.m_flow;
  Real W_a=max(tol*Cp_a,m_flow_a*Cp_a);
  Real W_b=max(tol*Cp_b,m_flow_b*Cp_b);
  Real mu_a;
  Real mu_b;
  Real alpha;
  SI.HeatFlowRate Q_a=-W_a*(T_a1-T_a2);
  SI.HeatFlowRate Q_b=W_b*(T_b1-T_b2);
equation
   port_a_in.m_flow+port_a_out.m_flow=0;
   port_b_in.m_flow+port_b_out.m_flow=0;
   port_a_in.h_outflow=inStream(port_a_out.h_outflow);
   port_a_out.h_outflow=state_a2.h;
   port_b_in.h_outflow=inStream(port_b_out.h_outflow);
   port_b_out.h_outflow=state_b2.h;
   port_a_in.p=port_a_out.p;
   port_b_in.p=port_b_out.p;
   port_a_in.Xi_outflow=inStream(port_a_out.Xi_outflow);
   port_a_out.Xi_outflow=inStream(port_a_in.Xi_outflow);
   port_b_in.Xi_outflow=inStream(port_b_out.Xi_outflow);
   port_b_out.Xi_outflow=inStream(port_b_in.Xi_outflow);
    if (m_flow_a<=0) or
                      (m_flow_b<=0) then
      mu_a=0;
      mu_b=0;
      alpha=0;
    else
      alpha=U*A*((1/W_a)-(1/W_b));
      mu_a=(1-exp(-alpha))/(1-(W_a/W_b)*exp(-alpha));
      mu_b=(W_a/W_b)*mu_a;
    end if;
    T_a2=T_a1-mu_a*(T_a1-T_b1);
    T_b2=T_b1+mu_b*(T_a1-T_b1);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end SHE;
