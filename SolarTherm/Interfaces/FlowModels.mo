within SolarTherm.Interfaces;
package FlowModels "Flow models"
	partial model PartialFlowModel
		import SI = Modelica.SIunits;
		SI.MassFlowRate m_flow;
		SI.Density d_avg "Average density";
		SI.Pressure dp "Pressure change";
	end PartialFlowModel;

	model Lossless
		extends PartialFlowModel;
	equation
		dp = 0;
	end Lossless;

	model DWFlow "Darcy-Weisbach flow equations"
		extends PartialFlowModel;
		import SI = Modelica.SIunits;
		import CN = Modelica.Constants;

		parameter SI.Length L = 1 "Length of pipe";
		parameter SI.Length D = 0.1 "Diameter of pipe";
		parameter Real f_D = 1.0 "Darcy-Weisbach friction factor";
	protected
		parameter SI.Area A = CN.pi*D^2/4;

		SI.Velocity v "Average velocity of fluid";
	equation
		v = m_flow/(A*d_avg);
		dp = f_D*(L/D)*d_avg*v^2/2;
	end DWFlow;
end FlowModels;
