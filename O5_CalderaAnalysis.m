% Caldera Analysis
%plot caldera diameter/volume, test effects of r and C, get onset of collapse and critical volume fractions
clc; clear all; close all;
%% load morphology data tables from processing step 03
exp1_morph_data = load('exp1_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp2_morph_data = load('exp2_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp3_morph_data = load('exp3_repeat_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp4_morph_data = load('exp4_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp5_morph_data = load('exp5_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp6_morph_data = load('exp6_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp7_morph_data = load('exp7_repeat_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp8_morph_data = load('exp8_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp9_morph_data = load('exp9_output_reprocessed/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp10_morph_data = load('exp10_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp11_morph_data = load('exp11_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp12_morph_data = load('exp12_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp13_morph_data = load('exp13_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp14_morph_data = load('exp14_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp15_morph_data = load('exp15_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp16_morph_data = load('exp16_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');
exp17_morph_data = load('exp17_output/MATLAB output/14.Analysis plots/CalderaData/CalderaData.mat');

%% extract relevant variables
%experiment parameters
%vector elements correspond to experiments 1-17:
D=[4; 6.5; 10; 6.5; 10; 4; 6.5; 4; 10; 10; 4; 4; 10; 4; 6.5; 4; 6.5]; %diameter of silicone reservoir [cm]
H= [3.5; 3.5; 3.5; 2; 2; 2; 8; 8; 10; 6; 12; 8; 2; 2; 6.5; 12; 10]; %depth of silicone reservoir top [cm]
C=[66; 66; 66; 66; 66; 66; 66; 66; 66; 66; 66; 91; 91; 91; 91; 91; 91 ]; %cohesion of granular material [Pa] 
r=H./D; %roof aspect ratio
rho_sil=1000;  %kg/m3
rho_GB=1500;
rho_mix=1400;
g=9.81;
% define runtime
runtime=exp7_morph_data.CalderaData.runtime;   %not all experiments have the same duration 
runtime14=[[0:1:17]';[19:1:23]';25;27;29;30;35;40;[50:5:110]';120;130;[140:5:180]'];

%caldera diameter
diam1=exp1_morph_data.CalderaData.caldera_diameter_cm;
diam2=exp2_morph_data.CalderaData.caldera_diameter_cm;
diam3=exp3_morph_data.CalderaData.caldera_diameter_cm;
diam4=exp4_morph_data.CalderaData.caldera_diameter_cm;
diam5=exp5_morph_data.CalderaData.caldera_diameter_cm;
diam6=exp6_morph_data.CalderaData.caldera_diameter_cm;
diam7=exp7_morph_data.CalderaData.caldera_diameter_cm;
diam8=exp8_morph_data.CalderaData.caldera_diameter_cm;
diam9=exp9_morph_data.CalderaData.caldera_diameter_cm;
diam10=exp10_morph_data.CalderaData.caldera_diameter_cm;
diam11=exp11_morph_data.CalderaData.caldera_diameter_cm;
diam12=exp12_morph_data.CalderaData.caldera_diameter_cm;
diam13=exp13_morph_data.CalderaData.caldera_diameter_cm; 
diam14=exp14_morph_data.CalderaData.caldera_diameter_cm;
diam15=exp15_morph_data.CalderaData.caldera_diameter_cm;
diam16=exp16_morph_data.CalderaData.caldera_diameter_cm;
diam17=exp17_morph_data.CalderaData.caldera_diameter_cm;

diam1(diam1==0)=NaN;
diam2(diam2==0)=NaN;
diam3(diam3==0)=NaN; 
diam4(diam4==0)=NaN;
diam5(diam5==0)=NaN;
diam6(diam6==0)=NaN;
diam7(diam7==0)=NaN;
diam8(diam8==0)=NaN;
diam9(diam9==0)=NaN; 
diam10(diam10==0)=NaN;
diam11(diam11==0)=NaN;
diam12(diam12==0)=NaN; 
diam13(diam13==0)=NaN;
diam14(diam14<=0.25)=NaN; 
diam15(diam15==0)=NaN;
diam16(diam16==0)=NaN; 
diam17(diam17==0)=NaN;

%maximum subsidence
subs1=exp1_morph_data.CalderaData.maxsub;
subs2=exp2_morph_data.CalderaData.maxsub;
subs3=exp3_morph_data.CalderaData.maxsub;
subs4=exp4_morph_data.CalderaData.maxsub;
subs5=exp5_morph_data.CalderaData.maxsub;
subs6=exp6_morph_data.CalderaData.maxsub;
subs7=exp7_morph_data.CalderaData.maxsub;
subs8=exp8_morph_data.CalderaData.maxsub;
subs9=exp9_morph_data.CalderaData.maxsub;
subs10=exp10_morph_data.CalderaData.maxsub;
subs11=exp11_morph_data.CalderaData.maxsub;
subs12=exp12_morph_data.CalderaData.maxsub;
subs13=exp13_morph_data.CalderaData.maxsub;
subs14=exp14_morph_data.CalderaData.maxsub;
subs15=exp15_morph_data.CalderaData.maxsub;
subs16=exp16_morph_data.CalderaData.maxsub;
subs17=exp17_morph_data.CalderaData.maxsub;

subs1(subs1==0)=NaN;
subs2(subs2==0)=NaN;
subs3(subs3==0)=NaN; 
subs4(subs4==0)=NaN;
subs5(subs5==0)=NaN;
subs6(subs6==0)=NaN;
subs7(subs7==0)=NaN;
subs8(subs8==0)=NaN;
subs9(subs9==0)=NaN; 
subs10(subs10==0)=NaN;
subs11(subs11==0)=NaN;
subs12(subs12==0)=NaN; 
subs13(subs13==0)=NaN;
subs14(subs14==0)=NaN; 
subs15(subs15==0)=NaN;
subs16(subs16==0)=NaN; 
subs17(subs17==0)=NaN;

%caldera volume
vol1=exp1_morph_data.CalderaData.caldera_volume_cm3;
vol2=exp2_morph_data.CalderaData.caldera_volume_cm3;
vol3=exp3_morph_data.CalderaData.caldera_volume_cm3;
vol4=exp4_morph_data.CalderaData.caldera_volume_cm3;
vol5=exp5_morph_data.CalderaData.caldera_volume_cm3;
vol6=exp6_morph_data.CalderaData.caldera_volume_cm3;
vol7=exp7_morph_data.CalderaData.caldera_volume_cm3;
vol8=exp8_morph_data.CalderaData.caldera_volume_cm3;
vol9=exp9_morph_data.CalderaData.caldera_volume_cm3;
vol10=exp10_morph_data.CalderaData.caldera_volume_cm3;
vol11=exp11_morph_data.CalderaData.caldera_volume_cm3;
vol12=exp12_morph_data.CalderaData.caldera_volume_cm3;
vol13=exp13_morph_data.CalderaData.caldera_volume_cm3;
vol14=exp14_morph_data.CalderaData.caldera_volume_cm3;
vol15=exp15_morph_data.CalderaData.caldera_volume_cm3;
vol16=exp16_morph_data.CalderaData.caldera_volume_cm3;
vol17=exp17_morph_data.CalderaData.caldera_volume_cm3;

vol1(vol1==0)=NaN;
vol2(vol2==0)=NaN;
vol3(vol3==0)=NaN;
vol4(vol4==0)=NaN;
vol5(vol5==0)=NaN;
vol6(vol6==0)=NaN;
vol7(vol7==0)=NaN;
vol8(vol8==0)=NaN;
vol9(vol9==0)=NaN; 
vol10(vol10==0)=NaN;
vol11(vol11==0)=NaN;
vol12(vol12==0)=NaN; 
vol13(vol13==0)=NaN;
vol14(vol14==0)=NaN; 
vol15(vol15==0)=NaN;
vol16(vol16==0)=NaN;  
vol17(vol17==0)=NaN;

%% Caldera volume over diameter 
%low cohesion
figure()
hold on
plot(runtime(1:61),vol5(1:61),'-s','MarkerSize',4,'LineWidth',1.7,'color',[89, 2, 39]./255)
plot(runtime(1:61),vol4,'-o','MarkerSize',3,'LineWidth',1.7,'color',[167, 13, 7]./255)
plot(runtime(1:61),vol3,'-s','MarkerSize',4,'LineWidth',1.9,'color',[182, 87, 44]./255) 
plot(runtime(1:61),vol6,'-x','MarkerSize',3,'LineWidth',2,'color',[224 90 0]./255)
plot(runtime(1:61),vol2,'-o','MarkerSize',3,'LineWidth',1.7,'color',[232, 197, 51]./255)
plot(runtime(1:61),vol10,'-s','MarkerSize',4,'LineWidth',1.7,'color',[178, 178, 149]./255)
plot(runtime(1:61),vol1,'-x','MarkerSize',5,'LineWidth',1.7,'color',[98, 108, 118]./255)  
plot(runtime(1:63),vol9,'-s','MarkerSize',4,'LineWidth',1.7,'color',[1 108 89]./255)
plot(runtime,vol7,'-o','MarkerSize',3,'LineWidth',1.7,'color',[24, 142, 150]./255)
plot(runtime(1:61),vol8,'-x','MarkerSize',5,'LineWidth',1.7,'color',[3 78 163]./255)
plot(runtime(1:61),vol11,'-x','MarkerSize',5,'LineWidth',1.7,'color',[0, 31, 97]./255)

legend('E5: r=0.2','E4: r=0.3','E3: r=0.35','E6: r=0.5','E2: r=0.54','E10: r=0.6', 'E1: r=0.88','E9: r=1','E7: r=1.23','E8: r=2','E11: r=3','Location','NorthWest','NumColumns',2);
ax=gca;
axis([0 20 0 370])
ax.XTick = 0:5:20;
ax.XMinorTick='on'; 
ax.XAxis.MinorTickValues = 0:1:20;
ax.YTick = 0:50:350;
ax.YMinorTick='on'; 
ax.YAxis.MinorTickValues = 10:10:370;
set(ax,'FontSize',12)
xlabel('Caldera diameter [cm]','FontSize',14)
ylabel('Caldera volume [cm^3]','interpreter','tex','FontSize',14)
title('Stages of caldera evolution (LC)','FontSize',14,'FontWeight','bold')
grid on
hold off

%high cohesion
figure()
hold on
plot(runtime(1:61),vol13,':s','MarkerSize',4,'LineWidth',1.8,'color',[89, 2, 39]./255)
plot(runtime14,vol14,':x','MarkerSize',4,'LineWidth',1.8,'color',[224 90 0]./255)
plot(runtime(1:63),vol15,':o','MarkerSize',3,'LineWidth',1.8,'color',[1 108 89]./255)
plot(runtime(1:61),vol17,':o','MarkerSize',3,'LineWidth',1.8,'color',[114 132 158]./255)
plot(runtime(1:61),vol12,':x','MarkerSize',4,'LineWidth',1.8,'color',[3 78 163]./255)
plot(runtime(1:62),vol16,':x','MarkerSize',4,'LineWidth',1.8,'color',[0, 31, 97]./255)

legend('E13: r=0.20','E14: r=0.50','E15: r=1.00','E17: r=1.54','E12: r=2.00','E16: r=3.00','Location','NorthWest','NumColumns',1);
labelsx=[diam12(59), diam13(59), diam14(50), diam15(63), diam16(61), diam17(61)];
labelsy=[vol12(60), vol13(59), vol14(50), vol15(63), vol16(61), vol17(59)];
labels={'E12','E13','E14','E15','E16','E17'};
hlabels = labelpoints (labelsx, labelsy, labels,'NE',0.15,'FontSize',12) ;
ax=gca;
axis([0 14 0 170])
ax.XTick = 0:5:13;
ax.XMinorTick='on'; 
ax.XAxis.MinorTickValues = 0:1:13;
ax.YTick = 0:50:150;
ax.YMinorTick='on'; 
ax.YAxis.MinorTickValues = 10:10:170;
set(ax,'FontSize',12)
xlabel('Caldera diameter [cm]','FontSize',14)
ylabel('Caldera volume [cm^3]','interpreter','tex','FontSize',14)
title('Stages of caldera evolution (HC)','FontSize',14,'FontWeight','bold')
grid on
hold off

%% Time series caldera volume 
%Low cohesion experiments
figure()
hold on
plot(runtime(1:61),vol5(1:61),'-s','MarkerSize',4,'LineWidth',1.7,'color',[89, 2, 39]./255)
plot(runtime(1:61),vol4,'-o','MarkerSize',3,'LineWidth',1.7,'color',[167, 13, 7]./255)
plot(runtime(1:61),vol3,'-s','MarkerSize',4,'LineWidth',1.9,'color',[182, 87, 44]./255) 
plot(runtime(1:61),vol6,'-x','MarkerSize',3,'LineWidth',2,'color',[224 90 0]./255)
plot(runtime(1:61),vol2,'-o','MarkerSize',3,'LineWidth',1.7,'color',[232, 197, 51]./255)
plot(runtime(1:61),vol10,'-s','MarkerSize',4,'LineWidth',1.7,'color',[178, 178, 149]./255)
plot(runtime(1:61),vol1,'-x','MarkerSize',5,'LineWidth',1.7,'color',[98, 108, 118]./255)  
plot(runtime(1:63),vol9,'-s','MarkerSize',4,'LineWidth',1.7,'color',[1 108 89]./255)
plot(runtime,vol7,'-o','MarkerSize',3,'LineWidth',1.7,'color',[24, 142, 150]./255)
plot(runtime(1:61),vol8,'-x','MarkerSize',5,'LineWidth',1.7,'color',[3 78 163]./255)
plot(runtime(1:61),vol11,'-x','MarkerSize',5,'LineWidth',1.7,'color',[0, 31, 97]./255) 

axis([0 190 0 350])
ax=gca;
ax.XTick = 0:20:180;
ax.XMinorTick='on'; 
ax.XAxis.MinorTickValues = 5:5:190;
ax.YTick = 0:50:350;
ax.YMinorTick='on'; 
ax.YAxis.MinorTickValues = 10:10:350;
xlabel('t [min]','FontSize',12)
ylabel('Volume [cm$$^3$$]','interpreter','latex','FontSize',12)
title({'{\bf\fontsize{12} Caldera volume}'; 'LC'},'FontWeight','Normal','FontSize',10,'interpreter','tex')
legend('E5: r=0.2','E4: r=0.3','E3: r=0.35','E6: r=0.5','E2: r=0.54','E10: r=0.6', 'E1: r=0.88','E9: r=1','E7: r=1.23','E8: r=2','E11: r=3','Location','NorthWest','NumColumns',2);
grid on
box on

% slopes of linear volume increase (after initial delay)
%[r1,m1,b1] = regression(runtime(36:61),vol1(36:61),'one');
%[r2,m2,b2] = regression(runtime(33:61),vol2(33:61),'one');
%[r3,m3,b3] = regression(runtime(31:61),vol3(31:61),'one');
%[r4,m4,b4] = regression(runtime(32:61),vol4(32:61),'one');
%[r5,m5,b5] = regression(runtime(32:61),vol5(32:61),'one');
%[r6,m6,b6] = regression(runtime(37:61),vol6(37:61),'one');
%[r7,m7,b7] = regression(runtime(32:65),vol7(32:65),'one');
%[r8,m8,b8] = regression(runtime(43:61),vol8(43:61),'one');
%[r9,m9,b9] = regression(runtime(31:63),vol9(31:63),'one');
%[r10,m10,b10] = regression(runtime(17:61),vol10(17:61),'one');
%[r11,m11,b11] = regression(runtime(51:61),vol11(51:61),'one');

% m = outflow rate of silicone
m1=0.1213;     %cm3 per min
m2=0.4185;
m3=1.1537;
m4=0.3560;
m5=0.8731;
m6=0.1061;
m7=0.5330;
m8=0.1293;
m9=1.93085;
m10=1.3033;
m11=0.1296;

%High cohesion experiments
figure()
hold on
plot(runtime(1:61),vol13,':s','MarkerSize',4,'LineWidth',1.8,'color',[89, 2, 39]./255)
plot(runtime14,vol14,':x','MarkerSize',4,'LineWidth',1.8,'color',[224 90 0]./255)
plot(runtime(1:63),vol15,':o','MarkerSize',3,'LineWidth',1.8,'color',[1 108 89]./255)
plot(runtime(1:61),vol17,':o','MarkerSize',3,'LineWidth',1.8,'color',[114 132 158]./255)
plot(runtime(1:61),vol12,':x','MarkerSize',4,'LineWidth',1.8,'color',[3 78 163]./255)
plot(runtime(1:62),vol16,':x','MarkerSize',4,'LineWidth',1.8,'color',[0, 31, 97]./255)

axis([0 190 0 160])
ax=gca;
ax.XTick = 0:20:180;
ax.XMinorTick='on'; 
ax.XAxis.MinorTickValues = 5:5:190;
ax.YTick = 0:50:150;
ax.YMinorTick='on'; 
ax.YAxis.MinorTickValues = 10:10:160;
xlabel('t [min]','FontSize',12)
ylabel('Volume [cm$$^3$$]','interpreter','latex','FontSize',12)
title({'{\bf\fontsize{12} Caldera volume}'; 'HC'},'FontWeight','Normal','FontSize',10,'interpreter','tex')
legend('E13: r=0.20','E14: r=0.50','E15: r=1.00','E17: r=1.54','E12: r=2.00','E16: r=3.00','Location','NorthWest','NumColumns',1);
grid on, box on
hold off

%slopes of linear volume increase for normalisation
%[r12,m12,b12] = regression(runtime(41:61),vol12(41:61),'one');
%[r13,m13,b13] = regression(runtime(32:61),vol13(32:61),'one');
%[r14,m14,b14] = regression(runtime14(29:53),vol14(29:53),'one');
%[r15,m15,b15] = regression(runtime(32:63),vol15(32:63),'one');
%[r16,m16,b16] = regression(runtime(40:62),vol16(40:62),'one'); %evtl. only till step 58
%[r17,m17,b17] = regression(runtime(34:61),vol17(34:61),'one');

m12=0.1181;
m13=0.8885;
m14=0.1028;
m15=0.5159;
m16=m11;%0.0745;  %uncertain if this is the true value >> assumed same outflow rate as E11
m17=0.5206;
%% Normalised volume-diameter plots
%normalisation factors
%caldera volume normalised by volume of drained silicone
normV1=m1.*runtime(1:61);
normV2=m2.*runtime(1:61);
normV3=m3.*runtime(1:61);
normV4=m4.*runtime(1:61);
normV5=m5.*runtime(1:61);
normV6=m6.*runtime(1:61);
normV7=m7.*runtime;
normV8=m8.*runtime(1:61);
normV9=m9.*runtime(1:63);
normV10=m10.*runtime(1:61);
normV11=m11.*runtime(1:61);
normV12=m12.*runtime(1:61);
normV13=m13.*runtime(1:61);
normV14=m14.*runtime14;
normV15=m15.*runtime(1:63);
normV16=m16.*runtime(1:62);
normV17=m17.*runtime(1:61);

%diameter: caldera diameter normalised by (reservoir diameter+2*H*tan(alpha))
% average alpha                 % individually determined alpha
normD1=4+2*3.5*tand(19.8);      % normD1=4+2*3.5*tand(12.8);
normD2=6.5+2*3.5*tand(19.8);    % normD2=6.5+2*3.5*tand(18.2);
normD3=10+2*3.5*tand(19.8);     % normD3=10+2*3.5*tand(27.2);
normD4=6.5+2*2*tand(19.8);      % normD4=6.5+2*2*tand(34.5);
normD5=10+2*2*tand(19.8);       % normD5=10+2*2*tand(39.9);
normD6=4+2*2*tand(19.8);        % normD6=4+2*2*tand(21.8);
normD7=6.5+2*8*tand(19.8);      % normD7=6.5+2*8*tand(11.0);
normD8=4+2*8*tand(19.8);        % normD8=4+2*8*tand(6.4);
normD9=10+2*10*tand(19.8);      % normD9=10+2*10*tand(16.4);
normD10=10+2*6*tand(19.8);      % normD10=10+2*6*tand(25.8);
normD11=4+2*12*tand(19.8);      % normD11=4+2*12*tand(4.5);
normD12=4+2*8*tand(9.1);       % normD12=4+2*8*tand(2.5);
normD13=10+2*2*tand(9.1);      % normD13=10+2*2*tand(27.6);
normD14=4+2*2*tand(9.1);       % normD14=4+2*2*tand(9.9);
normD15=6.5+2*6.5*tand(9.1);   % normD15=6.5+2*6.5*tand(7.5);
normD16=4+2*12*tand(9.1);      % normD16=4+2*12*tand(1.4);
normD17=6.5+2*10*tand(9.1);    % normD17=6.5+2*10*tand(6.0);

%low cohesion
figure()
hold on
plot(diam5./normD5,vol5./normV5,'-','MarkerSize',4,'LineWidth',1.7,'color',[89, 2, 39]./255)
plot(diam4./normD4,vol4./normV4,'-','MarkerSize',3,'LineWidth',1.7,'color',[167, 13, 7]./255)
plot(diam3./normD3,vol3./normV3,'-','MarkerSize',4,'LineWidth',1.7,'color',[182, 87, 44]./255) 
plot(diam6./normD6,vol6./normV6,'-','MarkerSize',4,'LineWidth',1.7,'color',[222 56 5]./255)
plot(diam2./normD2,vol2./normV2,'-','MarkerSize',3,'LineWidth',1.7,'color',[232, 197, 51]./255)
plot(diam10./normD10,vol10./normV10,'-','MarkerSize',4,'LineWidth',1.7,'color',[178, 178, 149]./255)
plot(diam1./normD1,vol1./normV1,'-','MarkerSize',4,'LineWidth',1.7,'color',[98, 108, 118]./255) 
plot(diam9./normD9,vol9./normV9,'-','MarkerSize',4,'LineWidth',1.7,'color',[1 108 89]./255)
plot(diam7./normD7,vol7./normV7,'-','MarkerSize',3,'LineWidth',1.7,'color',[24, 142, 150]./255)
plot(diam8./normD8,vol8./normV8,'-','MarkerSize',4,'LineWidth',2,'color',[3 78 163]./255)
plot(diam11./normD11,vol11./normV11,'-','MarkerSize',4,'LineWidth',2.2,'color',[0, 31, 97]./255)

xlabel('D_{caldera} / D_{reservoir}','FontSize',12,'interpreter','tex')
ylabel('V_{caldera} / V_{silicone}','FontSize',12,'interpreter','tex')
grid on
title({'{\bf\fontsize{12} Caldera evolution}'; 'C= 66 Pa'},'FontWeight','Normal','FontSize',10,'interpreter','tex')
legend('E5','E4','E3','E6','E2','E10', 'E1','E9','E7','E8','E11','Location','SouthWest','NumColumns',2);
hold off

%high cohesion
figure()
hold on
plot(diam13./normD13,vol13./normV13,':','MarkerSize',4,'LineWidth',1.8,'color',[89, 2, 39]./255,'MarkerFaceColor',[89, 2, 39]./255)
plot(diam14./normD14,vol14./normV14,':','MarkerSize',5,'LineWidth',1.8,'color',[224 90 0]./255)
plot(diam15./normD15,vol15./normV15,':','MarkerSize',3,'LineWidth',1.8,'color',[1 108 89]./255,'MarkerFaceColor',[1 108 89]./255)
plot(diam17./normD17,vol17./normV17,':','MarkerSize',3,'LineWidth',1.8,'color',[114 132 158]./255,'MarkerFaceColor',[114 132 158]./255)
plot(diam12./normD12,vol12./normV12,':','MarkerSize',5,'LineWidth',1.8,'color',[3 78 163]./255)
plot(diam16./normD16,vol16./normV16,':','MarkerSize',5,'LineWidth',1.8,'color',[0, 31, 97]./255)

xlabel('D_{caldera} / D_{reservoir}','FontSize',12,'interpreter','tex')
ylabel('V_{caldera} / V_{silicone}','FontSize',12,'interpreter','tex')
grid on
title({'{\bf\fontsize{12} Caldera evolution}'; 'C= 91 Pa'},'FontWeight','Normal','FontSize',10,'interpreter','tex')
legend('E13','E14','E15','E17','E12','E16','Location','NorthWest','NumColumns',2)
hold off
%% Onset of collapse 

t_subsstart=[20; 9;  6; 9; 7;  16; 15; 55; 6; 7; 125; 75; 6; 16; 15; 185; 22 ]; %defined as subsidence > 1 mm, for E16: time of collapse
t_rf=       [22; 13; 5;  5; 3; 24; 19; 55; 8; 4; 125; 80; 13; 16; 14; 185; 23 ]; %first (partial) reverse fault at surface
t_downsag=  [13; 2;  3;  3;  2;  5; 7; 30; 2; 2;  85; 70;  2;  7;  8;  165; 13 ]; %downsag > 0.25 mm, for E16 time from which on subsidence only increases

%normalisation of onset time by (outflow rate/volume of column above reservoir):
norm_onset= [m1/(2^2*pi*3.5); m2/(3.25^2*pi*3.5); m3/(5^2*pi*3.5); m4/(3.25^2*pi*2); m5/(5^2*pi*2); m6/(2^2*pi*2); m7/(3.25^2*pi*8); m8/(2^2*pi*8); m9/(5^2*pi*10); m10/(5^2*pi*6); m11/(2^2*pi*12); m12/(2^2*pi*8); m13/(5^2*pi*2); m14/(2^2*pi*2); m15/(3.25^2*pi*6.5); m16/(2^2*pi*12); m17/(3.25^2*pi*10)];
t_subsstart_norm= t_subsstart./norm_onset;
t_downsag_norm=t_downsag./norm_onset;

% plot normalised onset of subsidence and first reverse faulting on surface separately for low and higher cohesion series
t_subsstart_norm_LC=t_subsstart_norm(1:11);
t_subsstart_norm_HC=t_subsstart_norm(12:17);
t_subsstart_LC=t_subsstart(1:11);
t_subsstart_HC=t_subsstart(12:17);
t_downsag_norm_LC=t_downsag_norm(1:11);
t_downsag_norm_HC=t_downsag_norm(12:17);
t_downsag_LC=t_downsag(1:11);
t_downsag_HC=t_downsag(12:17);

%sorting of data in direction of increasing roof aspect ratio
[r_sorted_LC sort_index_r_LC]=sort(r(1:11));  %sort data in same order as increasing r
[r_sorted_HC sort_index_r_HC]=sort(r(12:17));

figure()
hold on
ax=gca;
plot(r_sorted_LC,t_subsstart_norm_LC(sort_index_r_LC),'-s','MarkerSize',6,'LineWidth',1.8,'color',[0 105 105]./255, 'MarkerFaceColor',[0 105 105]./255)
plot(r_sorted_HC,t_subsstart_norm_HC(sort_index_r_HC),'-o','MarkerSize',6,'LineWidth',1.8,'color',[155 0 0]./255,'MarkerFaceColor',[155 0 0]./255)
xlabel('r','FontSize',14,'interpreter','tex')
ylabel('Scaled drainage time','FontSize',14,'interpreter','tex')%t_{onset}/ (outflow rate/ driving column)
title('b) Onset of caldera collapse normalised','FontWeight','bold','FontSize',14,'interpreter','tex')
legend('Start collapse LC','Start collapse HC','Location','NorthWest','NumColumns',1);
grid on,box on,hold off

figure()
hold on
ax=gca;
plot(r_sorted_LC,t_downsag_LC(sort_index_r_LC),':s','MarkerSize',4,'LineWidth',1.6,'color',[0 105 105]./255, 'MarkerFaceColor',[0 105 105]./255)
plot(r_sorted_HC,t_downsag_HC(sort_index_r_HC),':o','MarkerSize',4,'LineWidth',1.6,'color',[155 0 0]./255,'MarkerFaceColor',[155 0 0]./255)
plot(r_sorted_LC,t_subsstart_LC(sort_index_r_LC),'-s','MarkerSize',6,'LineWidth',1.8,'color',[0 105 105]./255, 'MarkerFaceColor',[0 105 105]./255)
plot(r_sorted_HC,t_subsstart_HC(sort_index_r_HC),'-o','MarkerSize',6,'LineWidth',1.8,'color',[155 0 0]./255,'MarkerFaceColor',[155 0 0]./255)
%ax.YScale= 'log';
xlabel('r','FontSize',14,'interpreter','tex')
ylabel('Onset time [min]','FontSize',14,'interpreter','tex')%t_{onset}/ (outflow rate/ driving column)
title('a) Onset of caldera collapse','FontWeight','bold','FontSize',14,'interpreter','tex')
legend('Start downsag LC','Start downsag HC','Start collapse LC','Start collapse HC','Location','NorthWest','NumColumns',1);
box on, grid on, hold off
%% Critical volume fraction

%reservoir volumes:
Vres_s=2^2*pi*4;
Vres_m=3.25^2*pi*4;
Vres_l=5^2*pi*4;  

vol_outLC=[20*m1; 9*m2;  6*m3; 9*m4; 7*m5;  16*m6; 15*m7; 55*m8; 6*m9; 7*m10; 125*m11];
vol_outHC=[75*m12; 6*m13; 16*m14; 15*m15; 185*m16; 22*m17]; %drained volume at onset of caldera subsidence (> 1 mm)
A_LC=pi.*(([4; 6.5; 10; 6.5; 10; 4; 6.5; 4; 10; 10; 4])/2).^2; 
A_HC=pi.*(([4; 10; 4; 6.5; 4; 6.5])/2).^2; %cross section area silicone reservoir [cm^2]

Delta_V_LC_sorted=vol_outLC(sort_index_r_LC);
Delta_V_HC_sorted=vol_outHC(sort_index_r_HC);
A_LC_sorted=A_LC(sort_index_r_LC);
A_HC_sorted=A_HC(sort_index_r_HC);

R_LC=D(1:11)./2;
R_HC=D(12:17)./2;
R_LC_sorted=D_LC(sort_index_r_LC)./2;
R_HC_sorted=D_HC(sort_index_r_HC)./2;

H_LC=H(1:11);
H_HC=H(12:17);
H_LC_sorted=H_LC(sort_index_r_LC);
H_HC_sorted=H_HC(sort_index_r_HC);

V_overb_LC=A_LC_sorted.*H_LC_sorted; % volume of roof column above reservoir
V_overb_HC=A_HC_sorted.*H_HC_sorted;
Delta_V_overb_LC=Delta_V_LC_sorted./V_overb_LC; 
Delta_V_overb_HC=Delta_V_HC_sorted./V_overb_HC;

%plot DeltaV/V_oberburden
figure()
hold on
ax=gca;
axis([0 3.1  0 18])
plot(r_sorted_LC,Delta_V_overb_LC.*100,'s','MarkerSize',8,'color',[0 105 105]./255,'MarkerFaceColor',[0 105 105]./255)
plot(r_sorted_HC,Delta_V_overb_HC.*100,'o','MarkerSize',8,'color',[155 0 0]./255,'MarkerFaceColor',[155 0 0]./255)

ax.XTick = 0:0.5:3;
ax.XMinorTick='on'; 
ax.XAxis.MinorTickValues = 0:0.25:3;
ax.YTick = 0:5:15;
ax.YMinorTick='on'; 
ax.YAxis.MinorTickValues = 0:1:18;
ax.YAxis.TickLabel = {'','5%','10%','15%'};
xlabel('r','FontSize',12,'interpreter','tex')
ylabel('\DeltaV/ V_{overburden}','FontSize',12,'interpreter','tex')
title('Relative volume change at depth at onset of collapse','FontWeight','bold','FontSize',12,'interpreter','tex')
legend('LC','HC','Location','NorthWest','NumColumns',1);
grid on
hold off

%fraction of silicone drained at start of caldera subsidence (>1mm) 
Volfrac_LC=[20*m1/Vres_s; 9*m2/Vres_m;  6*m3/Vres_l; 9*m4/Vres_m; 7*m5/Vres_l;  16*m6/Vres_s; 15*m7/Vres_m; 55*m8/Vres_s; 6*m9/Vres_l;7*m10/Vres_l; 125*m11/Vres_s];
Volfrac_HC=[75*m12/Vres_s; 6*m13/Vres_l; 16*m14/Vres_s; 15*m15/Vres_m; 185*m16/Vres_s; 22*m17/Vres_m];
Volfrac_LC_sorted=Volfrac_LC(sort_index_r_LC);
Volfrac_HC_sorted=Volfrac_HC(sort_index_r_HC);

fit_LC=1.64*exp([0:0.1:3])+0.1;
fit_HC=2.43*exp([0:0.1:3])-1.2;

%plot f
figure()
hold on
ax=gca;
axis([0 3.1  0 50])
plot(r_sorted_LC,Volfrac_LC_sorted.*100,'s','MarkerSize',8,'color',[0 105 105]./255,'MarkerFaceColor',[0 105 105]./255)
plot([0:0.1:3],1.64*exp([0:0.1:3])+0.1,'-','MarkerSize',8,'LineWidth',1.7,'color',[0 105 105]./255)
plot(r_sorted_HC,Volfrac_HC_sorted.*100,'o','MarkerSize',8,'color',[155 0 0]./255,'MarkerFaceColor',[155 0 0]./255)
plot([0:0.1:3],2.42*exp([0:0.1:3])-0.9,'-','MarkerSize',8,'LineWidth',1.6,'color',[155 0 0]./255)
ax.YAxis.TickLabel = {'','5%','10%','15%','20%','25%','30%','35%','40%','45%','50%'};
xlabel('r','FontSize',12,'interpreter','tex')
ylabel('\Delta V_{silicone} ','FontSize',12,'interpreter','tex')
title('Drained volume fraction at onset of collapse','FontWeight','bold','FontSize',12,'interpreter','tex')
legend('LC','1.64*exp(r) + 0.1','HC','2.42*exp(r) - 0.9','Location','NorthWest','NumColumns',1);
grid on
hold off
%% Downsagged area (>0.25 mm subsidence) - caldera area
%caldera area
area1=exp1_morph_data.CalderaData.caldera_area_cm2;
area2=exp2_morph_data.CalderaData.caldera_area_cm2;
area3=exp3_morph_data.CalderaData.caldera_area_cm2;
area4=exp4_morph_data.CalderaData.caldera_area_cm2;
area5=exp5_morph_data.CalderaData.caldera_area_cm2;
area6=exp6_morph_data.CalderaData.caldera_area_cm2;
area7=exp7_morph_data.CalderaData.caldera_area_cm2;
area8=exp8_morph_data.CalderaData.caldera_area_cm2;
area9=exp9_morph_data.CalderaData.caldera_area_cm2;
area10=exp10_morph_data.CalderaData.caldera_area_cm2;
area11=exp11_morph_data.CalderaData.caldera_area_cm2;
area12=exp12_morph_data.CalderaData.caldera_area_cm2;
area13=exp13_morph_data.CalderaData.caldera_area_cm2;
area14=exp14_morph_data.CalderaData.caldera_area_cm2;
area15=exp15_morph_data.CalderaData.caldera_area_cm2;
area16=exp16_morph_data.CalderaData.caldera_area_cm2;
area17=exp17_morph_data.CalderaData.caldera_area_cm2;

%Downsagged area
exp1_downsag_data = load('exp1_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp2_downsag_data = load('exp2_output/MATLAB output/14.Analysis plots//DownsagData.mat');
exp3_downsag_data = load('exp3_repeat_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp4_downsag_data = load('exp4_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp5_downsag_data = load('exp5_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp6_downsag_data = load('exp6_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp7_downsag_data = load('exp7_repeat_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp8_downsag_data = load('exp8_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp9_downsag_data = load('exp9_output_reprocessed/MATLAB output/14.Analysis plots/DownsagData.mat');
exp10_downsag_data = load('exp10_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp11_downsag_data = load('exp11_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp12_downsag_data = load('exp12_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp13_downsag_data = load('exp13_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp14_downsag_data = load('exp14_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp15_downsag_data = load('exp15_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp16_downsag_data = load('exp16_output/MATLAB output/14.Analysis plots/DownsagData.mat');
exp17_downsag_data = load('exp17_output/MATLAB output/14.Analysis plots/DownsagData.mat');

downsag1=exp1_downsag_data.DownsagData.caldera_area_cm2;
downsag2=exp2_downsag_data.DownsagData.caldera_area_cm2;
downsag3=exp3_downsag_data.DownsagData.caldera_area_cm2;
downsag4=exp4_downsag_data.DownsagData.caldera_area_cm2;
downsag5=exp5_downsag_data.DownsagData.caldera_area_cm2;
downsag6=exp6_downsag_data.DownsagData.caldera_area_cm2;
downsag7=exp7_downsag_data.DownsagData.caldera_area_cm2;
downsag8=exp8_downsag_data.DownsagData.caldera_area_cm2;
downsag9=exp9_downsag_data.CalderaData.caldera_area_cm2;
downsag10=exp10_downsag_data.DownsagData.caldera_area_cm2;
downsag11=exp11_downsag_data.DownsagData.caldera_area_cm2;
downsag12=exp12_downsag_data.DownsagData.caldera_area_cm2;
downsag13=exp13_downsag_data.DownsagData.caldera_area_cm2;
downsag14=exp14_downsag_data.DownsagData.caldera_area_cm2;
downsag15=exp15_downsag_data.DownsagData.caldera_area_cm2;
downsag16=exp16_downsag_data.DownsagData.caldera_area_cm2;
downsag17=exp17_downsag_data.DownsagData.caldera_area_cm2;

% Plot downsagged area vs. subsided area
figure()
hold on
plot(runtime(1:61),downsag5(1:61)-area5(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[89, 2, 39]./255) 
plot(runtime(1:61),downsag4(1:61)-area4(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[167, 13, 7]./255)
plot(runtime(1:61),downsag3(1:61)-area3(1:61),'-','MarkerSize',4,'LineWidth',1.8,'color',[182, 87, 44]./255) 
plot(runtime(1:61),downsag6(1:61)-area6(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[224 90 0]./255)
plot(runtime(1:61),downsag2(1:61)-area2(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[232, 197, 51]./255)
plot(runtime(1:61),downsag10(1:61)-area10(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[178, 178, 149]./255)
plot(runtime(1:61),downsag1(1:61)-area1(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[98, 108, 118]./255)  
plot(runtime(1:61),downsag9(1:61)-area9(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[1 108 89]./255)
plot(runtime(1:53),downsag7(1:53)-area7(1:53),'-','MarkerSize',3,'LineWidth',1.8,'color',[24, 142, 150]./255)
plot(runtime(1:61),downsag8(1:61)-area8(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[3 78 163]./255)
plot(runtime(1:61),downsag11(1:61)-area11(1:61),'-','MarkerSize',3,'LineWidth',2.3,'color',[0, 31, 97]./255)

ax=gca;
axis([0 100 0 170])
legend('E5','E4','E6','E2','E10', 'E1','E9','E8','E11','Location','SouthWest','NumColumns',2);
xlabel('t [min]','FontSize',14)
ylabel('Downsagged area [cm^2]','interpreter','tex','FontSize',14)
title('Surface downsag LC','FontSize',14,'FontWeight','bold')
grid on, box on, hold off

figure(),hold on
plot(runtime(1:61),downsag13(1:61)-area13(1:61),':','MarkerSize',3,'LineWidth',2.3,'color',[89, 2, 39]./255)
plot(runtime14,downsag14(1:53)-area14(1:53),':','MarkerSize',3,'LineWidth',2.3,'color',[224 90 0]./255)
plot(runtime(1:63),downsag15(1:63)-area15(1:63),':','MarkerSize',3,'LineWidth',2.3,'color',[1 108 89]./255)
plot(runtime(1:61),downsag17(1:61)-area17(1:61),':','MarkerSize',3,'LineWidth',2.3,'color',[114 132 158]./255)
plot(runtime(1:61),downsag12(1:61)-area12(1:61),':','MarkerSize',3,'LineWidth',2.3,'color',[3 78 163]./255)
plot(runtime(40:62),downsag16(40:62)-area16(40:62),':','MarkerSize',3,'LineWidth',2.3,'color',[0, 31, 97]./255)
ax=gca;
legend('E13','E14','E15','E17','E12','E16','Location','NorthWest','NumColumns',2) 
xlabel('t [min]','FontSize',14)
ylabel('Downsagged area [cm^2]','interpreter','tex','FontSize',14)
title('Surface downsag HC','FontSize',14,'FontWeight','bold')
grid on, box on,hold off