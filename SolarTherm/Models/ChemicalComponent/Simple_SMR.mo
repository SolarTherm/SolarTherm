within SolarTherm.Models.ChemicalComponent;

model Simple_SMR
/*
Simple Steam Methane Reforming component following stoichiometric reaction with a fixed reaction extent

CH4 + H2O  ---> 3H2 + CO

*/

parameter Real CH4_reaction_extent = 1;
parameter Real CH4_molar_weight = 16e-3 "Molar weight of CH4 in kg/mol";
parameter Real H2O_molar_weight = 18e-3 "Water molar weight in kg/mol";
parameter Real H2_molar_weight = 2e-3 "H2 molar weight in kg/mol";
parameter Real H2_mol_target = 20 "Mol target production in mol/s";
parameter Real H2_mdot_target = 1 "mass flow target of H2 [kg/s]";
parameter Real W_consumption = 1492000 "Electricity consumption when SMR works at full load [W]";

SI.Mass H2O_SMR(start=0) "Accummulated H2O needed to run SMR";
SI.Mass CH4_SMR(start=0) "Accummulated Methane needed to run SMR";
SI.MassFlowRate delta_target(start=0) "Difference in H2 mass flow rate from the targeted value [kg/s]";
Modelica.Blocks.Interfaces.RealInput H2_electrolyser "H2 production in kg/s from electrolyser" annotation(
    Placement(visible = true, transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
Modelica.Blocks.Interfaces.RealOutput H2_SMR "Mass flow of H2 produced by the SMR" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
SI.Energy E_elec_SMR(start=0) "Electricity consumed by the SMR [J]";

equation

if H2_electrolyser < H2_mdot_target then
    /*When elecrolyser does not produce the targeted H2 mdot value, top-up with SMR*/
    delta_target = abs(H2_electrolyser - H2_mdot_target);
    der(CH4_SMR) = 1/3 * (delta_target/H2_molar_weight) * CH4_molar_weight / CH4_reaction_extent;
    der(H2O_SMR) = 1/3 * (delta_target/H2_molar_weight) * H2O_molar_weight / CH4_reaction_extent;
    H2_SMR = (delta_target/H2_molar_weight) * H2_molar_weight;
else
    delta_target = 0;
    der(CH4_SMR) = 0;
    der(H2O_SMR) = 0;
    H2_SMR = 0;
end if;

der(E_elec_SMR) = W_consumption * H2_SMR/H2_mdot_target;


annotation(
    Diagram(graphics = {Rectangle(origin = {0, 8}, lineThickness = 1, extent = {{-100, 76}, {100, -76}}), Text(origin = {0, 13}, extent = {{-86, 29}, {86, -29}}, textString = "Simple SMR")}),
    Icon(graphics = {Rectangle(origin = {0, 1}, lineThickness = 1, extent = {{-100, 83}, {100, -83}}), Text(origin = {2, 8}, extent = {{-90, 30}, {90, -30}}, textString = "Simple SMR")}));
end Simple_SMR;