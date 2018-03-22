within SolarTherm.Interfaces.Models;
partial model Sun
  extends SolarTherm.Icons.SunModel;

  Connectors.SolarPort_b solar
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
end Sun;
