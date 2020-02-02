
block SillyReceiver

	// to be supplied by the user:
	parameter Real H "receiver height";

	// calculated during 'design phase'
	parameter Real W(fixed=false) "receiver width";
	parameter Real m(fixed=false) "receiver mass";
	parameter Real C(fixed=false) "receiver cost";
	parameter Real AR = 4./3 "aspect ratio";
	parameter Real A(fixed=false) "area";
	parameter Real m_per_A = 5 "receiver mass per area";
	parameter Real alpha = 0.94 "Receiver absorptivity";

	// Nearly constants -- costing Parameters
	parameter Real m_0 = 100 "reference mass for cost equation";
	parameter Real C_0 = 200 "reference cost for cost equation";
	parameter Real a = 0.7 "cost exponent";

	// Todo: add variables
	Real eta(min=0, max=1);
	input Real G "DNI";
	input Real CR "concentration ratio";
	constant Real sig = 5.67e-8;

	Real T "temperature (passed from outside)";
	input Real T_ext "temperature (internal working value)";
	parameter Real T_des = 800. "design-point temperature";

	output Real Qnet "energy to working fluid";
	output Real Qinc "incident solar flux";

	Real Qnet_des(fixed=true) "design-point energy to working fluid";

	Real eta_des(fixed=true) "design-point efficiency";
	//Real disconnected(fixed=true, start=1);
	Boolean disconnected(fixed=true, start=true);
initial equation
	/* these are 'design calculations' that establish the size of the receiver for
	a specified height (trivial in this case) */
	AR = W / H;
	A = W*H;
	C / C_0 = (m / m_0)^a;
	m = A * m_per_A;
equation
	// variable mass flow rate for performance calculation
	alpha * Qinc = Qnet + A*sig*T^4;
	Qnet = Qinc * eta;
	Qinc = G*CR*A;
	when initial() then
		Qnet_des = pre(Qnet);
		eta_des = pre(eta);
		disconnected = false ;
	end when;
	//T = disconnected * T_des + (1 - disconnected)*T_ext;
	T = (if disconnected then T_des else T_ext);
end SillyReceiver;

model ParameterGames
	import CO = Modelica.Constants;

	parameter Real H = 10;
	//parameter Real C_1(fixed=false);
	parameter Real G = 1000;
	Real T "receiver operating temperature";
	parameter Real CR = 100;
	SillyReceiver R1(H=H,G=G,T_ext=T,CR=CR );

	parameter Real c_2 = 300;
	parameter Real H_2 = 200;
	Real m_2 = H_2 / 200;
	Real C_2 = c_2 * m_2;

	Real C_tot = R1.C + C_2;
	Real E(fixed=true, start=0);
equation
	T = 298.15 + 400 + 400 *sin(time/(24*3600.) * 2*CO.pi);
	der(E) = R1.Qnet;
annotation(experiment(StartTime=0, StopTime=604800, Tolerance=1e-6));
end ParameterGames;
