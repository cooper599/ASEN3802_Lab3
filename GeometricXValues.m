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