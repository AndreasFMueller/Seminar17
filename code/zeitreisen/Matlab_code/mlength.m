% 
%  find the length of a vector
%

function [ l ] = mlength( x )
	l = sqrt(abs(metrik(position(x), velocity(x), velocity(x))));
    l
end

