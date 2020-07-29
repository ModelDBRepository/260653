function [F Fc] = fieldPotential(elecRad, stimX, stimY, stimZ, fieldMin, ...
    fieldMax, fieldDelta, scaled)
% Calculate voltage potential for a field starting at position `fieldMin' and ending
% at `fieldMax', with increments `fieldDelta'. The electrode of radius `elecRad' is
% placed at position `stimX' `stimY' `stimZ'.


% argument handling
if nargin < 8
    scaled = 0;
end

% preallocation
sz = length(fieldMin:fieldDelta:fieldMax);
F = zeros(sz, sz);
Fc = zeros(sz, sz);

% calculate potential at each point in the field
rr = 1;
for r = fieldMin:fieldDelta:fieldMax
    cc = 1;
    for c = fieldMin:fieldDelta:fieldMax
        [F(rr,cc) Fc(rr,cc)] = potential(elecRad, stimX, stimY, stimZ, c, r, 0);
        cc = cc + 1;
    end
    rr = rr + 1;
end

% scale against peak field amplitude
if scaled
    F = F ./ max(max(F));
end

% display plot
figure('Position', [450, 100, 260, 260]);
[c h] = contour([fieldMin:fieldDelta:fieldMax], [fieldMin:fieldDelta:fieldMax], F);
axis image
axis xy
xlabel('X (\mum)')
ylabel('Y (\mum)')
% clabel(c, h, 'LabelSpacing', 500, 'FontSize', 8);
% set(h, 'ShowText', 'on', 'TextStep', get(h,'LevelStep')*2)

% color bar
colormap(summer);
% cb = colorbar;
% set(get(cb,'xlabel'), 'String', 'e/e_{max}')

