%% O7: Critical Reservoir Underpressure
%Plots output from OptumG2 limit analysis 
%displays critical underpressure as a function of r and C
%% Define all variables
gamma   = [14224, 14224, 14224 ,14224, 14224, 14224, 14224, 14224,14224, 14224, 14224, 14028, 14028, 14028, 14028, 14028, 14028];  %unit weight corresponds to density*g
H      = [3.5, 3.5, 3.5, 2, 2, 2, 8, 8, 10, 6, 12, 8, 2, 2, 6.5, 12, 10]; %depth of top of magma reservoir [cm]
H_mean = (H+2)./100; %H* mean depth of reservoir in meter for confining pressure: H*=H+T/2
D      = [4, 6.5, 10, 6.5, 10, 4, 6.5, 4, 10, 10, 4, 4, 10, 4, 6.5, 4, 6.5];  %reservoir diameter [cm]
C      = [66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 91, 91, 91, 91, 91, 91]; %roof cohesion [Pa]
phi      = [26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26.5, 26.5, 26.5, 26.5, 26.5, 26.5]; %angle of internal friction
r     = H./D;    % roof aspect ratio

%Lower bound (LB) and upper bound (UB) values of the collapse multiplier [kPa] from OptumG2 logfiles: 
LB    = [-0.043, -0.162, -0.263, -0.131, -0.187, -0.051, -0.164, -0.042, -0.335, -0.324, -0.042, 0.012, -0.164, -0.008, -0.107, 0.012, -0.106].*(-1e3); %conversion to Pa
UB    = [-0.043, -0.162, -0.262, -0.130, -0.186, -0.051, -0.164, -0.041, -0.334, -0.323, -0.041, 0.012, -0.164, -0.008, -0.106, 0.012, -0.105].*(-1e3);

%delta_P
dP_LB =(LB-gamma.*H./100) ; 
dP_UB =(UB-gamma.*H./100); 

%normalise delta_p with confining pressure to obtain a dimensionless value
dPP_LB= dP_LB./(gamma.*H_mean);
dPP_UB= dP_UB./(gamma.*H_mean);

%mean values between LB and UB:
P_c= (LB+UB)./2;            %critical chamber pressure
dP= (dP_LB+dP_UB)./2;       %critical underpressure
dPP= (dPP_LB+dPP_UB)./2;

%% Plot normalised critical underpressure as function of roof aspect ratio

figure(1)
hold on
plot(r(1:11), dPP_LB(1:11), 'o', 'MarkerSize',6,'LineWidth',1.2, 'MarkerEdgeColor',[0 105 105]./255)
plot(r(1:11), dPP_UB(1:11), '+', 'MarkerSize',6,'LineWidth',1.2, 'MarkerEdgeColor',[0 105 105]./255)
plot(r(12:17), dPP_LB(12:17), 'o', 'MarkerSize',6,'LineWidth',1.2, 'MarkerEdgeColor',[155 0 0]./255)
plot(r(12:17), dPP_UB(12:17), '+', 'MarkerSize',6,'LineWidth',1.2, 'MarkerEdgeColor',[155 0 0]./255)

legend('LB','UB','LB','UB')
axis([0 3.2 min(dPP_UB)-0.05 max(dPP_LB)+0.05 ])
xlabel('r','FontSize',12)
ylabel('\DeltaP_{c} /\rhogH*','interpreter','tex','FontSize',12)
title('Relative underpressure required to trigger collapse','FontSize',12)
grid on
hold off

%% Fitting

% %sorting of data in direction of increasing roof aspect ratio
[r_sort_LC index_LC]=sort(r(1:11));  %sort data in same order as increasing r
[r_sort_HC index_HC]=sort(r(12:17));

dPP_LC=dPP(1:11);
dPP_LC=dPP_LC(1,index_LC);
dPP_HC=dPP(12:17);
dPP_HC=dPP_HC(1,index_HC);

figure(1)
hold on
plot(r_sort_LC, dPP_LC, 'o', 'MarkerSize',8,'LineWidth',1.2, 'MarkerEdgeColor',[0 105 105]./255,'MarkerFaceColor',[0 105 105]./255)
plot(r_sort_HC, dPP_HC, 'o', 'MarkerSize',8,'LineWidth',1.2, 'MarkerEdgeColor',[155 0 0]./255,'MarkerFaceColor',[155 0 0]./255)

axis([0 3.2 min(dPP_UB)-0.05 max(dPP_LB)+0.05 ])
xlabel('r','FontSize',12)
ylabel('\DeltaP_{c} /\rhogH*','interpreter','tex','FontSize',12)
title('Relative underpressure required to trigger collapse','FontSize',12)
grid on

%fit curves to selected data
% fit_LC=polyfit(r_sort_LC,dPP_LC,2);
% fit_HC=polyfit(r_sort_HC,dPP_HC, 2);
% fit_LC_plot = polyval(fit_LC,r_sort_LC);
% fit_HC_plot = polyval(fit_HC,r_sort_HC);
fit_LC=-0.27*log([0:0.1:3])-0.6;
fit_HC=-0.23*log([0:0.1:3])-0.64;

hold on %plot fitted curves on top of data
plot([0:0.1:3],fit_LC,'color',[0 105 105]./255,'LineWidth',1.4)
plot([0:0.1:3],fit_HC,'color',[155 0 0]./255,'LineWidth',1.4)
legend('LC','HC','-0.27*ln(r) - 0.6','-0.23*ln(r) - 0.64')

%% Get theoretical magma pressure at failure after Roche and Druitt, 2001
gamma   = [14224, 14224, 14224 ,14224, 14224, 14224, 14224, 14224,14224, 14224, 14224, 14028, 14028, 14028, 14028, 14028, 14028];  %unit weight corresponds to density*g
H      = [3.5, 3.5, 3.5, 2, 2, 2, 8, 8, 10, 6, 12, 8, 2, 2, 6.5, 12, 10]./100;  %reservoir depth [m]
D      = [4, 6.5, 10, 6.5, 10, 4, 6.5, 4, 10, 10, 4, 4, 10, 4, 6.5, 4, 6.5]./100; %diameter [m]
C      = [66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 91, 91, 91, 91, 91, 91]; %roof cohesion [Pa]
phi      = [26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26.5, 26.5, 26.5, 26.5, 26.5, 26.5]; %internal friction angle [deg]

k=1; %constant <=1
Tau=C+gamma.*H./2.*tand(phi).*k;   %shear strength Mohr-Coulomb 
%alpha=[-76.19, -61.71, -58.80, -57.93, -87.96, -58.97, -79.41, NaN, -73.85, -57.66, NaN, NaN, -79.09, -57.13, -78.29, NaN, NaN];  %angle of damage zone in upper half of the roof
alpha=[-64.78, -63.81, -64.16, -63.22, -55.43, -64.22, -61.41, -62.74, -66.17, -63.78, -61.0, -61.1, -55.78, -63.55, -63.03, -63.04, -60.90]; %angle near chamber

SR=4.*H./D.*(1-(H./(tand(alpha).*D))+(gamma.*H./Tau).*(1./(2.*tand(alpha)))- H./(3.*tand(alpha).*tand(alpha).*D));  %stress ratio, corresponds to equ. 4 in Roche paper, adapted for A=B=R
UP_theo=SR.*Tau.*(-1); %theoretical chamber underpressure for coherent piston collapse

%% Compare limit analysis results and theoretical values
figure()
hold on
plot(r, dP, 'o', 'MarkerSize',9,'LineWidth',1.7, 'MarkerEdgeColor',[155 0 0]./255)
plot(r, UP_theo, '+', 'MarkerSize',10,'LineWidth',1.7, 'MarkerEdgeColor',[0 0 102]./255)

legend('Limit analysis','Theoretical \Delta P_c (Roche & Druitt, 2001)')
ax=gca;
ax.YScale='log';
xlabel('r','FontSize',14)
ylabel('\DeltaP_{c} [Pa]','interpreter','tex','FontSize',14)
title('Calculated and theoretical chamber underpressure','FontSize',14)
grid on, box on
