function [ y ] = mrescale( x,s )
    y = x;
    n = size(x,1)/2;
    y((n+1):(2*n),1) = s * velocity(x);
end