function patient_plots()
%PATIENT_PLOTS Summary of this function goes here
%   Detailed explanation goes here

% COMPARISON PLOTS
% PRIMARY ERROR
% 
colz = [1 1 1 1 1 1 1 1 1 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 2 2 2 2 2 2 2 2];
valz = [1.132 1.351 1.637 1.159 1.578 0.901 1.421 1.319 1.101 1.309 1.037 1.411 1.226 2.160 1.222 2.077 2.878 1.005 0.972 1.077 1.417 1.957 1.022 1.906 3.619];
p1 = [1.309	1.005];
p2 = [1.037	0.972];
p3 = [1.411	1.077];
p4 = [1.226	1.417];
p5 = [2.160	1.957];
p6 = [1.222	1.022];
p7 = [2.077	1.906];
p8 = [2.878	3.619];
col2 = [1.5 2];

figure('Name','No break trials primary error','NumberTitle','off')
plot(colz,valz,'.k','MarkerSize',25);
hold all
plot(col2,p1,'k')
plot(col2,p2,'k')
plot(col2,p3,'k')
plot(col2,p4,'k')
plot(col2,p5,'r')
plot(col2,p6,'k')
plot(col2,p7,'g')
plot(col2,p8,'b')
axis([.5,2.5,.0,4])

% % PRIMARY GAIN

colz = [1 1 1 1 1 1 1 1 1 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 2 2 2 2 2 2 2 2];
valz = [0.970 0.970 0.903 0.942 0.967 0.990 0.920 0.968 0.992 1.053 0.996 0.982 0.923 0.803 0.924 0.835 0.739 1.042 1.006 0.955 1.010 0.887 0.976 0.883 0.654]

p1 = [1.053	1.042];
p2 = [0.996	1.006];
p3 = [0.982	0.955];
p4 = [0.923	1.010];
p5 = [0.803	0.887];
p6 = [0.924	0.976];
p7 = [0.835	0.883];
p8 = [0.739	0.654];
col2 = [1.5 2];

figure('Name','No break trials primary gain','NumberTitle','off')
plot(colz,valz,'.k','MarkerSize',25);
hold all
plot(col2,p1,'k')
plot(col2,p2,'k')
plot(col2,p3,'k')
plot(col2,p4,'k')
plot(col2,p5,'r')
plot(col2,p6,'k')
plot(col2,p7,'g')
plot(col2,p8,'b')
axis([.5,2.5,.5,1.1]) 

% % FINAL ERROR
% 
colz = [1 1 1 1 1 1 1 1 1 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 2 2 2 2 2 2 2 2];
valz = [0.880 1.034 1.204 0.910 1.464 0.688 1.058 1.214 1.017 0.487 0.856 0.619 1.067 1.000 1.178 1.698 1.962 0.365 0.712 0.662 1.302 1.008 0.803 1.453 1.875];

p1 = [0.487 0.365];
p2 = [0.856 0.712];
p3 = [0.619 0.662];
p4 = [1.067 1.302];
p5 = [1.000 1.008];
p6 = [1.178 0.803];
p7 = [1.698 1.453];
p8 = [1.962 1.875];
col2 = [1.5 2];

figure('Name','No break trials final error','NumberTitle','off')
plot(colz,valz,'.k','MarkerSize',25);
hold all
plot(col2,p1,'k')
plot(col2,p2,'k')
plot(col2,p3,'k')
plot(col2,p4,'k')
plot(col2,p5,'r')
plot(col2,p6,'k')
plot(col2,p7,'g')
plot(col2,p8,'b')
axis([.5,2.5,.0,4])

% % Final GAIN

colz = [1 1 1 1 1 1 1 1 1 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 2 2 2 2 2 2 2 2];
valz = [0.980 1.001 0.986 0.966 0.978 1.009 0.978 0.954 0.952 1.002 0.980 0.981 0.953 0.997 0.925 0.887 0.849 1.013 1.006 1.003 1.027 1.000 0.989 0.924 0.846];

p1 = [1.002 1.013];
p2 = [0.980 1.006];
p3 = [0.981 1.003];
p4 = [0.953 1.027];
p5 = [0.997 1.000];
p6 = [0.925 0.989];
p7 = [0.887 0.924];
p8 = [0.849 0.846];
col2 = [1.5 2];

figure('Name','No break trials final gain','NumberTitle','off')
plot(colz,valz,'.k','MarkerSize',25);
hold all
plot(col2,p1,'k')
plot(col2,p2,'k')
plot(col2,p3,'k')
plot(col2,p4,'k')
plot(col2,p5,'r')
plot(col2,p6,'k')
plot(col2,p7,'g')
plot(col2,p8,'b')
axis([.5,2.5,.5,1.1]) 
end

