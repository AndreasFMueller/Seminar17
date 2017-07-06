% 
%  functions to compute position from a vectory that contains
%  both parts
% 

function [ pos ] = position( x )
    n = floor(size(x,1)/2);    %size(x) should always be even
    pos = x(1:n,1);
end