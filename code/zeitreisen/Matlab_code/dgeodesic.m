% 
% compute the derivative for the geodesic equation
%

function [ y ] = dgeodesic( s,x )
    n = floor(size(x,1)/2);    %size(x) should be even anyway
    y = zeros(2*n,1);
    p = position(x);
    u = velocity(x);
    y(1:n,1) = u;

    for alpha = 1:n
        Gamma = christoffel(p, alpha);
        y(n+alpha,1) = -u' * Gamma * u;
    end

end

