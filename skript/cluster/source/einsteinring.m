
%% Einsteinring

pkg load odepkg
pkg load parallel

close all
clear

c = 299792458;         % Lichtgeschwindigkeit
ly = 9460730472580800; % Lichtjahr
zc = 149.6e9;          % Abstand Sonne-Erde ~150e6km
K = 6.67408e-11;       % Gravitationskonstante
Msun = 1.99e30;        % Sonnenmasse

Rsun = 696.342e6;      % Sonnenradius ~700e3km

M = 1000*Msun;         % Linsenmasse

delta = 10e6;          % Pixelabstand auf Linsenhoehe
imageX = 150;          % image height*2
imageY = imageX;       % image width*2

global arrR = zeros(imageX*2+1, imageY*2+1);
% Blickwinkel array befuellen
for ix = 0:(imageX)
  for iy = 0:ix
    arrR(imageX+ix+1,imageY+iy+1) = sqrt((ix*delta)^2+(iy*delta)^2+zc^2); % Laenge bis Linsenebene
    % verwenden der Symmetrie
    arrR(imageX-ix+1,imageY+iy+1) = arrR(imageX+ix+1,imageY+iy+1);
    arrR(imageX+ix+1,imageY-iy+1) = arrR(imageX+ix+1,imageY+iy+1);
    arrR(imageX-ix+1,imageY-iy+1) = arrR(imageX+ix+1,imageY+iy+1);
    arrR(imageY+iy+1,imageX+ix+1) = arrR(imageX+ix+1,imageY+iy+1);
    arrR(imageY+iy+1,imageX-ix+1) = arrR(imageX+ix+1,imageY+iy+1);
    arrR(imageY-iy+1,imageX+ix+1) = arrR(imageX+ix+1,imageY+iy+1);
    arrR(imageY-iy+1,imageX-ix+1) = arrR(imageX+ix+1,imageY+iy+1);
  endfor
endfor
imagesc(arrR);
figure
imshow(arrR/max(arrR(:))*255);


% Wo befindet sich die Sonne im Bild
global img = ones(imageX*2+1, imageY*2+1);
for ix = 0:(imageX)
  for iy = 0:ix
    if ( (sqrt(ix^2+iy^2)*delta) <= Rsun)
      img(imageX+ix+1,imageY+iy+1) = 0;
      % verwenden der Symmetrie
      img(imageX-ix+1,imageY+iy+1) = img(imageX+ix+1,imageY+iy+1);
      img(imageX+ix+1,imageY-iy+1) = img(imageX+ix+1,imageY+iy+1);
      img(imageX-ix+1,imageY-iy+1) = img(imageX+ix+1,imageY+iy+1);
      img(imageY+iy+1,imageX+ix+1) = img(imageX+ix+1,imageY+iy+1);
      img(imageY+iy+1,imageX-ix+1) = img(imageX+ix+1,imageY+iy+1);
      img(imageY-iy+1,imageX+ix+1) = img(imageX+ix+1,imageY+iy+1);
      img(imageY-iy+1,imageX-ix+1) = img(imageX+ix+1,imageY+iy+1);
    endif
  endfor
endfor

figure
imshow(img);
figure
imagesc(img);


% Geradengleichung in Parameterform
p = zeros(imageX*2+1, imageY*2+1, 3);
u = zeros(imageX*2+1, imageY*2+1, 3);

% nicht berechenen, wenn bereits berechnet
if not( and(exist("einsteinringP.mat"), exist("einsteinringU.mat")) )

% Lichtweg Funktion
function [pPart, uPart] = pixelPath (ix, iy, imageX, imageY, zc, delta, K, M, c)
  diffSy = @(l,x) [x(2);
                   (4*x(2)*x(6)*(x(5)-zc)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2))-(2*x(1)*(x(6)^2+x(4)^2-x(2)^2)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2))+(4*x(2)*x(3)*x(4)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2));
                   x(4);
                   (4*x(4)*x(6)*(x(5)-zc)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2))-(2*x(3)*(x(6)^2-x(4)^2+x(2)^2)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2))+(4*x(1)*x(2)*x(4)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2));
                   x(6);
                   (-(2*((-x(6)^2)+x(4)^2+x(2)^2)*(x(5)-zc)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2)))+(4*x(3)*x(4)*x(6)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2))+(4*x(1)*x(2)*x(6)*K*M)/(c^2*(x(1)^2+x(3)^2+(x(5)-zc)^2)^(3/2))];

  global img;
  global arrR;
  if img(imageX+ix+1,imageY+iy+1) == 1
    [l,y] = ode23s (diffSy, [0,2*zc], [0, ((ix)*delta)/arrR(imageX+ix+1,imageY+iy+1),...
                                       0, ((iy)*delta)/arrR(imageX+ix+1,imageY+iy+1),...
                                       0, (zc/arrR(imageX+ix+1,imageY+iy+1))] );

    pPart(1, 1,:) = [y(end-2,1), y(end-2,3), y(end-2,5)];
    uPart(1, 1,:) = [y(end,1)-y(end-2,1), y(end,3)-y(end-2,3), y(end,5)-y(end-2,5)];
  else
    pPart(1, 1,:) = [0, 0, 0];
    uPart(1, 1,:) = [0, 0, 0];
  endif
endfunction

for ix = 101:(imageX)
  ix
  warning('off','all');
  % paralleler Funktionsaufruf
  [pPart, uPart] = pararrayfun(nproc, @pixelPath, ix, 0:ix, imageX, imageY, zc, delta, K, M, c);
  warning('on','all');
  
  % einsetzen der berechneten Werte in das Grosse Ganze
  p(imageX+1+ix, imageY+1:imageY+1+ix, :) = pPart;
  u(imageX+1+ix, imageY+1:imageY+1+ix, :) = uPart;
endfor

save einsteinringP.mat p
save einsteinringU.mat u

else

load einsteinringP.mat;
load einsteinringU.mat;

endif

% Background Bild laden
background = imread("../images/m31_comolli_2193.jpg");
imshow(background);
backX = round(size(background,1)/2); % Background Zentrum
backY = round(size(background,2)/2);

zBack = 5.8*zc;      % Hintergrundbild Position
deltaBack = delta/1; % Pixelgrösse

imgFinish = zeros(imageX*2+1, imageY*2+1, 3);
for ix = 0:(imageX)
  for iy = 0:ix
    if (img(imageX+ix+1,imageY+iy+1) == 1)
      % Schnittpunkt mit Hintergrundbild berechnen
      sTemp = ( zBack-p(imageX+1+ix, imageY+1+iy,3) ) / u(imageX+1+ix, imageY+1+iy,3);
      xBackTemp = p(imageX+1+ix, imageY+1+iy,1) + sTemp*u(imageX+1+ix, imageY+1+iy,1);
      yBackTemp = p(imageX+1+ix, imageY+1+iy,2) + sTemp*u(imageX+1+ix, imageY+1+iy,2);
      
      xBackTemp = round( xBackTemp/deltaBack );
      yBackTemp = round( yBackTemp/deltaBack );
      
      imgFinish(imageX+ix+1,imageY+iy+1,:) = background(backX+xBackTemp,backY+yBackTemp,:);
      % verwenden der Symmetrie
      imgFinish(imageX-ix+1,imageY+iy+1,:) = background(backX-xBackTemp,backY+yBackTemp,:);
      imgFinish(imageX+ix+1,imageY-iy+1,:) = background(backX+xBackTemp,backY-yBackTemp,:);
      imgFinish(imageX-ix+1,imageY-iy+1,:) = background(backX-xBackTemp,backY-yBackTemp,:);
      imgFinish(imageY+iy+1,imageX+ix+1,:) = background(backX+yBackTemp,backY+xBackTemp,:);
      imgFinish(imageY+iy+1,imageX-ix+1,:) = background(backX+yBackTemp,backY-xBackTemp,:);
      imgFinish(imageY-iy+1,imageX+ix+1,:) = background(backX-yBackTemp,backY+xBackTemp,:);
      imgFinish(imageY-iy+1,imageX-ix+1,:) = background(backX-yBackTemp,backY-xBackTemp,:);
    endif
  endfor
endfor

figure
imshow(uint8(imgFinish));

imwrite(uint8(imgFinish), "../images/einsteinring.jpg");