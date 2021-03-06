function [T, x, A] = heatEqnSolver1D(N, f)
% This function solves the one dimensional Heat equation with Dirichlet boundary
% conditions T(0)=0 and T(1)=2 and returns two arrays, T and x.

% Inputs:
%    N:  controls the number of points in discretization with h = 1/N
%    f:  MATLAB function that evaluates the source function

% Find the points of discretization
h = 1/N;    % Interval size of discretization
x = 0:h:1;  % x = [x_0, x_1, ..., x_N]
x = x(2:end-1);  % x = [x_1, x_2, ..., x_{N-1}]

% Construct a tri-diagonal matrix A
 A = diag(ones(N-2,1),1) - 2*eye(N-1) + diag(ones(N-2,1),-1);

% Instead of the line above, use the line below to take advantage of the sparsity of A.
% We can construct A as a sparse matrix directly (this will save us some memory space and speed up computation)
% A = spdiags(ones(N-1,2), [-1;1], N-1, N-1) - 2*speye(N-1);

% Construct the right-hand side b from the function f
b = h^2*f(x)';
% Modify b to satisfy the Dirichlet boundary conditions
b(1) = b(1) - 0;     % Apply T_0 = 0
b(end) = b(end) - 2; % Apply T_N = 2

%Solve the system and return the result
T = A\b;
T = [0; T; 2];   % Reattach boundary values on T
x = [0; x'; 1];  % Reattach boundary values on x
end


%{
%part (d)
%Run the following in MATLAB/octave command prompt
f = @(x) -10*sin(3*pi*x/2);
[T5, x5] = heatEqnSolver1D(5, f);
[T10, x10] = heatEqnSolver1D(10, f);
[T25, x25] = heatEqnSolver1D(25, f);
[T200, x200] = heatEqnSolver1D(200, f);
plot(x5, T5, x10, T10, x25, T25, x200, T200);
legend({'N=5', 'N=10', 'N=25', 'N=200'}, 'Location', 'NorthWest');


%part (f)
%Run these commands in MATLAB prompt window
f = @(x) -100*((1/6<x)&(x<1/3)) + 100*((2/3<x)&(x<5/6));
[T5, x5] = heatEqnSolver1D(5, f);
[T10, x10] = heatEqnSolver1D(10, f);
[T25, x25] = heatEqnSolver1D(25, f);
[T200, x200] = heatEqnSolver1D(200, f);

A = [0 1 0 0 0 0 0 0 0 0;
	1/6 1 -1/6 -1 0 0 0 0 0 0;
	1 0 -1 0 0 0 0 0 0 0;
	0 0 1/3 1 -1/3 -1 0 0 0 0;
	0 0 1 0 -1 0 0 0 0 0;
	0 0 0 0 2/3 1 -2/3 -1 0 0;
	0 0 0 0 1 0 -1 0 0 0;
	0 0 0 0 0 0 5/6 1 -5/6 -1;
	0 0 0 0 0 0 1 0 -1 0;
	0 0 0 0 0 0 0 0 1 1;];
b = [0; -50/36; -50/3; 50/9; 100/3; 200/9; 200/3; -25^2/18; -250/3; 2];
c=A\b;
T = @(x) (c(1)*x+c(2))*(x<=1/6) + (c(3)*x+c(4)-50*x^2)*((1/6<x)&(x<=1/3)) + (c(5)*x+c(6))*((1/3<x)&(x<=2/3)) + (c(7)*x+c(8)+50*x^2)*((2/3<x)&(x<=5/6)) + (c(9)*x+c(10))*(5/6<x);
x=0:0.01:1;
for k=1:length(x)
	t(k) = T(x(k));
end

plot(x5 ,T5, x10, T10, x25, T25, x200, T200, x, t);
legend({'N=5', 'N=10', 'N=25', 'N=200', 'exact'}, 'Location', 'NorthEast');

norms = [norm(T5), norm(T10), norm(T25), norm(T200)];
norms = [3.89871773792359,  4.83735464897913,   6.50121957789460,  18.07632066406204];
N= [5,10,25,200];
norms_exct = zeros(1,4);
for m = length(N)
	h = 1/N(m);    % Interval size of discretization
	x = 0:h:1;  % x = [x_0, x_1, ..., x_N]
	t = zeros(1,N(m));
	for k=1:length(x)
		t(k) = T(x(k));
	end
	nomrs_exct(m) = norm(t);
end
%}

%{
% For reference:
c=[1.03333333333333e+01
   6.66133814775094e-16
   2.70000000000000e+01
  -1.38888888888889e+00
  -6.33333333333333e+00
   4.16666666666667e+00
  -7.30000000000000e+01
   2.63888888888889e+01
   1.03333333333333e+01
  -8.33333333333333e+00]


%}

