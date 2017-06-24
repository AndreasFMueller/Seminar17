% 
%  geodesic.m -- compute geodesics
% 
%  (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
%  Adaptet in Matlab by Sascha Jecklin, Hochschule Rapperswil
% 
% 
% 
%  All vectors in this file follow the same convention. The first n components
%  describe the position, the next n components are the velocity. For the
%  geodesics on a sphere, the vector contains the following components
% 
%     [     theta     ]
%     [      phi      ]
%     [ d theta / d s ]
%     [  d phi / d s  ]
% 
% 
% 
%  This programm needs the functions metrik and christoffel to be
%  defined, a sample can be found in the file christoffel.m, you
%  would usually do this by including christoffel.m or your own version
%  with your particular from a driver file
% 
% 
% 
%  functions to compute position an velocity from a vectory that contains
%  both parts


% 
%  compute the geodesic
% 
function [ solution ] = geodesic( x0,s )
%s = s(:);

[T,Y]=ode45(@dgeodesic,s,x0);
sol=ode45(@dgeodesic,s,x0);
sol.stats                       %dispalys failed integration steps

solution = [T Y];

end









