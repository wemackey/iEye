
load('/deathstar/home/wayne/Dropbox/PatientsMGS/Patient_15/ii_stats.mat')
delvec = [];

for r = 1:10;   
    load(['/deathstar/home/wayne/Dropbox/PatientsMGS/Patient_15/DATA_Processed/mgs_' num2str(r) '.mat'])
    
    dp = zeros(30,1);
    
    ii_selectbyvalue('XDAT',1,3);
    dels = ii_cfg.cursel(:,2) - ii_cfg.cursel(:,1)
    % dels = dels/2;
    
    b1 = find(dels<=3400);
    b2 = find(dels>3400 & dels<=3900);
    b3 = find(dels>3900 & dels<=4400);
    b4 = find(dels>4400 & dels<=4900);
    b5 = find(dels>=4900);
    
    dp(b1) = 3;
    dp(b2) = 3.5;
    dp(b3) = 4;
    dp(b4) = 4.5;
    dp(b5) = 5;
    
    ii_stats(r).dp = dp;
    delvec = [delvec; dp];
end

figure;
hist(delvec,5);