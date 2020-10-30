within SolarTherm.Models.Control;
block PID_AW_reset3 "PI-with anti-windup and reset"
  import Modelica.Blocks.Types.InitPID;
  import Modelica.Blocks.Types.Init;
  extends Modelica.Blocks.Interfaces.SISO;

  //parameter Real k(unit="1")=1 "Gain";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small, start=0.5)
    "Time Constant of Integrator";

  parameter Modelica.Blocks.Types.InitPID initType= Modelica.Blocks.Types.InitPID.InitialOutput
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == InitPID.InitialOutput, group=
          "Initialization"));
  constant Modelica.SIunits.Time unitTime=1 annotation (HideResult=true);
  parameter Real Kp,  uMax, uMin;
  parameter Modelica.SIunits.Time Tt;

  Modelica.Blocks.Math.Gain P(k=Kp) "Proportional part of PID controller"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}},  rotation=0)));
  Modelica.Blocks.Continuous.Integrator I(
    y_start=y_start/Kp,
    k=unitTime/1,
    initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Integral part of PID controller" annotation (Placement(transformation(
          extent={{-14,-12},{6,8}},  rotation=0)));
  Modelica.Blocks.Math.Add  Add annotation (Placement(transformation(extent={{28,-4},
            {36,4}},       rotation=0)));
  Modelica.Blocks.Math.Gain P1(k=Kp/Ti) "Proportional part of PID controller"
    annotation (Placement(transformation(extent={{-70,-12},{-46,12}}, rotation=0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=uMax, uMin=uMin)
    annotation (Placement(transformation(extent={{64,-8},{80,8}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={73,-29})));
  Modelica.Blocks.Math.Gain gain1(k=1/Tt)
    annotation (Placement(transformation(extent={{56,-50},{44,-38}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{-38,-8},{-28,2}})));
    Modelica.Blocks.Interfaces.BooleanInput reset annotation(Placement(visible=true, transformation(origin={-120,-60}, extent={{-20,-20},{20,20}}, rotation=0), iconTransformation(origin={-120,-80}, extent={{-20,-20},{20,20}}, rotation=-360)));
initial equation
//   if initType==InitPID.InitialOutput then
//      y = y_start;
//   end if;

equation
  when reset then
    reinit(I.y, (y_start/Kp)+u);
  end when;

  connect(u, P.u) annotation (Line(points={{-120,0},{-80,0},{-80,70},{-62,70}},
        color={0,0,127}));
  connect(P.y, Add.u1) annotation (Line(points={{-39,70},{16,70},{16,2.4},{27.2,
          2.4}},
        color={0,0,127}));
  connect(I.y, Add.u2)
    annotation (Line(points={{7,-2},{16,-2},{16,-2.4},{27.2,-2.4}},
                                              color={0,0,127}));
  connect(P1.u, P.u) annotation (Line(
      points={{-72.4,-2.22045e-016},{-74,-2.22045e-016},{-74,0},{-80,0},{-80,70},
          {-62,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Add.y, limiter.u) annotation (Line(
      points={{36.4,0},{62.4,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, y) annotation (Line(
      points={{80.8,2.22045e-16},{92.4,2.22045e-16},{92.4,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.u1, y) annotation (Line(
      points={{77.2,-20.6},{86,-20.6},{86,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(add1.u2, Add.y) annotation (Line(
      points={{68.8,-20.6},{54,-20.6},{54,0},{36.4,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain1.u, add1.y) annotation (Line(
      points={{57.2,-44},{73,-44},{73,-36.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P1.y, add2.u1) annotation (Line(
      points={{-44.8,0},{-40,0},{-40,-2},{-39,-2},{-39,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add2.y, I.u) annotation (Line(
      points={{-27.5,-3},{-21.75,-3},{-21.75,-2},{-16,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain1.y, add2.u2) annotation (Line(
      points={{43.4,-44},{-39,-44},{-39,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="PID",
    Icon(
        coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            initialScale=0.1),
            graphics={
        Line(visible=true,
            points={{-80.0,78.0},{-80.0,-90.0}},
            color={192,192,192}),
      Polygon(visible=true,
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
      Line(visible=true,
          points={{-90.0,-80.0},{82.0,-80.0}},
          color={192,192,192}),
      Polygon(visible=true,
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
      Line(visible = true, points = {{-80,-80},{-80,-20},{60,80}}, color = {0,0,127}),
      Text(visible=true,
          lineColor={192,192,192},
          extent={{-20.0,-60.0},{80.0,-20.0}},
          textString="PID"),
      Text(visible=true,
          extent={{-150.0,-150.0},{150.0,-110.0}},
          textString="Ti=%Ti")}),
    Documentation(info="<HTML>
<p>
This is the text-book version of a PID-controller.
For a more practically useful PID-controller, use
block LimPID.
</p>

<p>
The PID block can be initialized in different
ways controlled by parameter <b>initType</b>. The possible
values of initType are defined in
<a href=\"modelica://Modelica.Blocks.Types.InitPID\">Modelica.Blocks.Types.InitPID</a>.
This type is identical to
<a href=\"modelica://Modelica.Blocks.Types.Init\">Types.Init</a>,
with the only exception that the additional option
<b>DoNotUse_InitialIntegratorState</b> is added for
backward compatibility reasons (= integrator is initialized with
InitialState whereas differential part is initialized with
NoInit which was the initialization in version 2.2 of the Modelica
standard library).
</p>

<p>
Based on the setting of initType, the integrator (I) and derivative (D)
blocks inside the PID controller are initialized according to the following table:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>initType</b></td>
      <td valign=\"top\"><b>I.initType</b></td>
      <td valign=\"top\"><b>D.initType</b></td></tr>

  <tr><td valign=\"top\"><b>NoInit</b></td>
      <td valign=\"top\">NoInit</td>
      <td valign=\"top\">NoInit</td></tr>

  <tr><td valign=\"top\"><b>SteadyState</b></td>
      <td valign=\"top\">SteadyState</td>
      <td valign=\"top\">SteadyState</td></tr>

  <tr><td valign=\"top\"><b>InitialState</b></td>
      <td valign=\"top\">InitialState</td>
      <td valign=\"top\">InitialState</td></tr>

  <tr><td valign=\"top\"><b>InitialOutput</b><br>
          and initial equation: y = y_start</td>
      <td valign=\"top\">NoInit</td>
      <td valign=\"top\">SteadyState</td></tr>

  <tr><td valign=\"top\"><b>DoNotUse_InitialIntegratorState</b></td>
      <td valign=\"top\">InitialState</td>
      <td valign=\"top\">NoInit</td></tr>
</table>

<p>
In many cases, the most useful initial condition is
<b>SteadyState</b> because initial transients are then no longer
present. If initType = InitPID.SteadyState, then in some
cases difficulties might occur. The reason is the
equation of the integrator:
</p>

<pre>
   <b>der</b>(y) = k*u;
</pre>

<p>
The steady state equation \"der(x)=0\" leads to the condition that the input u to the
integrator is zero. If the input u is already (directly or indirectly) defined
by another initial condition, then the initialization problem is <b>singular</b>
(has none or infinitely many solutions). This situation occurs often
for mechanical systems, where, e.g., u = desiredSpeed - measuredSpeed and
since speed is both a state and a derivative, it is natural to
initialize it with zero. As sketched this is, however, not possible.
The solution is to not initialize u or the variable that is used
to compute u by an algebraic equation.
</p>

</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end PID_AW_reset3;