within SolarTherm.Models.Storage.Tank;
model Tank
  extends Interfaces.Models.StorageFluid;
  SI.Mass m;
  parameter SI.Temperature T_start=from_degC(500);
  Medium.BaseProperties medium;
//  SI.AbsolutePressure p "Pressure";
  parameter SI.Diameter D=18.667 "Diameter";
  parameter SI.Height H=20 "Height";
//  Real L "Level in %";
  parameter Real L_start=70 "Inital level in %";
//protected
  Medium.ThermodynamicState state_i=Medium.setState_pTX(medium.p,T_start);

  parameter Boolean use_L = false "= true to display level as output variable"
      annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_p_top = false
    "= true to provide p_top as input variable"
      annotation (Dialog(group="Operating strategy"), Evaluate=true, HideResult=true, choices(checkBox=true));

  SI.Volume V;
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
        origin={-1,99})));
  parameter SI.AbsolutePressure p_fixed=1e5;
protected
    parameter SI.Volume V_t=(H*pi*D^2)/4;
     Modelica.Blocks.Interfaces.RealOutput L_internal;
  Modelica.Blocks.Interfaces.RealInput p_top_internal;
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
  p_top_internal=medium.p;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;
  fluid_a.h_outflow=medium.h;
  fluid_b.h_outflow=medium.h;
  der(m)=fluid_a.m_flow+fluid_b.m_flow;
  m*der(medium.h)+der(m)*medium.h=fluid_a.m_flow*inStream(fluid_a.h_outflow)+fluid_b.m_flow*medium.h;

  V=m/medium.d;
  L_internal=100*V/V_t;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Tank;
