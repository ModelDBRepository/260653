function [tmap lmap] = plotThresholdMap(data, toPlot)
% [tmap lmap] = plotThresholdMap(data, toPlot)
% Plots the threshold and/or latency map for the given data set from NEURON 
% simulation. The input `data' should be a matrix with columns representing: x-cord, 
% y-cord, threholds and spike latency. The argument `toPlot' determines the map to
% plot in a new figure: (0 = plot nothing, 1 = threshold map, 2 = latency map).
% 
% Returns the threshold map in `tmap' and latency map in `lmap'.


% allocate spaces
rows = length(unique( data(:,2) ));
cols = length(unique( data(:,1) ));
tmap = zeros(rows, cols);
lmap = zeros(rows, cols);

% build map
s = unique(sort(data(:,1)));
inc = s(2) - s(1);
xOffset = (-1 * min(data(:,1))) / inc;
yOffset = (-1 * min(data(:,2))) / inc;
for i = 1:length(data(:,1))
    r = data(i,2)/inc + yOffset + 1;
    c = data(i,1)/inc + xOffset + 1;
    tmap(r, c) = data(i, 3) * -1000;
    if data(i, 4) > 0
        lmap(r, c) = data(i, 4);
    else
        lmap(r, c) = -1;  % -1 if no response
    end
end

if toPlot == 1 || toPlot == 3
    % plot threshold map
    [gHandle cbHandle] = showMap(rows, cols, data, tmap, 100);

    % color bar settings
    colormap(esa3(64));
    lb = get(cbHandle, 'YTickLabel');
    lb = [ repmat([' '], length(lb(:,1)), 1), lb];
    lb(end, 1) = '>';
    set(cbHandle, 'YTickLabel', lb);
    set(get(cbHandle,'xlabel'), 'String', '\muA');
end

if toPlot == 2 || toPlot == 3
    % plot latency map
    [gHandle cbHandle] = showMap(rows, cols, data, lmap, 450);

    % color bar settings
    cm = esa3(64);
    if (min(data(:,4)) == 0)  % black for locations > STIM_AMP_MAX
        cm(1, :) = [0 0 0];
    end
    colormap(cm);
    lb = get(cbHandle, 'YTickLabel');
    lb = [ repmat([' '], length(lb(:,1)), 1), lb];
    set(cbHandle, 'YTickLabel', lb);
    set(get(cbHandle,'xlabel'), 'String', 'ms');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gHandle cbHandle] = showMap(rows, cols, data, map, winXPos)
    xmin = min(data(:,1));
    xmax = max(data(:,1));
    ymin = min(data(:,2));
    ymax = max(data(:,2));
    
    % window position handling
    if xmax - xmin > 400
        figure('Position', [winXPos 100 540 320]);
    else
        figure('Position', [winXPos 100 320 320]);
    end
    subaxis(1, 1, 1, 'Margin', 0.14, 'PaddingRight', 0.14)

    % plot specified map
    gHandle = imagesc([xmin xmax], [ymin ymax], map);
    set(gca, 'XTick', [xmin:20:xmax]);
    set(gca, 'YTick', [ymin:20:ymax]);
    axis image;
    axis xy;
    set(gca, 'FontSize', 9);

    % x-axis cosmetics
    tk = get(gca, 'XTick');
    lb = get(gca, 'XTickLabel');
    set(gca, 'XTick', tk(1:4:end));
    set(gca, 'XTickLabel', lb(1:4:end,:));

    % y-axis cosmetics
    tk = get(gca, 'YTick');
    lb = get(gca, 'YTickLabel');
    set(gca, 'YTick', tk(1:4:end));
    set(gca, 'YTickLabel', lb(1:4:end,:));

    % color bar defaults
    cbHandle = colorbar;
    if xmax - xmin > 400
        set(cbHandle, 'Position', [0.75 0.24 0.020 0.2]);
    else
        set(cbHandle, 'Position', [0.75 0.21 0.035 0.2]);
    end

