function [c_L,c_Di,e] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N)
% PLLT finds span efficiency factor, coefficient of lift, and induced drag
% for a given 3D finite wing. It takes in the dimensions of the wing which
% are listed below and using PLLT, we find what the wing will do. It uses
% Fourier Series for a finite number of terms, N, and outputs the Fourier
% coefficients. Using these, we can find Cl, e, and CDi. 
%
% Author: Nathan Bidlingmaier
% Date: 04/12/2026

i = 1:N;  % makes a vector of length N

% Converting degrees to radians for consistency
a0_t = deg2rad(a0_t); a0_r = deg2rad(a0_r); 
geo_t = deg2rad(geo_t); geo_r = deg2rad(geo_r); 


theta_i = i*pi / (2*N);     % Finding theta for each N


% Physical geometry to find the following as a function of theta
c  = c_r  + (c_t  - c_r)  * cos(theta_i);
alpha_L0 = aero_r + (aero_t - aero_r) * cos(theta_i);
alpha_geo = geo_r + (geo_t - geo_r) * cos(theta_i);


% -------- Creating vector B and matrix A for computations ----------

B = alpha_geo - alpha_L0;

A = ones(N,N);
row = 1:N;

% Finding values of A
for j = 1:length(i)
    for k = 1:length(i)

        n = 2*k - 1;    % makes it odd terms only
        row = (2*b/(pi*c(j)) * sin(n * theta_i(j))) + n*sin(n*theta_i(j))/sin(theta_i(j));

        A(j,k) = row;
    end

end

x = A \ B';     % outputs the odd Fourier coefficents


% ------- Using the Fourier coefficients to find CL --------------

S = b * (c_r+c_t) / 2;      AR = b^2/S;

c_L = x(1) * pi * AR;


% solving for e
delta = 0;

for j = 2:N 

    n = 2*j - 1;    % makes it odd
    delta = delta + (n * (x(j)/x(1))^2);

end


e = 1/(1+delta);
c_Di = c_L^2 / (pi * e * AR);

%end




end