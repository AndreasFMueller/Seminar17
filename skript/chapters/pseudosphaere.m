#
# pseudosphaere.m -- christoffel function for pseudosphere
#
# This file contains a generic christoffel symbol function which
# can be used by the geodesic.m program to compute geodesics
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

function ds2 = metrik(x, u, v)
	# compute the scalar product of the two vectors at position x
	# as an example, take the metric on the pseudosphere
        #              [     4          2              ]
        #              [ sinh (u) + sinh (u)           ]
        #              [ -------------------     0     ]
        #              [          4                    ]
        #              [      cosh (u)                 ]
        #              [                               ]
        #              [                         1     ]
        #              [          0           -------- ]
        #              [                          2    ]
        #              [                      cosh (u) ]

	theta = x(1,1);
	ds2 = u(1,1) * v(1,1) * sinh(theta)^2;
	ds2 = ds2 + u(2,1) * v(2,1);
	ds2 = ds2 / cosh(theta)^2;
endfunction

#
# The christoffel function computes the value of the
# christoffel-symbol \Gamma^\alpha_{\mu\nu} at position x
# the return value is a nxn matrix with indizes \mu\nu
#
# the example provided gives christoffel symbols for the
# metric on a sphere
#
function Gamma = christoffel(x, alpha)
	theta = x(1,1);
	n = size(x)(1);
	Gamma = zeros(n,n);
	switch (alpha)
	case 1
                #       trigsimp(Christoffel2(1, 1, 1))
                #                      1
                #               ---------------
                #               cosh(u) sinh(u)
                #       trigsimp(Christoffel2(1, 1, 2))
                #                      0
                #       trigsimp(Christoffel2(1, 2, 1))
                #                      0
                #       trigsimp(Christoffel2(1, 2, 2))
                #                  cosh(u)
                #             ------------------
                #                 3
                #             sinh (u) + sinh(u)
		Gamma(1,1) = 1/(cosh(theta) * sinh(theta));
		Gamma(2,2) = Gamma(1,1);
	case 2
                #       trigsimp(Christoffel2(2, 1, 1))
                #                      0
                #       trigsimp(Christoffel2(2, 1, 2))
                #                    sinh(u)
                #                  - -------
                #                    cosh(u)
                #       trigsimp(Christoffel2(2, 2, 1))
                #                    sinh(u)
                #                  - -------
                #                    cosh(u)
                #       trigsimp(Christoffel2(2, 2, 2))
                #                      0
		Gamma(1,2) = -tanh(theta);
		Gamma(2,1) = Gamma(1,2);
	otherwise
	endswitch
endfunction


