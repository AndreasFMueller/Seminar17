function ds2 = metrik(x, u, v)
        global rg;
        # position
        r = x(2,1)
        theta = x(3,1);

        q = rg / r;
        s = 1 - q;

        g00 = -s;
        g11 = 1/s;
        g22 = r^2;
        g33 = r^2 * sin(theta)^2;

        ds2 = g00 * u(1,1) * v(1,1);
        ds2 = ds2 + g11 * u(2,1) * v(2,1);
        ds2 = ds2 + g22 * u(3,1) * v(3,1);
        ds2 = ds2 + g33 * u(4,1) * v(4,1);
endfunction
