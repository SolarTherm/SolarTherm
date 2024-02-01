within SolarTherm.Models.Chemistry;

package ChemTable
  //Data obtained from FactSage
  //Format M (kg/mol), Hf0 (J/mol), S0 (J/molK)
  //       Molar mass, Standard enthalpy of formation, Absolute entropy at standard conditions
  final Chemical H2(M=2.01588e-3, Hf0=0.0, S0=130.680);
  final Chemical H2O(M=18.01528e-3,Hf0=-285.8300e3, S0=69.950);
  final Chemical Fe(M=55.845e-3,Hf0=0.0, S0=27.280);
  final Chemical Fe2O3(M=159.6882e-3,Hf0=-825.7869e3, S0=87.729);
  final Chemical Fe3O4(M=231.5326e-3,Hf0=-1117.4025e3, S0=146.114);
  final Chemical FeO(M=71.8444e-3,Hf0=-265.8322e3, S0=59.496);//HfO changed from -272.04e3 to -265.832e3
  
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(origin = {0, -11}, lineThickness = 1, extent = {{-72, 69}, {72, -53}}), Line(origin = {-1, 34}, points = {{-71, 0}, {73, 0}}, thickness = 1), Line(origin = {-40, -3}, points = {{0, 61}, {0, -61}}, thickness = 1), Line(origin = {-2, -3}, points = {{0, 61}, {0, -61}}, thickness = 1), Line(origin = {36, -4}, points = {{0, 62}, {0, -60}}, thickness = 1)}, coordinateSystem(initialScale = 0.1)));
end ChemTable;