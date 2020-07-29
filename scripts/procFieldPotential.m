
% electrode parameters
elecRad = 100;
stimX = 0;
stimY = 0;
stimZ = 40;

% plot field parameters
fMin = -140;
fMax = 160;
fDelta = 0.5;

% side profile cutting through y=0
v = zeros(200, 1);
vc = zeros(200, 1);
for x = 1:200
    [v(x) vc(x)] = potential(elecRad, stimX, stimY, stimZ, x*0.5, 0, 0);
end
figure('Position', [100, 100, 350, 350]);
plot(1:200, v);
xlabel('X (\mum)')
ylabel('scale')
line([elecRad elecRad], get(gca, 'ylim'), 'LineStyle', ':', 'color', 'k');
title(sprintf('r_{electrode} = %d, z = %d', elecRad, stimZ));

% x-y field plan profile
fieldPotential(elecRad, stimX, stimY, stimZ, fMin, fMax, fDelta);
title(sprintf('r_{electrode} = %d, z = %d', elecRad, stimZ));

