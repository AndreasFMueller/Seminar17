function [ y ] = mnormalize( x )
    y = mrescale(x, 1 / mlength(x));
end
