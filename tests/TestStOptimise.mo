block TestStOptimise
// The Rosenbrock function is applied to test the soo in st_optimise
// 			ref: [1] https://en.wikipedia.org/wiki/Rosenbrock_function
// 				 [2] DAKOTA users-6.10.0, page 32 
// 				 the unique optimal point is (x, y)=(1, 1), where f=0, when -2<=x<=2 and -2<=y<=2

// The Schaffer function is applied to test the moo in st_optimise
//          ref: [1] https://en.wikipedia.org/wiki/Test_functions_for_optimization
//               [2] Schaffer, J. David (1984). Multiple Objective Optimization with Vector Evaluated Genetic Algorithms.


parameter Real x1=0 "for Roseonbrock"; 
parameter Real y1=2 "for Roseonbrock";
parameter Real x2=999 "for Schaffer, -A<x2<A, A is valid from 10 to 1e5"; 

Real f_rosen;	
Real f_schaffer1;
Real f_schaffer2;

equation
	f_rosen=100*(y1-x1^2)^2+(1-x1)^2; //the Rosenbrock function for soo
	f_schaffer1=x2^2;
	f_schaffer2=(x2-2)^2;

end TestStOptimise;
