% 
%  advane along a geodesic for a parameter difference s
%

function [ x ] = geodesic_advance(x,step)
    s = step * (0:1);
    solution = geodesic(x, s);
    n = size(x,1);
    x = solution(2,2:(n+1))';
end

