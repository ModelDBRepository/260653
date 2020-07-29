function [E Ec] = potential(elecRad, stimX, stimY, stimZ, x, y, z)
% Calculates the voltage potential at position (x, y, z) for a disk electrode
% of radius `elecRad' positioned at location (stimX, stimY, stimZ). All inputs 
% are in um. 
%
% NOTE: THE FOLLOWING PROCEDURE IS INCORRECT. EDGE EFFECT IS FOR CURRENT, NOT 
% VOLTAGE.
% Besides the constant voltage model of the electrode, we also add a correction 
% factor, which scales up with electrode radius, to correct for the electrode
% field non-uniformity. The result is an envelop around the edge of the 
% electrode with stronger voltage field than otherwise. The magnitude is 
% dependent on the electrode time constant, which is tau = delta*pi*a / 4k, 
% where a is the electrode radius (cf. Behrend08). Currently this is calibrated 
% for 0.1 ms pulses.
% END INCORRTECT STUFF
% 
% Returns results in (`E') and with edge-effect correction in (`Ec').
% standard voltage field waaveform, as in Greenberg99


r = sqrt( (x-stimX).^2 + (y-stimY).^2 );
geo = (2*elecRad) ./ ...
    ( sqrt((r-elecRad).^2+(z-stimZ).^2) + sqrt((r+elecRad).^2+(z-stimZ).^2) );

% gaussian correction ring for edge-effect
a = elecRad*0.0001;  % amplitude of edge effect
b = elecRad*0.45;    % peak point of edge effect
c = elecRad*0.20;    % width of edge effect
edgeCor = 1 + a * exp( -((r-b).^2 / (2*c^2)) );

% without and with correction
E = 2 ./ pi * (asin(geo));
Ec = 2 ./ pi * (asin(geo) * edgeCor) - a;

