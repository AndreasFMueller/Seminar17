
x0 = zeros(8,1);
x0(1,1) = 0;      %time
x0(2,1) = 20;       %rg
x0(3,1) = pi/2;     %theta
x0(4,1) = 0;        %phi
x0(5,1) = 0.5;
x0(6,1) = 0;
x0(7,1) = 0;
x0(8,1) = 0.0004;   %velocity

	global rg;
	n = size(x,1);
	Gamma = zeros(n,n);
    t = s;
    alpha = 1;
    x = position(x0);
	r = x(2,1);
	theta = x(3,1);
    
    g=  [-1+rg/r,          0,   0,                  0 ;
    0, 1/(1-rg/r),   0,                  0 ;
    0,          0, r^2,                  0 ;
    0,          0,   0, r^2 * sin(theta)^2 ];
x= [t, r, theta, phi];



% /*
%  * Metrik und verwendete Koordinaten muessen bereits definiert sein,
%  * zum Beispiel wie hier fuer die Kugel:
%  *
%  * g: matrix( [1, 0], [0, sin(theta)^2] );
%  * x: [theta,phi];
%  */
%
% /*
%  * Inverse der Metrik (zum Hochziehen von Indizes)
%  */
ginverse = inv(g);

% /*
%  * Christoffel-Symbole erster Art
%  *
%  * \Gamma_{\alpha,\mu\nu}
%  */

simplify(Riemann2(1,2,1,2));
simplify(Riemann2(1,3,1,3));
simplify(Riemann2(1,4,1,4));

simplify(Riemann2(2,3,2,3));
simplify(Riemann2(2,4,2,4));

simplify(Riemann2(3,4,3,4));

simplify(Einstein(1,1));
simplify(Einstein(1,2));
simplify(Einstein(1,3));
simplify(Einstein(1,4));
simplify(Einstein(2,2));
simplify(Einstein(2,3));
simplify(Einstein(2,4));
simplify(Einstein(3,3));
simplify(Einstein(3,4));
simplify(Einstein(4,4));


function  christoffel1 = Christoffel1(alpha,mu,nu) 
christoffel1 = 0.5*(diff(g(nu,alpha), x(mu)) + diff(g(mu,alpha), x(nu))- diff(g(mu,nu), x(alpha)));
end

% /*
%  * Christoffelsymbole zweiter Art
%  *
%  * Gamma_{mu,nu}^\sigma
%  */
function christffel2 = Christoffel2(sigma,mu,nu)
christoffel2 = sum(ginverse(sigma,i) * Christoffel1(i,mu,nu), i, 1, length(g));
end

% /*
%  * Riemann-Tensor
%  *
%  * R^\alpha_\mu\rho\sigma
%  */
function rt1 = Riemann(alpha,mu,rho,sigma) 
rt = diff(Christoffel2(alpha,mu,sigma), x(rho)) -diff(Christoffel2(alpha,mu,rho), x(sigma))+sum(Christoffel2(i,mu,sigma)*Christoffel2(alpha,i,rho), i, 1, length(g))
-sum(Christoffel2(i1,mu,rho)*Christoffel2(alpha,i1,sigma), i1, 1, length(g));
end

% /*
%  * kovarianter Riemann-Tensor
%  *
%  * R_\alpha\mu\rho\sigma
%  */
function rt2 = Riemann2(alpha,mu,rho,sigma)

rt2 = symsum((g(alpha,i1) * Riemann(i1,mu,rho,sigma)), i1, 1, length(g));
end
%
% /*
%  * Ricci Tensor
%  *
%  * R_\alpha\beta
%  */
function ricci = Ricci(alpha, beta) 
ricci = sum(Riemann(i1, alpha, i1, beta), i1, 1, length(g));
end

% /*
%  * Kruemmungsskalar R
%  */
function rs = RicciScalar() 
rs =sum(sum(ginverse(i1, j1) * Ricci(i1, j1), i1, 1, length(g)),j1, 1, length(g));
end
% /*
%  * Einstein-Tensor
%  *
%  * G_\alpha\beta = R_\alpha\beta - 1/2 g_\mu\nu R
%  */

function einstein = Einstein(alpha,beta)
einstein = Ricci(alpha,beta) - 1/2 * RicciScalar() * g(alpha, beta);
end




