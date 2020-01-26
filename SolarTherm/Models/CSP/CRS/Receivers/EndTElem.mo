within SolarTherm.Models.CSP.CRS.Receivers;
model EndTElem "Losses at outlet fluid temperature"
 extends SolarTherm.Models.CSP.CRS.Receivers.Elem(redeclare model FlowModel =
        Fluid.Flows.LosslessFlow, port_b(h_outflow(start=0.0)));
 // port_b.h_outflow is used as iteration variable, so we should find a good
 // initial guess for it.  Setting to zero here to silence warning.
 import SI = Modelica.SIunits;
 import CN = Modelica.Constants;

 parameter Real ab "Absorbtivity";
 parameter Real em "Emissivity";
 parameter SI.CoefficientOfHeatTransfer h_th "Heat transfer coeff with env";
equation
 Q_flow_loss = h_th*A*(hfluid.mprop_b.T - wbus.Tdry);
 R_loss = em*CN.sigma*A*(hfluid.mprop_b.T^4 - wbus.Tdry^4);
 hfluid.Q_flow + Q_flow_loss + R_loss = ab*R;
end EndTElem;
