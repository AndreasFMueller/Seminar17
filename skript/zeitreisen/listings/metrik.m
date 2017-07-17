function [ ds2 ] = metrik( x,u,v )
    global rg;
    r = x(2,1)
    theta = x(3,1);

    q = rg / r;
    s = 1 - q;

    g=zeros(4,4);
    g(1,1) = -s;
    g(2,2) = 1/s;
    g(3,3) = r^2;
    g(4,4) = r^2 * sin(theta)^2;

    ds2 = u'*g*v;
end
