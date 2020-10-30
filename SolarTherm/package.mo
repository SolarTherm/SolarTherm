within ;
package SolarTherm
  extends SolarTherm.Icons.SolarThermPackage;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import Modelica.SIunits.Conversions.*;
  import Modelica.Math.sin;
  import Modelica.Math.cos;
  import Modelica.Math.asin;
  import Modelica.Math.acos;
  import Modelica.Math.tan;
  import Modelica.Math.atan;
  import Modelica.Math.atan2;
  import Modelica.Constants.pi;
  import Modelica.Constants.g_n;
  import Modelica.Constants.sigma;
  import Modelica.Blocks.Math.Sign;
  import Modelica.SIunits.Conversions.from_degC;










  annotation (
  preferredView="info",
  version="0.2",
  versionBuild=1,
  versionDate="2016-04-26",
    uses(Modelica(version="3.2.2")),
    Documentation(info="<html>
<h4>Welcome to SolarTherm library!!</h4>
<p>SolarTherm was created under the Astralian Solar Thermal Research Iniciative (ASTRI) program with the aim to provide solar thermal community with an easy tool to simulate and optimise Concentrating Solar Thermal (CST) power plants. The focus of this tool is the annual performance and the economic assessment of novel designs of solar thermal plants.</p>
<p>It consists of a CST component and system library along with a simulation framework. As other simulation tools, it allows a high-level process modelling through the connection of previous defined components where users can simulate systems configuring only few parameters such as the size of the storage or the receiver area. However the attraction of this tool is its high flexibility, where it is easy to replace, develop or customise new components. This makes SolarTherm a suitable tool to explore of new technologies related with CST power systems including thermochemical systems (i.e. solar fuels).</p>
<p>SolarTherm is a tool based on the object-oriented modelling Modelica language for its component models and simulation. This language provides class encapsulation allowing a modular and hierarchical modelling with replaceable and customized components. Each of them can be formulated acausally, i.e. the translation of the physical equations into the formulation language is direct, making it very well suited for representing the physical structure of systems. Also, Modelica can be interfaced with external tools allowing a stochastic statistical analysis of the plant performance.</p>
<p>SolarTherm provides a range of Python-based tools and scripts that automate the process of testing, simulating, optimising and visualising the results. Besides, if the user prefers to manage flow-sheet diagrams, Modelica library can be simulated with user-friendly graphical Modelica enviroments such as OMEdit or Dymola. </p>
<p>One of the strengths of SolarTherm is that is a fully open source project. All the code is fully accessible and hackable including component models as well as the simulation framework on a <a href=\"https://github.com/solartherm/solartherm\">GitHub server</a>. Being fully open source and fully compatible with the free-open source Modelica language simulator OpenModelica, it aims to become an attractive tool where researchers joint their efforts working on the future of the CST technology.</p>
<p>Website documentation: <a href=\"http://solartherm.readthedocs.org/en/latest/\">http://solartherm.readthedocs.org/en/latest/</a></p>
</html>"));
end SolarTherm;
