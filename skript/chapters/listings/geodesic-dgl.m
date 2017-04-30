function y = dgeodesic(x, s)
        n = size(x)(1)/2;
        y = zeros(2*n, 1);
        p = position(x);
        u = velocity(x);
        y(1:n,1) = u;
        for alpha = 1:n
                Gamma = christoffel(p, alpha);
                y(n+alpha,1) = -u' * Gamma * u;
        endfor
endfunction
