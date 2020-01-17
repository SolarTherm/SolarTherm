within SolarTherm.Models.CSP.CRS.Receivers;
model SodiumReceiver_new "ReceiverSimple with convective losses"
  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
  SI.SpecificEnthalpy h_in(start=h_in_0,nominal=h_in_0);
  SI.SpecificEnthalpy h_out(start=h_out_0,nominal=h_out_0);
  SI.Temperature T_in=Medium.temperature(state_in);
  SI.Temperature T_out=Medium.temperature(state_out);
  
  parameter SI.Length H_rcv=1 "Receiver height" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_rcv=1 "Receiver diameter" annotation(Dialog(group="Technical data"));
  parameter Integer N_pa = 1 "Number of panels" annotation(Dialog(group="Technical data"));
  parameter Integer N_fl = 1 "Number of parallel flow-paths" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_tb=1 "Tube outer diameter" annotation(Dialog(group="Technical data"));
  parameter SI.Thickness t_tb=1 "Tube wall thickness" annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency ab=1 "Coating absortance" annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency em=1 "Coating Emitance" annotation(Dialog(group="Technical data"));
  parameter SI.CoefficientOfHeatTransfer alpha=1 "Convective heat transfer coefficient";
  
  SI.CoefficientOfHeatTransfer alphas;
  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rad;
  SI.HeatFlowRate Q_con;
  SI.HeatFlowRate Q_rcv(start=0);
  
  Real T_av4( final unit="K4")= ((T_in^4)/5 + ((T_in^3)*(T_out))/5 + ((T_in^2)*(T_out^2))/5 + ((T_in)*(T_out^3))/5 + (T_out^4)/5);
  SI.Temperature T_av=T_in/2+T_out/2;
  SI.Temperature Tw_in=T_in+DT;
  SI.Temperature Tw_out=T_out+DT;
  Real Tw_av4( final unit="K4")=((Tw_in^4)/5 + ((Tw_in^3)*(Tw_out))/5 + ((Tw_in^2)*(Tw_out^2))/5 + ((Tw_in)*(Tw_out^3))/5 + (Tw_out^4)/5);
  SI.Temperature Tw_av=Tw_in/2+Tw_out/2;
  SI.TemperatureDifference DT(final start=0);
  Real eff;

  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));
  parameter SI.Temperature T_in_0=from_degC(540) "Start value of inlet temperature";
  parameter SI.Temperature T_out_0=from_degC(740) "Start value of inlet temperature";
  Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
        transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
            -24,-98},{-12,-86}})));
  
  Modelica.Blocks.Interfaces.RealOutput Q_out annotation (
    Placement(visible = true, transformation(origin = {31, -23}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {31, -23}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

protected
  parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
  parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
  parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
  parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
  parameter SI.Area A_out=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
  parameter SI.Area A_in=N_pa*N_tb_pa*H_rcv*pi*(D_tb-2*t_tb)/2 "Area";
  
  parameter Medium.ThermodynamicState state_in_0=Medium.setState_pTX(Medium.p_default,T_in_0);
  parameter Medium.ThermodynamicState state_out_0=Medium.setState_pTX(Medium.p_default,T_out_0);
  parameter SI.SpecificEnthalpy h_in_0=Medium.specificEnthalpy(state_in_0);
  parameter SI.SpecificEnthalpy h_out_0=Medium.specificEnthalpy(state_out_0);
  
  Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,h_in);
  Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_b.p,h_out);
  Medium.ThermodynamicState states=Medium.setState_pTX(medium.p,T_av);
  Medium.Density rhos=Medium.density(states) "Density";
  Medium.ThermalConductivity lambdas= Medium.thermalConductivity(states) "Thermal conductivity";
  SI.Velocity vs "Mean velocity of fluid flow";
equation
  medium.h=(h_in+h_out)/2;
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=h_out;
  fluid_a.h_outflow=0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;

  Q_rad=A_out*sigma*em*(Tw_av4-Tamb^4);
  Q_con=A_out*alpha*(Tw_av-Tamb);

  vs = fluid_a.m_flow/((N_fl*N_tb_pa)*rhos*(pi*(D_tb-2*t_tb)^2)/4);
  alphas = HTC_receiver(state_mean_Na = states, v_Na=vs, d_i = D_tb-2*t_tb);

  DT=max(0,Q_rcv/max(1e-3,A_in*alphas));

  if on then    // 0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
   Q_loss=-Q_rad-Q_con;
  else     // h_out=h_in;
   Q_loss=0;
  end if;
  
  0=ab*heat.Q_flow+Q_loss+max(1e-3,fluid_a.m_flow)*(h_in-h_out);
  Q_rcv=fluid_a.m_flow*(h_out-h_in);
  eff=Q_rcv/max(1,heat.Q_flow);
  Q_out=(heat.Q_flow)*max(0.72,eff);
  
  annotation (Documentation(info="<html>
<h4>Brief description:</h4>
<p>This model simulate an external receiver that is composed by a series of flat panels with the a vertical arragement of tubes. This panels are arranged around the circunference of the solar tower. The coating absortance and emittance of the tubes determine the receiver thermal losses. It assumes a single receiver temperature which is calculated acording the average temperature between the inlet and outlet fluid temperature. In this model a mass flow rate is heated as a function of the concentrated solar power considering thermal losses but neglecting effects due to receiver shape and thermal capacitances. The outlet specific enthaply is calculated in an algebraic way assuming that:</p>
<pre>heat flow rate absorbed = heat flow rate emitted + mass flow rate * (outlet specific enthalpy - inlet specific enthalpy)</pre>
<p>This model allows zero mass flow rate althought the model only guarantees the results at the operating range.</p>
<h4>Inputs:</h4>
<h5>HeatPort:</h5>
<ul>
<li>heat: This connector provides the total concentrated solar power that reachs the receiver and gives the temperature of the receiver.</li>
<h5>FluidPort:</h5>
<li>fluid_a: This connector provides the inlet mass flow rate and specific enthalpy of the system working fluid, the pressure is not used.</li>
</ul>
<h4>Parameters:</h4>
<h5>Working fluid:</h5>
<ul>
<li>Medium: This parameter defines the medium in the component. The thermodynamic properties of the fluid are function of this medium model. All Modelica.Media can be selected and new ones that extend from the Partial Medium</li>
</ul>
<h5>Technical data:</h5>
<ul>
<li>H_rcv: Height of the receiver panels.</li>
<li>D_rcv: Total diameter of the receiver. The double distance between the center of the tower to a center of a receiver panel.</li>
<li>N_pa: Total number of panels.</li>
<li>D_tb: The outer diameter of the panel tubes.</li>
<li>t_tb: The thickness of panel tubes.</li>
<li>ab: The absorptance of the receiver coating.</li>
<li>em: The emissivity of the receiver coating.</li>
</ul>
<h4>Outputs:</h4>
<h5>FluidPort:</h5>
<ul>
<li>fluid_b: This connector provides the outlet mass flow rate and specific enthalpy of the system working fluid, the pressure is not used.</li>
</ul>
</html>"));
end SodiumReceiver_new;