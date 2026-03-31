%% ASEN 3802 - Lab 3 - Main
% Task 1: Create NACA Airfoil Generator, Plot Results
% Task 2: ...
% Task 3: ...
% Task 4: ...
% Author: Cooper, Nathan, Sayer, Xander
% Date: Mar 31, 2026
clc; clear all; close all;

%% Task 1, NACA 0021, NACA 2421
airfoil1 = '0021';
airfoil2 = '2421';

N = 50; % Number of Panels for top and bottom each
c = 10;
[m,p,t] = extractAirfoilData(airfoil1);
xvals = GeometricXValues(N,c); % C is 1
[x_b,y_b,y_c] = NACA_Airfoils(m,p,t,c,N)

PlotAirfoil(x_b,y_b,y_c)


%% Functions for Part 1
function [x_b,y_b,y_c] = NACA_Airfoils(m,p,t,c,N)
x = linspace(0,c,N);

% Calculates the thickness distribution of airfoil
y_t = (t*c/0.2)*((0.2969*sqrt(x/c) - 0.1260*(x/c)-0.3515*(x/c).^2 + 0.2843*(x/c).^3 - 0.1036*(x/c).^4));

% Finds the mean camber line. Splits it between before the maximum camber
% position and after. Will go to 0 if there is no camber.
xi = zeros(1,length(x));
dyc = zeros(1,length(x));
y_c = zeros(1,length(x));

for i = 1:length(x)
    if x(i) < p*c
        y_c(i) = m*x(i)/p^2 * (2*p-x(i)/c);
        dyc(i) = (2*p-2*x(i)/c)*m/p^2;
        xi(i)= atan(dyc(i));
    elseif x(i) >= p*c
        y_c(i) = m*(c-x(i))/(1-p)^2 * (1+(x(i)/c)-(2*p));
        dyc(i) = m/(1-p)^2*(2*p-2*x(i)/c);
        xi(i) = atan(dyc(i));
    end
end

x_U = x - y_t.*sin(xi);
x_L = x + y_t.*sin(xi);
y_U = y_c + y_t.*cos(xi);
y_L = y_c - y_t.*cos(xi);

% Concatenate Upper and Lower in CW Trailing Edge
x_b = [flip(x_L),x_U];
y_b = [flip(y_L),y_U];

end

function [m,p,t] = extractAirfoilData(airfoilCode)
    %{
    Inputs: 
        airfoilCode - 4 digit airfoil code as string
    Outputs:
        m - max camber
        p - location of max camber
        t - max thickness of airfoil
    %}
    digits = airfoilCode - '0';
    m = digits(1)/100;
    p = digits(2)/10;   
    t = str2double(sprintf('%d%d',digits(3),digits(4)))/100;
end

function [x_array] = GeometricXValues(Number_of_Panels,C)

%GeometrixXValues finds X values based off the gemoetric method highlighted
%in class,
%This function takes the desired number of panels and the chord length. It
%takes N panels as equivalent to N rays, from the point c/2 to a circle
%with radius of c/2. Taking the number of rays over 2pi radians gives the
%equal angle between them. We make an array of rays, spaced by the equal
%angle we've found. Then we just take the dot product of the ray and the
%x-axis to get an array of x values, between 0 and c.
%
% Author: Sayer Gage
% Collaborators: Xander Lotito
% Date: 03/31/26

Number_of_Rays = Number_of_Panels; %The number of rays we have should be
%equivalent to the number of panels we want. 
Angle = 2*pi / Number_of_Rays; %The equal angle should just be the number of arrays 
%divided by the full arc of the circle
Angle_array = 0:Angle:2*pi; %this is an array describing all the rays, as described
%by their angle clockwise from the TE

x_array = (C/2)*cos(Angle_array) + C/2; %This takes the x-projection of each
%ray to get an array of N+1 x points on the x-axis, giving N panels.

end

function PlotAirfoil(x_b,y_b,y_c)
%This is just a plot function. As we need more complexity we will add it
%here. For now it just simplifies calls.
figure(); hold on;
plot(x_b,y_b,"Marker",".")
% plot(y_c/N,'-b')

end
