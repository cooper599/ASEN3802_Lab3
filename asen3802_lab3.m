clear; clc; close all;

x = 1:0.1:10;
m = 0.04; p = 0.4; t = 0.15; c = 10; 


y_t = (t/0.2)*c * (0.2969*sqrt(x/c) - 0.3515*(x/c).^2 + 0.2843*(x/c).^3 - 0.1036*(x/c).^4);


for i = 1:length(x)
    if x(i) < p*c

        y_c(i) = m*x(i)/p^2 * (2*p-x(i)/c);

    elseif x(i) >= p*c

        y_c(i) = m*(c-x(i))/(1-p)^2 * (1+(x(i)/c)-(2*p));

    end
end