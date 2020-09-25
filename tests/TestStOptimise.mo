block TestStOptimise
// Use Rosenbrock function to test st_optimise
// ref: https://en.wikipedia.org/wiki/Rosenbrock_function
// also DAKOTA users-6.10.0, page 32 
// the unique optimal point is (x, y)=(1, 1), where f=0

parameter Real a=1;
parameter Real b=100;

parameter Real x=0;
parameter Real y=2;

Real f;	
equation
	f=(a-x)^2+b*(y-x^2)^2;
end TestStOptimise;
