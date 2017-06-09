function [ solution ] = geodesic( x0,s )
    [T,Y]=ode45(@dgeodesic,s,x0);
    sol=ode45(@dgeodesic,s,x0);
    sol.stats
    solution = [T Y];
end









