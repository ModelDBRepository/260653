function dist = calcSegDistance(list, ptA, ptB)
% function dist = calcSegDistance(list, ptA, ptB)
% Calculate the 3D distance between position A and B in `list', by traversing 
% all intermediate nodes between them. The parameter `list' should be a n by 4
% matrix of x,y,z,diam values from neurolucida.


dist = 0;
for i = ptA:ptB-1
    dist = dist + dist3d( list(i,:), list(i+1,:) );
end

function d = dist3d(vec1, vec2)
    d = sqrt( (vec2(1)-vec1(1))^2 + (vec2(2)-vec1(2))^2 + (vec2(3)-vec1(3))^2 );

