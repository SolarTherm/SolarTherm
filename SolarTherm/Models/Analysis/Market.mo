within SolarTherm.Models.Analysis;
model Market
  extends Icons.Price;
  Modelica.Blocks.Interfaces.RealInput W_el
    annotation (Placement(transformation(extent={{-120,-22},{-80,18}})));
  parameter Real nu_net=0.9 "Estimated gross to net conversion factor at the power block" annotation(Dialog(group="Parasities energy losses"));
  parameter Real W_base=0.0055*294.188e6 "Power consumed at all times" annotation(Dialog(group="Parasities energy losses"));
  parameter Boolean external_parasities = false
    "= true enable parasities as an input"
      annotation (Dialog(group="Parasities energy losses"), Evaluate=true, HideResult=true, choices(checkBox=true));
  replaceable model Price =
      SolarTherm.Models.Analysis.EnergyPrice.Table
  constrainedby SolarTherm.Models.Analysis.EnergyPrice.EnergyPrice
    "Energy price in dollars per mega Watt hour"
    annotation (Dialog(group="Finances",_Dymola_label="Price"), choicesAllMatching=true);

  Price price;
  SolarTherm.Types.Money profit;
  SI.HeatFlowRate W_loss "Parasitic losses power";
  SI.HeatFlowRate W_net "Estimated net output at design";
  SI.Energy E_gross(final start=0,displayUnit="kWh");
  SI.Energy E_net(final start=0,displayUnit="kWh");

  Modelica.Blocks.Interfaces.RealInput parasities if external_parasities annotation (Placement(
        transformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={1.77636e-015,80}),                  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,90})));
protected
  Modelica.Blocks.Interfaces.RealInput parasities_internal;
equation
  if external_parasities then
    connect(parasities_internal,parasities);
  else
    parasities_internal=0;
  end if;

  der(E_gross)=W_el;
  der(E_net)=W_net;
  W_loss=(1-nu_net)*W_el+W_base+parasities_internal;
  W_net=W_el-W_loss;
  der(profit)=W_net*SolarTherm.Types.from_dollarperMWh(price.price);
end Market;
