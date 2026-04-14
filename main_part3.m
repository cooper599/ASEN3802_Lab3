clear
clc
close all

b = 33.333;
c_r = 5.333;
c_t = 3.708;
N_ref = 1000;

%NACA 0012 NACA 2412
a0_t = 0.1200 * (180/pi);
a0_r = 0.1198 * (180/pi);
geo_t = 0;
geo_r = 1;

aero_t = -1.145e-14;
aero_r = -2.1549;

[c_L_reference, c_Di_reference,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N_ref);
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

while abs(c_L_tenth - c_L_reference) > 0.1
    [c_L_tenth, ~,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_1);
    n_1 = n_1+1;
end

while abs(c_L_hundredth - c_L_reference) > 0.01
    [c_L_hundredth, ~,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_2);
    n_2 = n_2+1;
end

while abs(c_L_thousandth - c_L_reference) > 0.001
    [c_L_thousandth, ~,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_3);
    n_3 = n_3+1;
end

while abs(c_Di_tenth - c_Di_reference) > 0.1
    [~, c_Di_tenth,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_4);
    n_4 = n_4+1;
end

while abs(c_Di_hundredth - c_Di_reference) > 0.01
    [~, c_Di_hundredth,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_5);
    n_5 = n_5+1;
end

while abs(c_Di_thousandth - c_Di_reference) > 0.001
    [~, c_Di_thousandth,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_6);
    n_6 = n_6+1;
end

