function M_01WM1_1()
% Re-process M-01WM1-1.swc trace file to fill in missing information not inserted
% by Simple Neurite Tracer version 2.0.0
% 
% NOTE: Must delete first line of SWC file from Simple Neurite Tracer


data = load('M-01WM1-1.swc');

% center soma to coordinate (0,0,0)
data(:, [3 4]) = data(:, [3 4]) - ...
    repmat([130.22222319245338 77.33333390951157], length(data(:,1)), 1);

% somatic radius 6.44um as seem in confocal data
soma = find( data(:,2)==1 );
data(soma, 6) = 6.44;

% axon radius 0.45um per Watanabe and Rodieck 1989
axon = find( data(:,2)==2 );
data(axon, 6) = 0.45;

% general dendritic radius 0.135um
dendrites = find( data(:,2)==3 );
data(dendrites, 6) = 0.135;

% 1st and 2nd primary dendrite taper radius 1um -> 0.135um as seen in confocal data
for i = 527:621
    data(i, 6) = 1 - (1-0.135) * ((i-527)/(621-527));
end
for i = 622:1047
    data(i, 6) = 1 - (1-0.135) * ((i-622)/(1047-622));
end

% general axon depth 5.6 um
data(axon, 5) = -5.6;

% general dendritic depth 11.1 um with stdev 1 um
data(dendrites, 5) = 11.1;

% 1st and 2nd primary dendrite depth from 0 um to 11.1 um 
for i = 527:536
    data(i, 5) = 11.1 * (i-527)/(536-527);
end
for i = 622:631
    data(i, 5) = 11.1 * (i-622)/(631-622);
end

% save results to file
fid = fopen('M-01WM1-1-proc.swc', 'w');
for i = 1:length(data(:,1))
    fprintf(fid, '%d %d %.3f %.3f %.3f %.3f %d', data(i,:));
    fprintf(fid, '\n');
end
fclose(fid);

