%% ASEN 3802 - Lab 3 - Main
% Task 1: Create NACA Airfoil Generator, Plot Results
% Task 2: ...
% Task 3: ...
% Task 4: ...
% Author: Cooper, Nathan, Sayer, Xander
% Date: Mar 31, 2026
clc; clear all; close all;

%% Task 1, NACA 0021, NACA 2421
% Airfoils for Task 1
airfoil1 = 'NACA_0021';
airfoil2 = 'NACA_2421';

N = 50; % Number of Panels for top and bottom each
c = 1; % Chord length

% Plotting and Calculations for Airfoil 1
[m,p,t] = extractAirfoilData(airfoil1); % Calc m,p,t
[x_b,y_b,y_c] = NACA_Airfoils(m,p,t,c,N); % Calc geometry
PlotAirfoil(x_b,y_b,y_c,c,airfoil1); % Plot geometry

% Plotting and Calculations for Airfoil 2
[m,p,t] = extractAirfoilData(airfoil2);
[x_b,y_b,y_c] = NACA_Airfoils(m,p,t,c,N);
PlotAirfoil(x_b,y_b,y_c,c,airfoil2);

%% Functions for Part 1
function [x_b,y_b,y_c] = NACA_Airfoils(m,p,t,c,N)
    %{
    Inputs:
        m - max camber
        p - location of max camber
        t - max thickness
        c - chord length
        N - Number of Panels
    Outputs:
        x_b - X coordinates of boundary
        y_b - Y coordinates of boundary
        y_c - Mean camber line y coords
    %}
    % Create x value array using ray method
    x = GeometricXValues(N,c);
    % Calculates the thickness distribution of airfoil
    y_t = (t*c/0.2)*((0.2969*sqrt(x/c) - 0.1260*(x/c)-0.3515*(x/c).^2 + 0.2843*(x/c).^3 - 0.1036*(x/c).^4));
    % Preallocate arrays
    xi = zeros(1,length(x));
    dyc = zeros(1,length(x));
    y_c = zeros(1,length(x));

    % Finds the mean camber line. Splits it between before the maximum camber
    % position and after. Will go to 0 if there is no camber.
    for i = 1:length(x)
        % If before max camber position
        if x(i) < p*c
            % y coordinate camber modification
            y_c(i) = m*x(i)/p^2 * (2*p-x(i)/c);
            %dyc/dx
            dyc(i) = (2*p-2*x(i)/c)*m/p^2;
            % Angle calculation
            xi(i)= atan(dyc(i));
        % If after max camber position
        elseif x(i) >= p*c
            y_c(i) = m*(c-x(i))/(1-p)^2 * (1+(x(i)/c)-(2*p));
            dyc(i) = m/(1-p)^2*(2*p-2*x(i)/c);
            xi(i) = atan(dyc(i));
        end
    end
    
    x_L = x + y_t.*sin(xi);
    x_U = x - y_t.*sin(xi);
    y_L = y_c - y_t.*cos(xi);
    y_U = y_c + y_t.*cos(xi);
    % Concatenate Upper and Lower in CW Trailing Edge
    x_b = [flip(x_L),x_U]; % Flip x_L so that goes from right to left
    y_b = [flip(y_L),y_U]; % Flip y_L so matches flipped x_L
end

function [m,p,t] = extractAirfoilData(airfoilCode)
    %{
    Inputs: 
        airfoilCode - NACA_XXXX airfoil as a string, X's numbers
    Outputs:
        m - max camber
        p - location of max camber
        t - max thickness of airfoil
    %}
    code = airfoilCode(6:end); % Extract Numbers
    digits = code - '0'; % Convert to vector of digits
    m = digits(1)/100; % Calculate max camber
    p = digits(2)/10; % Calculate position of max camber 
    t = str2double(sprintf('%d%d',digits(3),digits(4)))/100; % Calculate thickness
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

Number_of_Rays = 2*Number_of_Panels; %The number of rays we have should be
%equivalent to the number of panels we want. Modified 2*N b/c only had 25
%per top and bottom before
Angle = 2*pi / Number_of_Rays; %The equal angle should just be the number of arrays 
%divided by the full arc of the circle
Angle_array = 0:Angle:2*pi; %this is an array describing all the rays, as described
%by their angle clockwise from the TE
x_array = (C/2)*cos(Angle_array) + C/2; %This takes the x-projection of each
%ray to get an array of N+1 x points on the x-axis, giving N panels.
end

function PlotAirfoil(x_b,y_b,y_c,c,name)
    %{
    Inputs:
        x_b - x coords TE on bottom to LE to on TE top
        y_b - y coords, same CW order from TE
        y_c - mean camber line
        c - chord length for plot scaling
        name - airfoil name for title
    Outputs:
        Plot of Airfoil geometry
    %}
    figure(); hold on; grid on;
    plot(x_b,y_b,"Marker","."); % Plotting Boundary of Airfoil
    % Adding Limits to x and y
    xlim([-0.05*c 1.05*c]);
    ylim([-c c]);
    % Labels and Title
    xlabel("X Position (0 to c)");
    ylabel("Y Position");
    title("Geometry of " + name + " Airfoil",Interpreter="none");
    % Only plot camber line if airfoil is cambered, Add legend for camber line vs boundary
    if any(y_c) % Runs if any values of y_c not equal to 0
        plot(x_b(length(x_b)/2+1:end),y_c,'-b'); % Plot second half of x_b vals for clockwise from LE
        legend("Airfoil Boundary","Mean Camber Line"); % Adds legend
    end
end