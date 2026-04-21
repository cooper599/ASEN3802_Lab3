%% ASEN 3802 - Lab 3 - Main
%               Part 3
% Task 1: Table of Cl, Cdi % errors
% Task 2: Plots Cl, Cdi vs N
% Task 3: Table of L, Di, L/D at cruise
% Task 4: Plot Cd vs alpha
% Task 5: Plot L/D vs alpha
%               Part 2 
% Task 1: Prandtl Lifting Line Theory
%               Part 1 
% Task 1: Create NACA Airfoil Generator, Plot Results
% Task 2: Vortex Panel Method, N Panel Convergence
% Task 3: Symmetric Airfoil Cl vs alpha
% Task 4: Cambered Airfoil Cl vs alpha
% Author: Cooper, Nathan, Sayer, Xander
% Date Created: Mar 31, 2026
% Date Last Updated: Apr 13, 2026
clc; clear all; close all;

%% Part 1: Task 1, NACA 0021, NACA 2421 Plotting Airfoils
% Airfoils for Task 1
airfoil1 = 'NACA_0021';
airfoil2 = 'NACA_2421';

N = 50; % Number of Panels for top and bottom each
c = 1; % Chord length

% Plotting and Calculations for Airfoil 1
[m,p,t] = extractAirfoilData(airfoil1); % Calc m,p,t
[x_b,y_b,y_c,x,~] = NACA_Airfoils(m,p,t,c,N); % Calc geometry
PlotAirfoil(x_b,y_b,y_c,x,c,airfoil1); % Plot geometry

% Plotting and Calculations for Airfoil 2
[m,p,t] = extractAirfoilData(airfoil2);
[x_b,y_b,y_c,x,~] = NACA_Airfoils(m,p,t,c,N);
PlotAirfoil(x_b,y_b,y_c,x,c,airfoil2);


%% Part 1: Task 2, Vortex Panel Method
% Find cl of NACA 0012 at Alpha = 12 deg, Find N panels to converge to < 1% error
p2plot = 1;
if p2plot == 0
% Input parameters for Vortex Panel
airfoil3 = 'NACA_0012';
c = 1;
NumPanels = linspace(10,500,491);
alpha = 12; % AoA, degrees
[m,p,t] = extractAirfoilData(airfoil3);

predicted_cl = zeros(1,length(NumPanels));
% Loop for N panel convergence
for i = 1:length(NumPanels)
    [x_b,y_b,y_c,x,~] = NACA_Airfoils(m,p,t,c,NumPanels(i));
    predicted_cl(i) = Vortex_Panel(x_b,y_b,alpha);
end

% Caluclate "exact" cl with large number of panels, store to save future run time
% [x_b,y_b,y_c,x] = NACA_Airfoils(m,p,t,c,3000);
% exact_cl = Vortex_Panel(x_b,y_b,alpha);
exact_cl = 1.438326093800802; % From 6000 total panels

% Percent Difference Formula, check if % diff < 1% error
[val, idx] = find((abs(exact_cl-predicted_cl)./((exact_cl + predicted_cl)./2) .* 100) < 1,1,"first");

% Plot of predicted cl vs number of panels used for calculation
figure(); hold on;
plot(2*NumPanels,predicted_cl,'b');
yline(exact_cl,'k');
yline(1.01*exact_cl,'r--');
yline(0.99*exact_cl,'r--');
xline(2*NumPanels(idx),'g--',LineWidth=2);
xlabel("Total Number of Panels (N)");
ylabel("Predicted Sectional Lift Coefficient (c_l)");
title("Predicted Sectional Lift Coefficient vs Number of Panels");
legend("Predicted c_l","Exact c_l","1% Error Bounds","","Min Number of Panels for < 1% Error",Location="southeast");

% Print needed info to command window
fprintf("Sectional Lift Coefficient (cl) for NACA 0012 at 12 degrees: %.3f \n", exact_cl);
fprintf("Min Number of Panels Needed for < 1 Percent Error from Exact: %.1f \n",2*NumPanels(idx));

% Extracting Data For Table
% Use 10, 50, 100, 200, 500 (Multiply by 2 for Total Panels)
% Cl, Num Panels, Relative Error, Min Panels for Convergence (separate)
Panels = [10, 50, 100, 200, 500];
TotPanels = zeros(1,5);
Cls = zeros(1,5);
RelativeError = zeros(1,5);
Names = ["Tot Panels","Cl","Relative Error"];
for i = 1:5
    idx = find(NumPanels == Panels(i),1,"first");
    Cls(i) = predicted_cl(idx);
    TotPanels(i) = Panels(i);
    RelativeError(i) = (abs(exact_cl-Cls(i))/(exact_cl+Cls(i))/2) * 100; % Convert to %
end
p2table = table(2.*Panels',Cls',RelativeError','VariableNames',Names)
end
minpanels = 76; % Numpanels(idx), hard coded to save time

%% Part 1: Task 3, Effect of Airfoil Thickness on Lift
% Load Airfoil data avaiable
load("NACA0006.mat"); load("NACA0012.mat"); % load("NACA0018.mat");
p3names = ["NACA0006","NACA0012","NACA0018"];
p3Airfoils.(p3names(1)) = NACA0006;
p3Airfoils.(p3names(2)) = NACA0012;
% p3Airfoils.(p3names(3)) = NACA0018;
% Temp Names for loop
airfoil4 = 'NACA_0006'; airfoil5 = 'NACA_0012'; airfoil6 = 'NACA_0018';
tempp3names = {airfoil4,airfoil5,airfoil6};

colors = {'r','b','k'}; % For plotting later

% Preallocate data for tables and plotting
% Zero lift angle of attack
pt3_clalpha0.tat = zeros(3,1);
pt3_clalpha0.vp = zeros(3,1);
pt3_clalpha0.exp = zeros(3,1);
% Lift Slope
pt3_clslope.vp = zeros(3,1);
pt3_clslope.tat = zeros(3,1);
pt3_clslope.exp = zeros(3,1);

% Loop through all airfoils to calculate needed data
alphavec = linspace(-10,20,100);
for i = 1:length(tempp3names)
    % Thin Airfoil Theory
    pt3_clslope.tat(i) = (2*pi)*pi/180; % pi/180 = 1°, const slope 2pi
    tempclvec = zeros(1,length(alphavec));
    [m,p,t] = extractAirfoilData(tempp3names{i});
    [x_b,y_b,y_c,x,slope] = NACA_Airfoils(m,p,t,c,minpanels);
    pt3_clalpha0.tat(i) = ZeroLiftAoA(slope,x,c);
    % Predicted Cl from TaT 2pi(alpha-alphaL=0)
    for ii = 1:length(alphavec)
        tempclvec(ii) = 2*pi*deg2rad(alphavec(ii)-pt3_clalpha0.tat(i));
    end
    TaT.(tempp3names{i}) = tempclvec;
    % Vortex Panel Method
    targalpha = 0;
    % Cl from 2 AoA
    cl0 = Vortex_Panel(x_b,y_b,0);
    cl5 = Vortex_Panel(x_b,y_b,5);
    pt3_clslope.vp(i) = (cl5-cl0)/5;
    pt3_clalpha0.vp(i) = cl0/pt3_clslope.vp(i); % AoA for Cl = 0
    % Experimental, if to take care of missing NACA0018 Data
    if i ~=3
        % Zero Lift AoA calculations
        alpha_data = p3Airfoils.(p3names(i)).data(1).x;
        cl_data = p3Airfoils.(p3names(i)).data(1).y;
        pt3_clalpha0.exp(i) = interp1(cl_data, alpha_data, targalpha, 'linear');
        % Lift Slope calculations
        idx = (alpha_data >= -5 & alpha_data <= 5); % idk why && didn't work
        p = polyfit(alpha_data(idx), cl_data(idx), 1);
        pt3_clslope.exp(i) = p(1); % Extract slope (slope,intercept)
    else % for NACA 0018, no experimental data
        pt3_clalpha0.exp(i) = "N/A";
        pt3_clslope.exp(i) = "N/A";
    end
end

% Plotting data
figure(); hold on;
for i = 1:length(p3names)
    if i ~= 3 % Plots cl vs alpha experimental vs thin airfoil theory
        plotClvsAlphaExp(p3Airfoils.(p3names(i)).data(1).y,p3Airfoils.(p3names(i)).data(1).x,p3Airfoils.(p3names(i)).name,colors{i});
        plot(alphavec,TaT.(tempp3names{i}),'--','DisplayName',p3Airfoils.(p3names(i)).name + " Thin Airfoil Theory",Color=colors{i});
    else % Don't plot 0018 b/c data missing
        plot(alphavec,TaT.(tempp3names{i}),'--','DisplayName',"NACA 0018 Thin Airfoil Theory",Color=colors{i});
    end
end
xlabel("Angle of Attacks (°)");
ylabel("Sectional Coefficient of Lift");
title("Comparison of Airfoil Cl vs Angle of Attack");
legend(Location="northwest");

% Combine all data into tables for easy reading
pt3tableNames = ["Airfoil","Vortex Panel","Thin Airfoil Theory","Experimental"];
pt3alphaL0_table = table(p3names',pt3_clalpha0.vp,pt3_clalpha0.tat,pt3_clalpha0.exp,'VariableNames',pt3tableNames)
pt3_dalpha_dcl_estimate = table(p3names',pt3_clslope.vp,pt3_clslope.tat,pt3_clslope.exp,'VariableNames',pt3tableNames)

%% Part 1: Task 4, Effect of Airfoil Thickness on Lift
% Load airfoil data
load("NACA0012.mat"); load("NACA2412.mat"); load("NACA4412.mat");
p4names = ["NACA0012","NACA2412","NACA4412"];
p4Airfoils.(p4names(1)) = NACA0012;
p4Airfoils.(p4names(2)) = NACA2412;
p4Airfoils.(p4names(3)) = NACA4412;
% Temp Names for VP loop
airfoil7 = 'NACA_0012'; airfoil8 = 'NACA_2412'; airfoil9 = 'NACA_4412';
tempp4names = {airfoil7,airfoil8,airfoil9};

% Preallocate arrays for tables
% alpha Cl=0
pt4_clalpha0.vp = zeros(3,1);
pt4_clalpha0.tat = zeros(3,1);
pt4_clalpha0.exp = zeros(3,1);
% dcl/dalpha
pt4_clslope.vp = zeros(3,1);
pt4_clslope.tat = zeros(3,1);
pt4_clslope.exp = zeros(3,1);

% Loop to calculate info needed for plot and table
for i = 1:length(p4names)
    targalpha = 0;
    % TaT
    tempclvec = zeros(1,length(alphavec));
    [m,p,t] = extractAirfoilData(tempp4names{i});
    [x_b,y_b,y_c,x,slope] = NACA_Airfoils(m,p,t,c,minpanels);
    pt4_clalpha0.tat(i) = ZeroLiftAoA(slope,x,c);
    % Predicted Cl from TaT 2pi(alpha-alphaL=0)
    for ii = 1:length(alphavec)
        tempclvec(ii) = 2*pi*deg2rad(alphavec(ii)-pt4_clalpha0.tat(i));
    end
    TaT.(tempp4names{i}) = tempclvec;
    pt4_clslope.tat(i) = (2*pi)*pi/180; % pi/180 = 1°
    % VP Method, Cl from 2 AoA
    cl0 = Vortex_Panel(x_b,y_b,0);
    cl5 = Vortex_Panel(x_b,y_b,5);
    pt4_clslope.vp(i) = (cl5-cl0)/5;
    pt4_clalpha0.vp(i) = -cl0/pt4_clslope.vp(i); % AoA for Cl = 0
    % Experimental
    alpha_data = p4Airfoils.(p4names(i)).data(1).x;
    cl_data = p4Airfoils.(p4names(i)).data(1).y;
    % Interpolate for AoA Cl=0
    pt4_clalpha0.exp(i) = interp1(cl_data, alpha_data, targalpha, 'linear');
    % Poly fit data to find slope
    idx = (alpha_data >= -5 & alpha_data <= 5); % idk why && didn't work
    p = polyfit(alpha_data(idx), cl_data(idx), 1);
    pt4_clslope.exp(i) = p(1); % Extract slope (slope,intercept)
end

% Plot data
figure(); hold on;
for i = 1:length(p4names) % Plots experimental vs TaT for all airfoils
    plotClvsAlphaExp(p4Airfoils.(p4names(i)).data(1).y,p4Airfoils.(p4names(i)).data(1).x,p4Airfoils.(p4names(i)).name,colors{i});
    plot(alphavec,TaT.(tempp4names{i}),'--','DisplayName',p4Airfoils.(p4names(i)).name + " Thin Airfoil Theory",Color=colors{i});
end
xlabel("Angle of Attacks (°)");
ylabel("Sectional Coefficient of Lift");
title("Comparison of Airfoil Cl vs Angle of Attack");
legend(Location="northwest");

% Combine all data into tables for easy reading
pt4_alphaL0_table = table(p4names',pt4_clalpha0.vp,pt4_clalpha0.tat,pt4_clalpha0.exp,'VariableNames',pt3tableNames)
pt4_dcl_dalpha_estimate = table(p4names',pt4_clslope.vp,pt4_clslope.tat,pt4_clslope.exp,'VariableNames',pt3tableNames)

%% Part 2: Task 1, Prandtl Lifting Line Theory
% Resolution of Plot
num_pts = 100;
% Number of PLLT Terms
num_terms = 50;
% Aspect Ratios Used in 5.20
AR = 4:2:10;
% Numerical Stabilizer
eps = 1e-10; 

% Create Arrays
c_r_array = linspace(eps,10,num_pts);
ratio = linspace(eps,1,num_pts);
c_t_array = ratio .* c_r_array;

% Create Plotting Figure
figure();
hold on

for j = 1:length(AR)
% Clear e_arr 
e_arr = zeros(1,num_pts);
delta_arr = e_arr;
% Iterate over aspect ratios
AR_it = AR(j);
% Solve for wingspan off of current AR
b = AR_it * (c_t_array + c_r_array) / 2;
    for k = 1:num_pts
        [e_arr(k), ~, ~] = PLLT(b(k), 2 * pi, 2 * pi, c_t_array(k), c_r_array(k), eps, eps, eps, eps, num_terms);
        delta_arr(k) = (1 / e_arr(k)) - 1;
    end
plot(ratio, delta_arr, LineWidth=2);
end

grid on
title('$\delta$ vs. $\frac{c_t}{c_r}$', 'Interpreter', 'latex')
xlabel('$\frac{c_t}{c_r}$', 'Interpreter', 'latex');
ylabel('\delta')
legend('AR = 4', 'AR = 6', 'AR = 8', 'AR = 10');

%% Part 3: Task 1, Table of Cl cdi vs number terms for accuracy
%{ 
Function Inputs for reference
b - wing span (ft)
a0_t - cross sectional lift slope at tip (/rad)
a0_r - Cross sectional lift slope at root (/rad)
c_t - chord length of tip ft
c_r - chord length of root ft
aero_t - zero lift angle of attack at tip (deg)
aero_r - zero lift angle of attack at root (deg)
geo_t - geo angle of attack at tips (deg)
geo_r - geo angle of attack at root (deg)
N - Number of terms for fourier coefficient calculation
%}
b = 33 + 4/12;% ft
c_r = 5 + 4/12; % ft
c_t = 3 + 8.5/12; % ft
N_ref = 1000; 

% NACA 0012 (tip) - NACA 2412 (root)
a0_t = pt4_clslope.vp(1) * (180/pi); % converted to rad
a0_r = pt4_clslope.vp(2) * (180/pi); % converted to rad
alpha = 4;
geo_t = 0 + alpha; % degrees
geo_r = 1 + alpha; % degrees

aero_t = pt4_clalpha0.vp(1);
aero_r = pt4_clalpha0.vp(2);

% for alpha = 4°
[c_L_reference, c_Di_reference,~] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N_ref);
c_L_tenth = 0;
c_L_hundredth = 0;
c_L_thousandth = 0;
c_Di_tenth = 0;
c_Di_hundredth = 0;
c_Di_thousandth = 0;
n_1 = 1;
n_2 = 1;
n_3 = 1;
n_4 = 1;
n_5 = 1;
n_6 = 1;

while ((abs(c_L_tenth - c_L_reference)/c_L_reference)*100) > 10
    [c_L_tenth, ~,~] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_1);
    n_1 = n_1+1;
end

while ((abs(c_L_hundredth - c_L_reference)/c_L_reference)*100) > 1
    [c_L_hundredth, ~,~] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_2);
    n_2 = n_2+1;
end

while ((abs(c_L_thousandth - c_L_reference)/c_L_reference)*100) > 0.1
    [c_L_thousandth, ~,~] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_3);
    n_3 = n_3+1;
end

while ((abs(c_Di_tenth - c_Di_reference)/c_Di_reference)*100) > 10
    [~, c_Di_tenth,~] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_4);
    n_4 = n_4+1;
end

while ((abs(c_Di_hundredth - c_Di_reference)/c_Di_reference)*100) > 1
    [~, c_Di_hundredth,~] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_5);
    n_5 = n_5+1;
end

while ((abs(c_Di_thousandth - c_Di_reference)/c_Di_reference)*100) > 0.1
    [~, c_Di_thousandth,~] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_6);
    n_6 = n_6+1;
end

%% Part 3: Task 3, L, Di, L/D (D = cd + cdi)
% 100 Knots, 10 000 ft altitude. L = ClqS
S = b * (c_r+c_t) / 2; % Planform Area, ft^2
V = 100 * 1.68781; % convert to ft/s
rho = 1.7556*10^-3; % slugs/ft^3
q = 0.5 * rho * V^2;
% Calculations 
L = c_L_thousandth * q * S;
Di = c_Di_thousandth * q * S;
cd = (0.007+.0075)/2; % 0.007 for 0012, 0.0075 for 2412
Cd = cd + c_Di_thousandth;
D = Cd * q * S;
Efficiency = L/D;


%% Part 1 Functions
function [x_b,y_b,y_c,x,slope] = NACA_Airfoils(m,p,t,c,N)
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
         x  - X coordinates generated by ray method
      slope - slope of camber line?
    %}
    % Create x value array using ray method
    x = GeometricXValues(N,c);
    % Calculates the thickness distribution of airfoil
    y_t = (t*c/0.2)*((0.2969*sqrt(x/c) - 0.1260*(x/c)-0.3516*(x/c).^2 + 0.2843*(x/c).^3 - 0.1036*(x/c).^4));
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
    % Concatenate Upper and Lower in CW Trailing Edge, modify indices so
    % doesn't double up array values, flip for correct order
    x_b = [x_L, fliplr(x_U(1:end-1))]; % Flip x_U so that goes from left to right
    y_b = [y_L, fliplr(y_U(1:end-1))]; % Flip y_U so matches flipped x_U
    slope = dyc; % Returns slope of camber line
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
    code = airfoilCode(end-3:end); % Extract Numbers
    digits = code - '0'; % Convert to vector of digits
    m = digits(1)/100; % Calculate max camber
    p = digits(2)/10; % Calculate position of max camber 
    t = str2double(code(3:4))/100; % Calculate thickness
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
% Modified change from 2pi to pi to get rid of doubling coord error
Number_of_Rays = Number_of_Panels; %The number of rays we have should be
%equivalent to the number of panels we want.
Angle = pi / Number_of_Rays; %The equal angle should just be the number of arrays 
%divided by the full arc of the circle
Angle_array = 0:Angle:pi; %this is an array describing all the rays, as described
%by their angle clockwise from the TE
x_array = (C/2)*cos(Angle_array) + C/2; %This takes the x-projection of each
%ray to get an array of N+1 x points on the x-axis, giving N panels.
end

function PlotAirfoil(x_b,y_b,y_c,x,c,name)
    %{
    Inputs:
        x_b - x coords TE on bottom to LE to on TE top
        y_b - y coords, same CW order from TE
        y_c - mean camber line
         x  - x coordinates for camber line plotting
        c - chord length for plot scaling
        name - airfoil name for title
    Outputs:
        Plot of Airfoil geometry
    %}
    figure(); hold on; grid on;
    plot(x_b,y_b,"Marker",".",DisplayName="Airfoil Boundary"); % Plotting Boundary of Airfoil
    % Adding Limits to x and y
    xlim([-0.05*c 1.05*c]);
    ylim([-c c]);
    % Labels and Title
    xlabel("X Position (0 to c)");
    ylabel("Y Position");
    title("Geometry of " + name + " Airfoil",Interpreter="none");
    % Only plot camber line if airfoil is cambered, Add legend for camber line vs boundary
    if any(y_c) % Runs if any values of y_c not equal to 0
        plot(x,y_c,'-b',DisplayName="Mean Camber Line"); % Plot camber line with x coordinates from ray generation
    end
    legend("show");
end

% Functions for Task 2
function [CL] = Vortex_Panel(XB,YB,ALPHA)
% Modified, removed VINF from inputs b/c not used in function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:                           %
%                                  %
% XB  = Boundary Points x-location %
% YB  = Boundary Points y-location %
% VINF  = Free-stream Flow Speed   %
% ALPHA = AOA                      %
%                                  %
% Output:                          %
%                                  %
% CL = Sectional Lift Coefficient  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% Convert to Radians %
%%%%%%%%%%%%%%%%%%%%%%

ALPHA = ALPHA*pi/180;

%%%%%%%%%%%%%%%%%%%%%
% Compute the Chord %
%%%%%%%%%%%%%%%%%%%%%

CHORD = max(XB)-min(XB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine the Number of Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = max(size(XB,1),size(XB,2))-1;
MP1 = M+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intra-Panel Relationships:                                  %
%                                                             %
% Determine the Control Points, Panel Sizes, and Panel Angles %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    IP1 = I+1;
    X(I) = 0.5*(XB(I)+XB(IP1));
    Y(I) = 0.5*(YB(I)+YB(IP1));
    S(I) = sqrt( (XB(IP1)-XB(I))^2 +( YB(IP1)-YB(I))^2 );
    THETA(I) = atan2( YB(IP1)-YB(I), XB(IP1)-XB(I) );
    SINE(I) = sin( THETA(I) );
    COSINE(I) = cos( THETA(I) );
    RHS(I) = sin( THETA(I)-ALPHA );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-Panel Relationships:             %
%                                        %
% Determine the Integrals between Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    for J = 1:M
        if I == J
            CN1(I,J) = -1.0;
            CN2(I,J) = 1.0;
            CT1(I,J) = 0.5*pi;
            CT2(I,J) = 0.5*pi;
        else
            A = -(X(I)-XB(J))*COSINE(J) - (Y(I)-YB(J))*SINE(J);
            B = (X(I)-XB(J))^2 + (Y(I)-YB(J))^2;
            C = sin( THETA(I)-THETA(J) );
            D = cos( THETA(I)-THETA(J) );
            E = (X(I)-XB(J))*SINE(J) - (Y(I)-YB(J))*COSINE(J);
            F = log( 1.0 + S(J)*(S(J)+2*A)/B );
            G = atan2( E*S(J), B+A*S(J) );
            P = (X(I)-XB(J)) * sin( THETA(I) - 2*THETA(J) ) ...
              + (Y(I)-YB(J)) * cos( THETA(I) - 2*THETA(J) );
            Q = (X(I)-XB(J)) * cos( THETA(I) - 2*THETA(J) ) ...
              - (Y(I)-YB(J)) * sin( THETA(I) - 2*THETA(J) );
            CN2(I,J) = D + 0.5*Q*F/S(J) - (A*C+D*E)*G/S(J);
            CN1(I,J) = 0.5*D*F + C*G - CN2(I,J);
            CT2(I,J) = C + 0.5*P*F/S(J) + (A*D-C*E)*G/S(J);
            CT1(I,J) = 0.5*C*F - D*G - CT2(I,J);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-Panel Relationships:           %
%                                      %
% Determine the Influence Coefficients %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    AN(I,1) = CN1(I,1);
    AN(I,MP1) = CN2(I,M);
    AT(I,1) = CT1(I,1);
    AT(I,MP1) = CT2(I,M);
    for J = 2:M
        AN(I,J) = CN1(I,J) + CN2(I,J-1);
        AT(I,J) = CT1(I,J) + CT2(I,J-1);
    end
end
AN(MP1,1) = 1.0;
AN(MP1,MP1) = 1.0;
for J = 2:M
    AN(MP1,J) = 0.0;
end
RHS(MP1) = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for the gammas %
%%%%%%%%%%%%%%%%%%%%%%%%

GAMA = AN\RHS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for Tangential Veloity and Coefficient of Pressure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    V(I) = cos( THETA(I)-ALPHA );
    for J = 1:MP1
        V(I) = V(I) + AT(I,J)*GAMA(J);
    end
    CP(I) = 1.0 - V(I)^2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for Sectional Coefficient of Lift %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CIRCULATION = sum(S.*V);
CL = 2*CIRCULATION/CHORD;
end

% Functions for Task 3
function plotClvsAlphaExp(cl,alpha,name,color)
    %{
    Inputs:
        cl - vector of coefficient of lifts at specific AoA
        alpha - vector of various AoA in degrees
        name - data set name
        color - plotting colour
    Outputs:
        plots cl vs alpha, adds data for legend creation and correct
        plotting colour
    %}
    plot(alpha,cl,"DisplayName",name + " Experimental Data",Color=color);
end

function [ZeroLiftAoA] = ZeroLiftAoA(Slope,x,c)
%{
This function numerically integrate TaT eq to find alpha cl = 0
Inputs:
    Slope - slope of the camber line across span (dyc)
    x - x coordinate of the corresponding slope
    c - chord length
Outputs:
    ZeroLiftAoA - Returns the zero lift angle of attack in degrees
%}
x = fliplr(x); % Gets rid of negative by flipping
theta_0 = (acos(1-(x.*(2/c)))); % Transformation
integrand = Slope .* (cos(theta_0) - 1); % What being integrated
Integral = trapz(theta_0,integrand); % Integration
ZeroLiftAoA = rad2deg((1/pi).*Integral); % got rid of 180/pi and negative
end

%% Part 2 Functions
function [e,c_L,c_Di] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N)
% PLLT finds span efficiency factor, coefficient of lift, and induced drag
% for a given 3D finite wing. It takes in the dimensions of the wing which
% are listed below and using PLLT, we find what the wing will do. It uses
% Fourier Series for a finite number of terms, N, and outputs the Fourier
% coefficients. Using these, we can find Cl, e, and CDi. 
% Author: Nathan Bidlingmaier
% Date: 04/12/2026
%{
Inputs:
    b - wing span (ft)
    a0_t - cross sectional lift slope at tip (/rad)
    a0_r - Cross sectional lift slope at root (/rad)
    c_t - chord length of tip ft
    c_r - chord length of root ft
    aero_t - zero lift angle of attack at tip (deg)
    aero_r - zero lift angle of attack at root (deg)
    geo_t - geo angle of attack at tips (deg)
    geo_r - geo angle of attack at root (deg)
    N - Number of terms for fourier coefficient calculation
Outputs:
    e - Oswald's efficiency factor
    c_L - coefficient of lift
    c_Di - coefficient of (induced) drag
%}
% Calculate the induced drag coefficient and efficiency factor
i = 1:N;  % makes a vector of length N

% Converting degrees to radians for consistency
geo_t = deg2rad(geo_t); 
geo_r = deg2rad(geo_r); 
% aero_r = deg2rad(aero_r);
% aero_t = deg2rad(aero_t);

theta_i = i*pi / (2*N);     % Finding theta for each N

% Physical geometry to find the following as a function of theta
c  = c_r  + (c_t  - c_r)  * cos(theta_i);
a0 = a0_r + (a0_t - a0_r) * cos(theta_i);
alpha_L0 = aero_r + (aero_t - aero_r) * cos(theta_i);
alpha_geo = geo_r + (geo_t - geo_r) * cos(theta_i);

% -------- Creating vector B and matrix A for computations ----------
B = alpha_geo - alpha_L0; % Alpha effective, change 
A = ones(N,N);
% row = 1:N;
% Finding values of A
for j = 1:length(i)
    for k = 1:length(i)
        n = 2*k - 1;    % Makes it odd terms only
        % row = (2*b/(pi*c(j)) * sin(n * theta_i(j))) + n*sin(n*theta_i(j))/sin(theta_i(j));
        row = (4*b/(a0(j)*c(j)) * sin(n * theta_i(j))) + n*sin(n*theta_i(j))/sin(theta_i(j));
        A(j,k) = row; % Create A matrix
    end

end
x = A \ B';     % outputs the odd Fourier coefficents
% ------- Using the Fourier coefficients to find CL --------------
S = b * (c_r+c_t) / 2; % Planform Area
AR = b^2/S; % Aspect ratio
c_L = x(1) * pi * AR; % Calculate Coefficient of Lift

% solving for e
delta = 0;
for j = 2:N 
    n = 2*j - 1;    % Makes it odd
    delta = delta + (n * (x(j)/x(1))^2);
end
e = 1/(1+delta); % Efficiency factor 
c_Di = c_L^2 / (pi * e * AR); % Induced Drag coefficient
end