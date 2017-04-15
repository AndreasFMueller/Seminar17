function pos = position(x)
        n = size(x)(1)/2;
        pos = x(1:n,1);
endfunction

function vel = velocity(x)
        n = size(x)(1)/2;
        vel = x((n+1):(2*n),1);
endfunction

