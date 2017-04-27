function [ Gamma ] = christoffel( x, alpha )

	global rg;
	n = size(x,1);
	Gamma = zeros(n,n);

	r = x(2,1);
	theta = x(3,1);

	q = rg / r;
	s = 1 - q;

	switch (alpha)
	case 1
		Gamma(1,2) = (1/s) * q * 1/(2*r);
		Gamma(2,1) = Gamma(1,2);
	case 2
		Gamma(1,1) = s * q * 1/(2*r);
		Gamma(2,2) = -(1/s) * q * 1/(2*r);
		Gamma(3,3) = rg - r;
		Gamma(4,4) = (rg - r) * sin(theta)^2;
	case 3
		Gamma(2,3) = 1/r;
		Gamma(3,2) = Gamma(2,3);
		Gamma(4,4) = -cos(theta) * sin(theta);
	case 4
		Gamma(2,4) = 1/r;
		Gamma(4,2) = Gamma(2,4);
		Gamma(3,4) = cot(theta);
		Gamma(4,3) = Gamma(3,4);
	otherwise
    end


end
