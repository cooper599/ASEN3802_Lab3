
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
N_guess = 50;
i = 1;
[c_L_reference, c_Di_reference,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N_ref);
c_L_tenth = 0;
c_L_hundredth = 0;
c_L_thousandth = 0;
c_Di_tenth = 0;
c_Di_hundredth = 0;
c_Di_thousandth = 0;
c_L_tenth_array = zeros(1, N_guess);
c_L_hundredth_array = zeros(1, N_guess);
c_L_thousandth_array = zeros(1, N_guess);
c_Di_tenth_array = zeros(1, N_guess);
c_Di_hundredth_array = zeros(1, N_guess);
c_Di_thousandth_array = zeros(1, N_guess);
n_1 = 1;
n_2 = 1;
n_3 = 1;
n_4 = 1;
n_5 = 1;
n_6 = 1;
n_1_array = zeros(1, N_guess);
n_2_array = zeros(1, N_guess);
n_3_array = zeros(1, N_guess);
n_4_array = zeros(1, N_guess);
n_5_array = zeros(1, N_guess);
n_6_array = zeros(1, N_guess);

while ((abs(c_L_tenth - c_L_reference)/c_L_reference)*100) > 10
    [c_L_tenth, ~,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_1);
    c_L_tenth_array(i) = c_L_tenth;
    n_1_array(i) = n_1;
    i = i+1;
    n_1 = n_1+1;
end
c_L_tenth_array = c_L_tenth_array(1:(i-1));
n_1_array = n_1_array(1:(i-1));
i=1;
n_1 = n_1 - 1;
while ((abs(c_L_hundredth - c_L_reference)/c_L_reference)*100) > 1
    [c_L_hundredth, ~,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_2);
    c_L_hundredth_array(i) = c_L_hundredth;
    n_2_array(i) = n_2;
    n_2 = n_2+1;
    i = i+1;
end
c_L_hundredth_array = c_L_hundredth_array(1:(i-1));
n_2_array = n_2_array(1:(i-1));
i=1;
n_2 = n_2 - 1;
while ((abs(c_L_thousandth - c_L_reference)/c_L_reference)*100) > 0.1
    [c_L_thousandth, ~,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_3);
    c_L_thousandth_array(i) = c_L_thousandth;
    n_3_array(i) = n_3;
    n_3 = n_3+1;
    i = i+1;
end
c_L_thousandth_array = c_L_thousandth_array(1:(i-1));
n_3_array = n_3_array(1:(i-1));
i=1;
n_3 = n_3 - 1;
while ((abs(c_Di_tenth - c_Di_reference)/c_Di_reference)*100) > 10
    [~, c_Di_tenth,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_4);
    c_Di_tenth_array(i) = c_Di_tenth;
    n_4_array(i) = n_4;
    n_4 = n_4+1;
    i = i+1;
end
c_Di_tenth_array = c_Di_tenth_array(1:(i-1));
n_4_array = n_4_array(1:(i-1));
i=1;
n_4 = n_4 - 1;
while ((abs(c_Di_hundredth - c_Di_reference)/c_Di_reference)*100) > 1
    [~, c_Di_hundredth,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_5);
    c_Di_hundredth_array(i) = c_Di_hundredth;
    n_5_array(i) = n_5;
    n_5 = n_5+1;
    i = i+1;
end
c_Di_hundredth_array = c_Di_hundredth_array(1:(i-1));
n_5_array = n_5_array(1:(i-1));
i=1;
n_5 = n_5 - 1;
while ((abs(c_Di_thousandth - c_Di_reference)/c_Di_reference)*100) > 0.1
    [~, c_Di_thousandth,~] = PLLTFunction(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,n_6);
    c_Di_thousandth_array(i) = c_Di_thousandth;
    n_6_array(i) = n_6;
    n_6 = n_6+1;
    i = i+1;
end
c_Di_thousandth_array = c_Di_thousandth_array(1:(i-1));
n_6_array = n_6_array(1:(i-1));
i=1;
n_6 = n_6 - 1;
figure ()
hold on;
plot(n_3_array,c_L_thousandth_array,'g')
plot(n_2_array,c_L_hundredth_array,'b')
plot(n_1_array,c_L_tenth_array,'r')
xline(n_1,'r--');
xline(n_2,'b--');
xline(n_3,'g--');
legend('C_L 0.1%','C_L 1%','C_L 10%','10%','1%','0.1%');
xlim([0 (n_3 + 1)]);

figure ()
hold on;
plot(n_6_array,c_Di_thousandth_array,'g')
plot(n_5_array,c_Di_hundredth_array,'b')
plot(n_4_array,c_Di_tenth_array,'r')
xline(n_4,'r--');
xline(n_5,'b--');
xline(n_6,'g--');
legend('C_Di 0.1%','C_Di 1%','C_Di 10%','10%','1%','0.1%');
xlim([0 (n_6 + 1)]);

