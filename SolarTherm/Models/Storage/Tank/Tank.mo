within SolarTherm.Models.Storage.Tank;
model Tank
  extends Interfaces.Models.StorageFluid;
  redeclare replaceable package Medium = Media.SolidParticles.CarboHSP_ph;
  import SolarTherm.Utilities.*;

  parameter SI.Diameter D=18.667 "Diameter";
  parameter SI.Height H=20 "Height";
  parameter SI.Length Th_refractory = 0.6 "Insulation thickness [m] - Dome storage only";

  import CN = Modelica.Constants;
  parameter SI.Length th_insul = 10e-2 "thickness of the insulation in the tank";
  parameter SI.ThermalConductance k_insul = 0.08 "W/m/K microporous insulation board', https://is.gd/5j9Gkw";

  parameter SI.Emissivity em = 0.8;
  
  parameter Real packing_factor = 0.747857;
  
  parameter Real H_tower = 200;
  parameter Real D_tower = 25;
  parameter Real m_tot = 2e6;
  parameter Real D_outlet = 0.21;
  parameter Real t_storage = 13;
  
  parameter SI.ThermalConductance UA_hemisphere = 
        if external_storage then 
            1/(SolarTherm.Utilities.G3P3DomeStorageRValueCalculation(
                  Th_refractory,
                  H,
                  D,
                  "hemisphere"
                  ))
        else
            1/(SolarTherm.Utilities.G3P3DomeStorageRValueCalculation_IntegratedStorage(
                  Th_refractory,
                  H_tower,
                  D_tower,
                  m_tot,
                  D_outlet,
                  t_storage,
                  "hemisphere"
                  ));
  parameter SI.ThermalConductance UA_cylinder =
        if external_storage then 
            1/(SolarTherm.Utilities.G3P3DomeStorageRValueCalculation(
                 Th_refractory,
                 H,
                 D,
                 "cylinder"
                 ))
        else
            1/(SolarTherm.Utilities.G3P3DomeStorageRValueCalculation_IntegratedStorage(
                Th_refractory,
                H_tower,
                D_tower,
                m_tot,
                D_outlet,
                t_storage,
                "cylinder"
                ));
                  
  parameter Boolean dome_storage = false;
  parameter Boolean external_storage = true "true = use external storage R value calculation, false use integrated";

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
  SI.HeatFlowRate Q_losses_before_radiation;
  SI.HeatFlowRate Q_losses_total;
  SI.Mass m;  
  Medium.BaseProperties medium;

  SI.Area A;
  parameter SI.ThermalInsulance U_value = 2;


  Medium.ThermodynamicState state_i=Medium.setState_pTX(medium.p,T_start); //initialize initial state

  SI.Power W_net;
  SI.Power W_loss;

  Modelica.Blocks.Interfaces.RealOutput L if use_L "Tank level in %"
                                          annotation (Placement(transformation(
          extent={{96,44},{116,64}}), iconTransformation(extent={{92,34},{112,54}})));
  Modelica.Blocks.Interfaces.RealInput p_top if use_p_top annotation (Placement(
        visible = true,transformation(
        
        origin={58, 106},extent={{-16,-16},{16,16}},
        rotation=-90), iconTransformation(
        
        origin={45,97},extent={{-11,-11},{11,11}},
        rotation=-90)));

  Modelica.Blocks.Interfaces.RealInput T_amb if enable_losses annotation (Placement(
        visible = true,transformation(
        
        origin={-50,108},extent={{-16,-16},{16,16}},
        rotation=-90), iconTransformation(
        
        origin={-41,97},extent={{-11,-11},{11,11}},
        rotation=-90)));
  
  Modelica.Blocks.Interfaces.RealOutput T_mea annotation(
    Placement(transformation(extent = {{94, -18}, {130, 18}})));

  parameter SI.Volume V_t=(H*pi*D^2)/4;
  Modelica.Blocks.Interfaces.RealOutput L_internal;
  Modelica.Blocks.Interfaces.RealInput p_top_internal;
  Modelica.Blocks.Interfaces.RealInput T_amb_internal;

initial equation
  medium.h=Medium.specificEnthalpy(state_i);
  m=Medium.density(state_i)*(V_t*packing_factor)*L_start/100;

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
      if dome_storage == true then
          //********************** Heat losses from cylindrical and hemisphere part of the dome storage
          Q_losses_before_radiation = UA_cylinder * (-1) * (medium.T-T_amb_internal) + UA_hemisphere * (-1) * (medium.T-T_amb_internal);       
      else
          //********************** Heat losses from cylindrical storage
          Q_losses_before_radiation= -U_value * A * (medium.T-T_amb_internal);
      end if;
  else
      T_amb_internal=Medium.T_default;
      Q_losses_before_radiation=0;
  end if;

  p_top_internal=medium.p;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;
  fluid_a.h_outflow=0;//medium.h;
  fluid_b.h_outflow=medium.h;
  der(m)=fluid_a.m_flow+fluid_b.m_flow;
  m*der(medium.h)+der(m)*medium.h=Q_losses_before_radiation+W_net+fluid_a.m_flow*inStream(fluid_a.h_outflow)+fluid_b.m_flow*medium.h;
  T_mea = medium.T;
  
  der(Q_losses_total)= Q_losses_before_radiation;

  V=m/medium.d;
  L_internal=100*V/(V_t*packing_factor);
  A=2*CN.pi*(D/2)*H*(L_internal/100) + CN.pi*(D/2)^2;

  if medium.T<T_set then
    W_net=min(-Q_losses_before_radiation,W_max);
  else
    W_net=0;
  end if;

 W_loss=W_net/e_ht;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end Tank;