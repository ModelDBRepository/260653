% parameters
elecRad = 20;              % electrode size (um)
rho = 110;                 % extracellular resistivity factor
x   = [0:200];             % lateral displacement (um)
z   = [15 30 60 120 160];  % height (um)

% calculations and plots
color = winter(length(z));
for i = 1:length(z)
	r = sqrt(x.^2 + x.^2);
	zz = z(i);
	geo = 2*elecRad ./ ...
		( sqrt((r-elecRad).^2 + zz.^2) + sqrt((r+elecRad).^2 + zz.^2) );
	plot(x, 2*rho*0.75*1/pi*asin(geo) * 0.001, 'color', color(i,:));
	hold on
end
hold off
xlabel('Radial dist (um)');
ylabel('Rx_{xtra} ');
box off;

% color bar cosmetics
colormap(color)
h = colorbar('Position', [0.8, 0.6, 0.02 0.2]);
set(h, 'YTick', [1.5:length(z)+1.5]);
set(h, 'YTickLabel', z);
xlabel(h, 'Z dist (um)');

