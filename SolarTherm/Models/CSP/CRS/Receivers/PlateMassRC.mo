within SolarTherm.Models.CSP.CRS.Receivers;
model PlateMassRC "Single element plate receiver with fluid interface"
 extends SolarTherm.Models.CSP.CRS.Receivers.FluidRC;
 import SI = Modelica.SIunits;
 import CN = Modelica.Constants;

 parameter SI.Area A "Area of aperture";
 parameter SI.Mass m "Thermal mass of receiver";
 parameter SI.SpecificHeatCapacity c "Heat capacity of thermal mass";
 parameter Real em "Emissivity";
 parameter SI.CoefficientOfHeatTransfer h_th "Heat transfer coeff with env";
 parameter SI.Temperature T_0 = 300;

 SI.Temperature T(start=T_0, fixed=true) "Temperature of receiver mass";
 SI.HeatFlowRate Q_flow "Heat flow into receiver mass";
protected
 Medium.BaseProperties mprop_b;
equation
 port_a.m_flow + port_b.m_flow = 0;

 port_a.p = port_b.p;

 mprop_b.T = T;
 mprop_b.p = port_b.p;
 port_b.h_outflow = mprop_b.h;
 port_a.h_outflow = mprop_b.h; // set it as same, but shouldn't flow back
 Q_flow = em*R[1]
  - port_a.m_flow*(port_b.h_outflow - inStream(port_a.h_outflow))
  - h_th*A*(T - wbus.Tdry)
  - em*CN.sigma*A*(T^4 - wbus.Tdry^4);
                  // power from concentrator (em used for absorptivity)
                           // convection losses (should add wind forcing)
                                       // radiative losses
 c*m*der(T) = Q_flow;

 // Could use actualStream above (should also probably mark it smooth)

 // Think about adding pressure drop proportional to flow?

 // How about we have a controller that draws away heat once rec temp
 // passes a level, and only draws energy such that the rec temp is fixed.
end PlateMassRC;
