function ii_statsMGS(aX,aY,s,h,v)
%II_STATSMGS Summary of this function goes here
%   Detailed explanation goes here

% SPLIT xACC/yACC
[pX,fX,tX,pY,fY,tY] = ii_splitacc(aX,aY);

% CALC zACC/ERROR
[eX,eY,eZ,tZ,sZ,gZ,theta] = ii_calcerror(tX,fX,tY,fY);

% CALC TOTAL ACC
% THROW OUT INVALID
vZ = ii_fvalid(v,eZ);
vX = ii_fvalid(v,eX);
vY = ii_fvalid(v,eY);

% CALC TOTAL SRT
% THROW OUT INVALID
vSRT = ii_fvalid(v,s);

% CALC ACC BY HEMI
[rZ,lZ] = ii_cuthemi(h,v,eZ);
[rX,lX] = ii_cuthemi(h,v,eX);
[rY,lY] = ii_cuthemi(h,v,eY);

% CALC SRT BY HEMI
[rZ,lZ] = ii_cuthemi(h,v,eZ);
[rX,lX] = ii_cuthemi(h,v,eX);
[rY,lY] = ii_cuthemi(h,v,eY);

% CALC SRT BY HEMI
[rSRT,lSRT] = ii_cuthemi(h,v,s);

putvar(pX,fX,tX,pY,fY,tY,eX,eY,eZ,vZ,vX,vY,vSRT,rZ,lZ,rX,lX,rY,lY,rSRT,lSRT,tZ,sZ,gZ,theta);

% SIGNIFICANCE ANALYSIS
[sigX,pvalX] = ttest2(lX,rX);
[sigY,pvalY] = ttest2(lY,rY);
[sigZ,pvalZ] = ttest2(lZ,rZ);
[sigSRT,pvalSRT] = ttest2(lSRT,rSRT);

putvar(sigX,pvalX,sigY,pvalY,sigZ,pvalZ,sigSRT,pvalSRT);

% MAKE FIGURES
figure('Name','X vs Y ERROR','NumberTitle','off')

x = linspace(-5,5);
y = linspace(-5,5);

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
pol = plot(x,y);
set(pol, 'Color', 'k', 'LineStyle', '--')
% plot(abs(vX),abs(vY),'ro');
plot(vX,vY,'ro');
axis tight;
axis equal;

% Create figure
figure('Name','Right Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(rX,rY, 'ro');
plotv([rX, rY]','--')

% Create figure
figure('Name','Left Hemifield','NumberTitle','off')

% Plot axes lines
xax = plot ([-5 5],[0 0]);
set(xax, 'Color', 'k', 'LineStyle', '--')
hold on
yax = plot ([0 0],[-5 5]);
set(yax, 'Color', 'k', 'LineStyle', '--')
axis tight;
axis equal;

% Plot results
plot(lX, lY, 'ro');
plotv([lX, lY]','--')

% % Create Total Vectors
% cSRT = [cSRT;rSRT];
% cX = [cX;rX];
% cY = [cY;rY];
% cZ = [cZ;rZ];
%
% iSRT = [iSRT;rSRT];
% iX = [iX;rX];
% iY = [iY;rY];
% iZ = [iZ;rZ];
%
% cSRT = [cSRT;lSRT];
% cX = [cX;lX];
% cY = [cY;lY];
% cZ = [cZ;lZ];
%
% iSRT = [iSRT;lSRT];
% iX = [iX;lX];
% iY = [iY;lY];
% iZ = [iZ;lZ];
%
% % SIGNIFICANCE ANALYSIS l = c; r = i
% [sigX,pvalX] = ttest2(cX,iX);
% [sigY,pvalY] = ttest2(cY,iY);
% [sigZ,pvalZ] = ttest2(cZ,iZ);
% [sigSRT,pvalSRT] = ttest2(cSRT,iSRT);
%
% vX = [cX;iX];
% vY = [cY;iY];
%
% % MAKE FIGURES
% figure('Name','X vs Y ERROR','NumberTitle','off')
%
% x = linspace(-5,5);
% y = linspace(-5,5);
%
% % Plot axes lines
% xax = plot ([-5 5],[0 0]);
% set(xax, 'Color', 'k', 'LineStyle', '--')
% hold on
% yax = plot ([0 0],[-5 5]);
% set(yax, 'Color', 'k', 'LineStyle', '--')
% pol = plot(x,y);
% set(pol, 'Color', 'k', 'LineStyle', '--')
% % plot(abs(vX),abs(vY),'ro');
% plot(vX,vY,'bo');
% axis tight;
% axis equal;
%
% % Create figure
% figure('Name','Ipsilateral Hemifield','NumberTitle','off')
%
% % Plot axes lines
% xax = plot ([-5 5],[0 0]);
% set(xax, 'Color', 'k', 'LineStyle', '--')
% hold on
% yax = plot ([0 0],[-5 5]);
% set(yax, 'Color', 'k', 'LineStyle', '--')
% axis tight;
% axis equal;
%
% % Plot results
% plot(iX,iY, 'ko');
% % plotv([iX, iY]','--')
%
% % Create figure
% figure('Name','Contralateral Hemifield','NumberTitle','off')
%
% % Plot axes lines
% xax = plot ([-5 5],[0 0]);
% set(xax, 'Color', 'k', 'LineStyle', '--')
% hold on
% yax = plot ([0 0],[-5 5]);
% set(yax, 'Color', 'k', 'LineStyle', '--')
% axis tight;
% axis equal;
%
% % Plot results
% plot(cX, cY, 'ko');
% % plotv([cX, cY]','--')
% end

