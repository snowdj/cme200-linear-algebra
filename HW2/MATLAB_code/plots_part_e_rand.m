function plots_part_e
%Plot condition numbers

N = [5; 10; 25; 200];
cond_numbers = zeros(4, 1);

f = @(x) -10*sin(3*pi*x/2);
c = ['r', 'b', 'k', 'g'];
figure;
delta = 0.1;
for k=1:6
	delta = delta/10;
	subplot(2,3,k);
	hold on;
	str=sprintf('delta = %e', delta);
	title(str);
	for i=1:length(N)
	  h = 1/(N(i));
	  A = diag(ones(N(i)-2,1),-1) - 2*eye(N(i)-1) + diag(ones(N(i)-2,1),1);
	  R = rand(N(i)-1,N(i)-1);
	  A = A + delta*R;   % Perturbing the system by a random perturbation delta*R

	  x = linspace(0, 1, N(i)+1);  % Find the points of discretization
	  xind = x(2:end-1);
	  b1 = (h^2)*(f(xind)); % Forming b
	  b1(N(i)-1) = b1(N(i)-1) - 2;
	  T = A\(b1');    % Solving the system Ax = b
	  Tsol = [0; T; 2];
	%  x = linspace(0, 1, N(i)+1);
	  plot(x', Tsol, c(i));
	  cond_numbers(i) = cond(A, 'fro');
	end

	legend({'N=5', 'N=10', 'N=25', 'N=200'}, 'Location', 'SouthEast')
	hold off
	cond_numbers;
end
%figure(3);
%plot(cond_numbers);

