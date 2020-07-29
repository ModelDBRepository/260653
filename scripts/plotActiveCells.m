function actvMap = plotActiveCells(data, mapType, plotType)
% actvMap = plotActiveCells(data, noPlot)
% Plots the number of activated cell at each position for the given data set from 
% NEURON simulation. The input `data' should be a matrix with columns representing: 
% x-cord, y-cord, threholds and spike latency. `mapType' determines if the tile is
% for On cells or Off cells. The last optional argument `plotType' determines the 
% type of plot to display, 0 = no plot, 1 = number of active cells, 2 = active cell 
% ID plot. Default is 1.
% 
% Returns a r * c cell array, with each element being the ID of the cell(s) 
% activated.


% position of cell somas. XXX: To update if .hoc file changes
offSomaPos = [
    0 97.118143  -133.75122 
    1 178.98969  -277.07561 
    2 120.98395  53.738235 
    3 211.30423  -91.558108 
    4 301.03508  -231.20631 
    5 389.05741  -374.66452 
    6 243.99255  97.233144 
    7 323.30992  -37.163077 
    8 424.65008  -177.20494 
    9 506.49403  -315.99998 
    10 355.59918  151.07407 
    11 451.70593  14.821949 
    12 543.25002  -132.67279 
    13 632.9313  -270.1977 
    14 573.57673  61.75017 
    15 662.45944  -75.781875 
    16 742.06736  -218.78062 
    17 688.38652  101.2451 
    18 774.19966  -27.954462 
];
onSomaPos = [
    0 97.118143 -133.75122 
    1 178.98969 -277.07561 
    2 117.98395 56.738235 
    3 208.30423 -88.558108 
    4 298.03508 -228.20631 
    5 386.05741 -371.66452 
    6 237.99255 103.23314 
    7 317.30992 -31.163077 
    8 418.65008 -171.20494 
    9 500.49403 -309.99998 
    10 346.59918 160.07407 
    11 442.70593 23.821949 
    12 534.25002 -123.67279 
    13 623.9313 -261.1977 
    14 561.57673 73.75017 
    15 650.45944 -63.781875 
    16 730.06736 -206.78062 
    17 673.38652 116.2451 
    18 759.19966 -12.954462 
];


% input argument handling
if nargin < 3
    plotType = 1;
end

% allocate spaces
rows = length(unique( data(:,2) ));
cols = length(unique( data(:,1) ));
countMap = zeros(rows, cols);
actvMap = cell(rows, cols);

% build activity map
s = unique(sort(data(:,1)));
inc = s(2) - s(1);
xOffset = (-1 * min(data(:,1))) / inc;
yOffset = (-1 * min(data(:,2))) / inc;
for i = 1:length(data(:,1))
    r = data(i,2)/inc + yOffset + 1;
    c = data(i,1)/inc + xOffset + 1;
    cellIds = activeCells(data(i, 4));
    
    countMap(r, c) = length(cellIds);
    actvMap{r, c} = cellIds;
end

% plot results
if plotType == 0
    return
elseif plotType == 1
    showActivityMap(data, countMap);
elseif plotType == 2
    if mapType == 'of'
        % off cells
        showIdMap(data, actvMap, offSomaPos);
    else
        % on cells
        showIdMap(data, actvMap, onSomaPos);
    end
elseif plotType == 3
    if mapType == 'of'
        % off cells
        showCoActivationWithThreshold(data, actvMap, offSomaPos);
    else
        % on cells
        showCoActivationWithThreshold(data, actvMap, onSomaPos);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cellList = activeCells(val)
    % negative value designates overstim, ignore for now
    val = abs(val);

    % returns a list containing the ID of all activated cells
    cellList = [];
    val = uint32(val);
    for i = 1:32
        if (bitget(val, i) == 1)
            cellList = [cellList i];
        end
    end

function [gHandle cbHandle] = showActivityMap(data, map)
    xmin = min(data(:,1));
    xmax = max(data(:,1));
    ymin = min(data(:,2));
    ymax = max(data(:,2));
    gradients = max(max(map));
    if gradients < 3
        gradients = 3;
    end

    % plot results
    gHandle = basicPlot(xmin, xmax, ymin, ymax, map, gradients);
    colormap(esa(gradients));
    cbHandle = colorbar;
    set(cbHandle, 'Position', [0.78 0.21 0.036 0.2]);
    set(cbHandle, 'YTick', [1 gradients]);
    set(get(cbHandle,'xlabel'), 'String', 'Cells');

function [gHandle cbHandle] = showIdMap(data, actvMap, pos)
    xmin = min(data(:,1));
    xmax = max(data(:,1));
    ymin = min(data(:,2));
    ymax = max(data(:,2));

    % build map of activated cell IDs, use minimum ID if there are more than one
    minMap = zeros(size(actvMap));
    for r = 1:length(actvMap(:,1))
        for c = 1:length(actvMap(1,:))
            minMap(r,c) = actvMap{r,c}(1);
        end
	end

    % plot a default ID map
    gHandle = basicPlot(xmin, xmax, ymin, ymax, minMap, max(max(minMap)));
    cm = colormap(jet( max(max(minMap))+1 ));

    % mark out all places with 1+ active cells specially
    for r = 1:length(actvMap(:,1))
        for c = 1:length(actvMap(1,:))
            if length(actvMap{r,c}) > 1
                patch([xmin+10*(c-1)-5 xmin+10*(c-1)-5 xmin+10*(c-1)+5], ...
                      [ymin+10*(r-1)-5 ymin+10*(r-1)+5 ymin+10*(r-1)+5], ...
                      cm(actvMap{r,c}(1), :));  % 1st cell
                patch([xmin+10*(c-1)-5 xmin+10*(c-1)+5 xmin+10*(c-1)+5], ...
                      [ymin+10*(r-1)-5 ymin+10*(r-1)-5 ymin+10*(r-1)+5], ...
                      cm(actvMap{r,c}(2), :));  % 2nd cell
            end
            if length(actvMap{r,c}) > 2
                patch([xmin+10*(c-1)-5 xmin+10*(c-1) xmin+10*(c-1)+5], ...
                      [ymin+10*(r-1)-5 ymin+10*(r-1) ymin+10*(r-1)-5], ...
                      cm(actvMap{r,c}(3), :));  % 3rd cell
            end
        end
    end

    % only annotate soma within boundary
    for i = 1:length(pos(:,1))
        if pos(i,2)>=xmin && pos(i,2)<=xmax && pos(i,3)>=ymin && pos(i,3)<=ymax
            text(pos(i,2)-3, pos(i,3)+1, 'x', 'Color', 'k');
        end
    end

function [gHandle cbHandle] = showCoActivationWithThreshold(data, actvMap, pos)
    xmin = min(data(:,1));
    xmax = max(data(:,1));
    ymin = min(data(:,2));
    ymax = max(data(:,2));

    % build map of activated cell IDs, use minimum ID if there are more than one
    minMap = zeros(size(actvMap));
    for r = 1:length(actvMap(:,1))
        for c = 1:length(actvMap(1,:))
            minMap(r,c) = actvMap{r,c}(1);
        end
    end

    % plot threshold map
    [tmap, lmap] = plotThresholdMap(data, 1);

    % mark out all places with 1+ active cells
    for r = 1:length(actvMap(:,1))
        for c = 1:length(actvMap(1,:))
            if length(actvMap{r,c}) ~= 1
                line([xmin+10*(c-1)-5 xmin+10*(c-1)+5], ...
                     [ymin+10*(r-1)+5 ymin+10*(r-1)+5], 'color', 'k')
                line([xmin+10*(c-1)+5 xmin+10*(c-1)+5], ...
                     [ymin+10*(r-1)+5 ymin+10*(r-1)-5], 'color', 'k')
                line([xmin+10*(c-1)-5 xmin+10*(c-1)+5], ...
                     [ymin+10*(r-1)-5 ymin+10*(r-1)-5], 'color', 'k')
                line([xmin+10*(c-1)-5 xmin+10*(c-1)-5], ...
                     [ymin+10*(r-1)+5 ymin+10*(r-1)-5], 'color', 'k')
            end
        end
    end

function gHandle = basicPlot(xmin, xmax, ymin, ymax, map, gradients)
    % window position handling
    if xmax - xmin > 400
        figure('Position', [450 100 540 320]);
    else
        figure('Position', [450 100 320 320]);
    end

    % plot specified map
    subaxis(1, 1, 1, 'Margin', 0.14, 'PaddingRight', 0.14)
    gHandle = imagesc([xmin xmax], [ymin ymax], map, [1 gradients]);
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

