%% ASEN 3802 - Lab 3 - Main
% Task 1: Create NACA Airfoil Generator, Plot Results
% Task 2: ...
% Task 3: ...
% Author : Cooper, Nathan
% Date: Mar 31, 2026
clc; clear all; clc;

function [m,p,t] = extractAirfoilData(airfoilCode)
    digits = airfoilCode - '0';
    m = digits(1)/100;
    p = digits(2)/10;   
    t = str2double(sprintf('%d%d',digits(3),digits(4)))/100;
end