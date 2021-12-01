within SolarTherm.Models.Storage.Tank;
model Tank
  extends Interfaces.Models.StorageFluid;

//  SI.AbsolutePressure p "Pressure";
  parameter SI.Diameter D=18.667 "Diameter";
  parameter SI.Height H=20 "Height";
//  Real L "Level in %";

//protected

  parameter Boolean use_p_top = false
    "= true to get p_top from an input connector"
      annotation (Dialog(group="Assumptions"), Evaluate=true, HideResult=true, choices(checkBox=true));
      
  parameter SI.AbsolutePressure p_fixed=Medium.p_default
    "Fixed value of pressure" annotation (Evaluate = true,
                Dialog(group="Assumptions",enable = not use_p_top));
                
  parameter Boolean enable_losses = false
    "= true enable thermal losses with environment"
      annotation (Dialog(group="Assumptions"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter SI.CoefficientOfHeatTransfer alpha=1 "Constant heat transfer coefficient with the ambient"
    annotation (Dialog(group="Assumptions",enable = enable_losses));
  parameter Boolean use_L = false "= true to display level as output variable"
      annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));

  parameter Real L_start=70 "Start value of level in %" annotation (Dialog(group="Initialization"));
  parameter SI.Temperature T_start=from_degC(500) "Start value of temperature" annotation (Dialog(group="Initialization"));

  parameter SI.Temperature T_set=from_degC(500) "Tank Heater Temperature Set-Point" annotation (Dialog(group="Heater"));
  parameter SI.Power W_max= 30e8 "Hot Tank Heater Capacity"
                                                           annotation (Dialog(group="Heater"));
  parameter SI.Efficiency e_ht=0.99 "Tank Heater Efficiency"
                                                            annotation (Dialog(group="Heater"));

  SI.Volume V;

  SI.Mass m;

  Medium.BaseProperties medium;

 // SI.Temperature T=Medium.temperature(medium.state);
  SI.Area A;
  SI.HeatFlowRate Q_losses;
  Medium.ThermodynamicState state_i=Medium.setState_pTX(medium.p,T_start);

  SI.Power W_net;
  SI.Power W_loss;

  Modelica.Blocks.Interfaces.RealOutput L if use_L "Tank level in %"
                                          annotation (Placement(transformation(
          extent={{96,44},{116,64}}), iconTransformation(extent={{92,34},{112,54}})));
  Modelica.Blocks.Interfaces.RealInput p_top if use_p_top annotation (Placement(
        transformation(
        extent={{-16,-16},{16,16}},
        rotation=-90,
        origin={0,108}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={45,97})));

  Modelica.Blocks.Interfaces.RealInput T_amb if enable_losses annotation (Placement(
        transformation(
        extent={{-16,-16},{16,16}},
        rotation=-90,
        origin={0,108}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={-41,97})));

protected
  parameter SI.Volume V_t=(H*pi*D^2)/4;
  Modelica.Blocks.Interfaces.RealOutput L_internal;
  Modelica.Blocks.Interfaces.RealInput p_top_internal;
  Modelica.Blocks.Interfaces.RealInput T_amb_internal;

initial equation
  medium.h=Medium.specificEnthalpy(state_i);
  m=Medium.density(state_i)*V_t*L_start/100;
equation
  if use_L then
    connect(L_internal,L);
  end if;
  if use_p_top then
    connect(p_top_internal,p_top);
  else
    p_top_internal=p_fixed;
  end if;
    if enable_losses then
    connect(T_amb_internal,T_amb);
    Q_losses=-A*alpha*(medium.T-T_amb_internal);
    else
    T_amb_internal=Medium.T_default;
    Q_losses=0;
  end if;

  p_top_internal=medium.p;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;
  fluid_a.h_outflow=medium.h;
  fluid_b.h_outflow=medium.h;
  der(m)=fluid_a.m_flow+fluid_b.m_flow;
  m*der(medium.h)+der(m)*medium.h=Q_losses+W_net+fluid_a.m_flow*inStream(fluid_a.h_outflow)+fluid_b.m_flow*medium.h;

  V=m/medium.d;
  L_internal=100*V/V_t;
  A=2*pi*(D/2)*H*(L_internal/100);

  if noEvent(medium.T<T_set) then
    W_net=min(-Q_losses,W_max);
  else
    W_net=0;
  end if;

 W_loss=W_net/e_ht;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics = {Text(origin = {0, -140}, lineColor = {0, 0, 255}, extent = {{-120, 20}, {120, -20}}, textString = "%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Tank;
