//
// pseudosphaere.inc
//
// (c) 2017 Prof Dr Andreas Mueller, Hochschule Rapperswil
//

#declare sech = function(l) { 1 / cosh(l) }

#macro pseudosphaere(uu, vv)
	<sech(uu) * cos(vv), uu - tanh(uu), sech(uu) * sin(vv)>
#end

#declare U = 3.5;
#declare Ustep = 0.01;
#while (U > Ustep)
	#declare V = 0;
	#declare Vstep = pi / 100;
	#while (V < 2 * pi - Vstep/2)
		triangle {
			pseudosphaere(U        , V),
			pseudosphaere(U + Ustep, V),
			pseudosphaere(U + Ustep, V + Vstep)
		}
		triangle {
			pseudosphaere(U        , V),
			pseudosphaere(U + Ustep, V + Vstep),
			pseudosphaere(U        , V + Vstep)
		}

		#declare V = V + Vstep;
	#end
	#declare U = U - Ustep;
#end
