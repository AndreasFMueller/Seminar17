function [ ds2 ] = kerr_metrik( x,u,v )
% 	# compute the scalar product of the two vectors at position x
% 	# as an example, take the metric on the sphere

global rg;
	% position
% 	r = x(2,1)
%     a= 2;
% 	theta = x(3,1);

syms r;
syms a;
syms theta;

   
    rho_quad= r^2+a^2*cos(theta)^2;
    z=2*r/rho_quad;
    delta = r^2-rg*r+a^2;
    sigma_quad= (r^2+a^2)^2-a^2*delta*sin(theta)^2;
    omega= sqrt(sigma_quad)/sqrt(rho_quad)*sin(theta);
 
    
	g00 = z-1;
	g01 = -z*a*sin(theta)^2;
	g02 = z;
    g10 = -z*a*sin(theta)^2;
    g11 = omega^2;
    g12 = -a*(1+z)*sin(theta)^2;
    g20 = z;
    g21 = -a*(1+z)*sin(theta)^2;
    g22 = 1+z;
	g33 = rho_quad;
    
    g=zeros(4,4);
  	g(1,1) = g00;
	g(1,2) = g01;
	g(1,3) = g02;
    g(2,1) = g10;
    g(2,2) = g11;
    g(2,3) = g12;
    g(3,1) = g20;
    g(3,2) = g21;
    g(3,3) = g22;
	g(4,4) = g33;
    
    ds2 = u'*g*v;

end

