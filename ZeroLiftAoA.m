function [ZeroLiftAoA] = ZeroLiftAoA(Slope,x,c)
%This function numerically integrates the thin airfoil theory equation to
%find the zero lift angle of attack
x = flip(x);
theta_0 = (acos(1-(x.*(2/c))));

%t = cos(theta_0);
integrand = Slope .* (cos(theta_0) - 1);

Integral = trapz(theta_0,integrand);

<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< HEAD
ZeroLiftAoA = (180/pi)*((-1/pi) .* Integral);

%There is a sign error somewhere in here********

end
=======
ZeroLiftAoA = -(180/pi)*((-1/pi) .* Integral);

%There is a sign error somewhere in here
%I put a negative sign above in the last line, but there's no justification
%for it other than it fixes the sign error.
end
>>>>>>> 6627471ffcd281f833de31d502975be6c03c81d4
=======
ZeroLiftAoA = -(180/pi)*((-1/pi) .* Integral);

%There is a sign error somewhere in here********
%I put a negative sign above in the last line, but there's no justification
%for it other than it fixes the sign error.
end
>>>>>>> Stashed changes
=======
ZeroLiftAoA = -(180/pi)*((-1/pi) .* Integral);

%There is a sign error somewhere in here********
%I put a negative sign above in the last line, but there's no justification
%for it other than it fixes the sign error.
end
>>>>>>> Stashed changes
