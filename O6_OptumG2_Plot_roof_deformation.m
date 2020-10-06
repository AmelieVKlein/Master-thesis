%%  06: Plot distribuion of plastic energy dissipation and surface displacements
%reads result data tables exported from OptumG2 to:
 %calculate angles of the ring-faults
 %calculate the surface diameter of the caldera
 clc; clear all; close all;   
%% Plot map of total energy dissipation = damage zone
% stop index for reading csv files >> readstop= node number before 2nd occurence of "Node" +1
readstop = [61498,56005,52852,57268,53968,53842,61519,45913,59698,59857,55768,57214,60328,56371,60076,40465,62248];
H = [3.5, 3.5, 3.5, 2, 2, 2, 8, 8, 10, 6, 12, 8, 2, 2, 6.5, 12, 10]./100; %chamber depth [cm]

for i=17
for j=17
np          = readstop(i)-1;
TRI_start   = readstop(i)+4+np;

Plast=csvread((strcat('E',num2str(i),'_Plasticity.csv')), 2, 0, [2 0 readstop(i) 6]);
Plasticity{i}=csvread((strcat('E',num2str(i),'_Plasticity.csv')), 2, 0, [2 0 readstop(i) 6]);
% Reads the triangle parameters of the nodes (Optum uses triangle mesh)
TRI = csvread((strcat('E',num2str(i),'_Plasticity.csv')), TRI_start, 1);
x   = Plast(:,2); % x-coordinates of the nodes
y   = Plast(:,3); % y-coordinates of the nodes
totdiss= Plast(:,6); %total dissipation
N = [x'; y'];
nel = size(TRI,1); % Number of elements
    
figure(i)
ax=gca;
% Plots map of totdiss scaled in cm
trisurf(TRI, N(1,:).*100, (N(2,:)-(H(i)+0.05)).*100, zeros(size(N(1,:))), totdiss);

c=colorbar;
c.Label.String = 'Total energy dissipation [kJ]';
c.Label.FontSize = 12;
caxis([0 max(totdiss)/20])

axis equal
axis([0 6 -(H(i)*100+2) 0]) %only display relevant area
view(2),shading flat
colormap (viridis)

ax.XMinorTick='on';
ax.XAxis.MinorTickValues = 0.5:0.5:6;
ax.YTick = -16:2:0;
ax.YMinorTick='on'; 
ax.YAxis.MinorTickValues = -16.5:0.5:0;
xlabel('x [cm]')
ylabel('H [cm]')
titleText = strcat('Plastic deformation E',num2str(i));  
title(titleText)
ax.FontSize= 12

%%% Calculate dip angles of damage zones %%%
    [x_i,ind_s] = sort(N(1,:)); %sort(N(1,:)); % sort data in x-direction and get sorting indices ind_s , shift corner in origin
      
    y_i         = N(2,ind_s); % sort according to ind_s 
    totdiss        = [Plast(ind_s,6)];  % select total plastic energy dissipation and sort

    %selection data with deformation above threshold
    dam_zone=totdiss(totdiss>(max(totdiss)*0.05));
    dam_ind=find(totdiss>=(max(totdiss)*0.05));

    x_i          = x_i(dam_ind)*100; %selct and scale to cm
    y_i          = y_i(dam_ind)*100;
    y_i=y_i-(H(i)+0.05).*100;

    % Calculate distance from tip
    %r_i         = sqrt(x_i.^2 + y_i.^2); % Distance to origin for each point 
    theta_i     =  atand(y_i./x_i);      % Angle to origin for each point 
    theta_fault(i)   = nanmean(theta_i); % average angles of whole selected damage zone, to check if it was correct

     corner      = y_i<(0.75.*(-H(j)*100));      % Region defined as corner region
     far      = y_i>(0.5.*(-H(j)*100));          % region defined as far away from chamber corner

    theta_corner(i)   = nanmean(theta_i(corner)); % average of angles, to check if it was correct
    theta_far(i)   = nanmean(theta_i(far));      % average of angles, to check if it was correct

    % Linear regression to find angle of fault near the chamber wall and
    % far away (near surface)
    if sum(corner)>10 % if more than 10 points are above threshold for deformation
        line_corner    = polyfit(y_i((corner)),x_i((corner)),1); % Fit data
        corner_fit     = line_corner(1).*y_i((corner)) + line_corner(2);
        alpha_corner(i) = acotd(line_corner(1));
        
     hold on   
        plot(corner_fit, y_i((corner)),'r', 'LineWidth', 1.5)
    else
        alpha_corner(i) = NaN;
    end

    if sum(far)>5 % if more than 5 points
        line_far    = polyfit(y_i((far)),x_i((far)), 1);
        far_fit     = line_far(1).*y_i((far)) + line_far(2);
        alpha_far(i) = acotd(line_far(1));

        hold on
        plot( far_fit, y_i((far)),'r', 'LineWidth', 1.5)
        hold off
    else
        alpha_far(i) = NaN;
        hold off
    end
end

filename_eps=['Plots of damage zone/Fault_analysis_',strcat('E',num2str(i)),'.eps'];
filename_png=['Plots of damage zone/Fault_analysis_',strcat('E',num2str(i)),'.png'];
print('-painters','-dpng','-r600',filename_png)
print('-painters','-deps','-r600',filename_eps)
end

%% Plot fault angles as fuction of roof aspect ratio

H      = [3.5, 3.5, 3.5, 2, 2, 2, 8, 8, 10, 6, 12, 8, 2, 2, 6.5, 12, 10];    %reservoir depth [cm]
D      = [4, 6.5, 10, 6.5, 10, 4, 6.5, 4, 10, 10, 4, 4, 10, 4, 6.5, 4, 6.5]; %reservoir diameter [cm]
r     = H./D;                                                                % roof aspect ratio  

%fault angles close to chamber edge (corner) and near surface as calculated
%above
alpha_corner=-1.*[-64.78, -63.81, -64.16, -63.22, -55.43, -64.22, -61.41, -62.74, -66.17, -63.78, -61.0, -61.1, -55.78, -63.55, -63.03, -63.04, -60.90];
alpha_far=-1.*[-76.19, -61.71, -58.80, -57.93, -87.96, -58.97, -79.41, NaN, -73.85, -57.66, NaN, NaN, -79.09, -57.13, -78.29, NaN, NaN]; 

Lab=[69.6 67.6 70.1 67.3 69.7 72.1 79.7 83.8 73.4 72.6 84.0 81.4 66.7 59.6 72.6 88.3 79.8]; 
%dip angle in lab experiments estimated by the diameter of the first RF localising on the surface, the roof height H and chamber diameter D

figure()
ax=gca;
scatter(r, alpha_corner, 35,'MarkerEdgeColor',[0 0 102]./255,'MarkerFaceColor',[0 0 102]./255)
hold on
scatter(r,alpha_far, 35,'MarkerEdgeColor',[204 0 0]./255,'MarkerFaceColor',[204 0 0]./255)
%scatter(r,Lab, 40,'MarkerEdgeColor',[100 100 100]./255,'Linewidth',1.5)
legend('angle at depth','near-surface angle')
xlabel('r')
ylabel('\Theta [\circ]','interpreter','tex')
title('Angle of modelled fault zone')
grid on
%% Plot displacements 
clear all; close all; clc;

% stop index for reading csv files >> readstop= node number before 2nd occurence of "Node" +1
readstop = [61498,56005,52852,57268,53968,53842,61519,45913,59698,59857,55768,57214,60328,56371,60076,40465,62248];

H = [3.5, 3.5, 3.5, 2, 2, 2, 8, 8, 10, 6, 12, 8, 2, 2, 6.5, 12, 10]./100; %reservoir depth [cm]

for i=1:17
for j=1:17
np          = readstop(i)-1;
TRI_start   = readstop(i)+4+np;

U=csvread((strcat('E',num2str(i),'_Displacements.csv')),2,0,[2 0 readstop(i) 5]);
U_matrix{i}=csvread((strcat('E',num2str(i),'_Displacements.csv')), 2, 0, [2 0 readstop(i) 5]);
% Reads the triangle parameters made of the nodes
TRI = csvread((strcat('E',num2str(i),'_Displacements.csv')), TRI_start, 1);
x   = U(:,2); % x-coordinates of the nodes
y   = U(:,3); % y-coordinates of the nodes
u= U(:,5); %y-displacements
           
N = [x'; y'];
nel = size(TRI,1); % Number of elements
    
figure(i)
ax=gca;
% Plots map of totdiss scaled in cm
trisurf(TRI, N(1,:).*100, (N(2,:)-(H(i)+0.05)).*100, zeros(size(N(1,:))), u);

c=colorbar;
c.Label.String = '|U|';
c.Label.FontSize = 12;
caxis([0 1])

axis equal
axis([0 6 -(H(i)*100+2) 0]); %only display relevant area
view(2),shading flat
colormap (flipud(viridis))
ax.YTick = -16:2:0;
xlabel('x [cm]');
ylabel('H [cm]');
titleText = strcat('Displacements E',num2str(i));  
title(titleText);
ax.FontSize= 12;

%%% Calculate diameter of displaced surface area
 [y_i,ind_s] = sort(N(2,:)); % % sort data in y-direction and get sorting indices ind_s
      
        x_i         = N(1,ind_s); % sort according to ind_s 
        u        = [U(ind_s,5)];  % select y- displacements
      
        %select displacements above threshold as caldera 
        u(u==0)=NaN;
        meandisp=nanmean(u);
        cald_zone=u(u<=(0.25*meandisp));
        cald_ind=find(u<=(0.25*meandisp));
        x_i          = x_i(cald_ind)*100; %selct and scale to cm
        y_i          = y_i(cald_ind)*100;
        y_i=y_i-(H(i)+0.05).*100;
        
        %select only uppermost 1mm defined as "surface"
        cald_surf=y_i(y_i>=-0.1); 
        surf_ind=find(y_i>=-0.1);
        x_i          = x_i(surf_ind);
        y_i          = y_i(surf_ind);
        
        if ~isempty(x_i)
        surf_rad(i)=max(x_i);        %radius of caldera at the surface
        surf_diam(i)=surf_rad(i).*2; %caldera diameter in cm
        else
        surf_rad(i)=NaN; 
        surf_diam(i)=NaN; 
        end
        
        hold on
        plot(x_i, y_i,'or', 'LineWidth', 2)
        
 exp(i)=i;
end
filename_eps=['Plots of damage zone/Caldera_radius_',strcat('E',num2str(i)),'.eps'];
filename_png=['Plots of damage zone/Caldera_radius_',strcat('E',num2str(i)),'.png'];
print('-painters','-dpng','-r600',filename_png)
print('-painters','-deps','-r600',filename_eps)
 %save values
 Caldera_diameter_Optum = table(exp',surf_rad',surf_diam','VariableNames',{'exp','surf_rad_cm','surf_diam_cm'});
 writetable(Caldera_diameter_Optum,'Caldera_diameter_Optum.txt','Delimiter','\t') 
 
 close all
end