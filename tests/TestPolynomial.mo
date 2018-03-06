block TestPolynomial
	import SolarTherm.Utilities.Polynomial.Poly;
	Poly p1(c={1});
	Poly p2(c={1,0});
	Poly p3(c={1,1});
	Poly p4(c={1,0,3});
equation
	p1.x = 0.57; // 1
	p2.x = 0.57; // 1
	p3.x = 5; // 6
	p4.x = 5; // 76
	annotation(experiment(StartTime=0.0, StopTime=10.0, Interval=0.1, Tolerance=1e-06));
end TestPolynomial;
