% 
%  functions to compute velocity from a vectory that contains
%  both parts
% 

function [ vel ] = velocity( x )
n = floor(size(x,1)/2);    %size(x) should always be even
vel = x((n+1):(2*n),1);
end