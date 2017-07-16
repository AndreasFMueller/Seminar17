%
% Beispiel 1
%

K = 6.67e-11;
M = 1.99e30;
c = 2.99e8;

rStart = (2*K*M)/(c^2);
rEnd = (2*K*M)/(0.05*c^2);

(2*K*M) / (rStart*c^2);
(2*K*M) / (rEnd  *c^2);

rDelta = rStart:2000:rEnd;
x = zeros(1,size(rDelta,2));
for i=1:size(rDelta,2)
  x(i) = (2*K*M) / (rDelta(i)*c^2);
endfor

plot(rDelta, x);

xx(1,:) = rDelta;
xx(2,:) = x;
csvwrite('bsp1.csv', xx');