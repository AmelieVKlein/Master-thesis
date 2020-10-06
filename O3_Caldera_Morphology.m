%% Extract caldera morphology
% get caldera diameter, volume, ect. from Delta DEM maps
close all;
QUAL=['-r600']; %set image quality
set(0,'defaulttextinterpreter','latex')
N = numel(timeSteps);

runtime=[[1:1:30]';[35:5:185]']; %assign runtime to timesteps 
U_DEM=U_DEM.*1000;               %convert data to mm
x=x+0.026;  %shift x- and y- values to account for GCP offset from the box corner 
y=y-0.011;
%% %prepare variable space
maxsub=zeros(N-2,1);
x_maxsub=zeros(N-2,1);
y_maxsub=zeros(N-2,1);
x_pos_center=zeros(N-2,1);
y_pos_center=zeros(N-2,1);
Caldera_volume=zeros(N-2,1);
caldera_area=zeros(N-2,1);
caldera_area_cm2=zeros(N-2,1);
caldera_diameter=zeros(N-2,1);
caldera_center=zeros(N-2,2);
caldera_center_cm=zeros(N-2,2);
caldera_min_ax= zeros(N-2,1); 
caldera_maj_ax= zeros(N-2,1); 
caldera_eccentricity=zeros(N-2,1);
profilesx = zeros(N-2,length(x));
profilesy = zeros(N-2,length(y));
%% Select caldera area and calculate size

mkdir('14.Analysis plots')
%image analysis
for n=[1:N-3]   
    % smooth data
    U_DEM_n = squeeze(U_DEM(n,:,:));
    U_DEM_bin = zeros(1667,1667);       
    U_DEM_n = smooth2a(U_DEM_n,15,15);
   
    % Measure of maximum subsidence
    maxsub(n,1)=min(min(U_DEM_n(125:1500,125:1500))); 
    [yind_maxsub(n,1) xind_maxsub(n,1)]=find(U_DEM_n == maxsub(n,1));
    x_maxsub(n,1)=x(xind_maxsub(n,1)); 
    y_maxsub(n,1)=y(length(U_DEM_n(1,:))-yind_maxsub(n,1)); %difference, because pixel rows are counted from top left downwards, but the zero coordinate of the IKEA box  is in the bottom left corner
    y_maxsub(n,1)=y_maxsub(n,1)+0.011; %0.011 GCP-offset
    
    % Select caldera area
    Cald_sel = find(U_DEM_n<-1); %define subsidence threshold of 1mm   
    U_DEM_bin(Cald_sel) = 1;  % convert to binary image> pixels with subsidence <1mm set to 1
    selected_px=length(Cald_sel);
        
    BW = im2bw(mat2gray(U_DEM_bin, [0 1])); % make black-white map
        
    % measure caldera properties
    s  = regionprops('table',BW,'centroid', 'Area','PixelIdxList', 'EquivDiameter','MajorAxisLength','MinorAxisLength','Eccentricity','Orientation');
    
    if height(s) ==0
        caldera_area(n,1) = 0;
        caldera_area_cm2(n,1) = 0;
        caldera_diameter(n,1) = 0;
        Caldera_volume(n,1) = 0;
        caldera_center(n,:) = [NaN,NaN];
        caldera_min_ax(n,1) = 0; 
        caldera_maj_ax(n,1) = 0; 
        caldera_eccentricity(n,1)=NaN;
        
   else largestpatch=max(s.Area);
        largestpatch_index=find(s.Area==largestpatch);
        s=s(largestpatch_index,:); %only select largest patch as caldera to exclude possible outliers near box walls
        centers = s.Centroid;      %center of mass of selected area
        areas = s.Area;
       
        diameters = s.EquivDiameter; %diameter of a circle with the same area as caldera
        area_size(n,1)= max(areas); %number of caldera pixels (valued 1)
        area_data = find(areas==area_size(n,1)); 
        
        maj_ax = s.MajorAxisLength;  
        min_ax = s.MinorAxisLength;  
        eccentricity=s.Eccentricity; %[0 1]; 0:circle, 1: line segment
        
        % List of pixels of the caldera
        pixels_caldera = s.PixelIdxList;
        list_pixels = pixels_caldera{area_data};

        % Convert the caldera measures from pixel number to metrical units
        caldera_diameter(n,1) = diameters*0.015; %in cm, pixel size is 0.015 cm (25 cm box in MicMac/number of pixels),larger crop box for processing E9>> factor here:0.0166        caldera_min_ax(n,1) = min_ax*0.015; %in cm
        caldera_maj_ax(n,1) = maj_ax*0.015; %in cm
        caldera_area_cm2(n,1) = areas*0.015*0.015; %cm^2
        caldera_eccentricity(n,1)=eccentricity;
        
        % Calculates the volume of the caldera in cm^3
        Caldera_volume(n,1) = (sum(U_DEM_n(list_pixels))/10)*0.015*0.015*(-1); %/10 because U_DEM_n is in mm
        
        % Provides the centre of the caldera through time
        caldera_center(n,:) = fliplr(centers(area_data,:)); % left-right flips the center coordinates> as image coordinates are (rows,columns), but I want it in (x,y)
      
        %center positions
        x_pos_center(n,1)=x(round(centers(1)));
        y_pos_center(n,1)=y(length(BW(1,:))-round(centers(2))); %difference to account for reversed y-axis 
        y_pos_center(n,1)=y_pos_center(n,1)+0.011; %add GCP offset
          
        caldera_center_cm(n,1)=x_pos_center(n); %write positions in list
        caldera_center_cm(n,2)=y_pos_center(n);
        
        %subsidence profiles over whole box area in x-/y-direction through caldera center
        profilesy(n,:) = U_DEM_n(round(centers(2)),:); 
        profilesx(n,:) = U_DEM_n(:,round(centers(1))); 
        
        %plot the selected caldera area + center + max. subsidence
        figure()
        hold on
        imagesc(x,y,BW), axis equal, axis tight
        plot(x_pos_center(n),0.35-y_pos_center(n),'Marker','o','MarkerSize',8,'MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0.62,0.047,0.14],'LineStyle','none')               
        plot(x_maxsub(n),0.35-y_maxsub(n),'Marker','+','MarkerSize',7,'MarkerEdgeColor',[0 0 0],'LineWidth',1.3,'LineStyle','none')
        plot(x_maxsub(n),0.35-y_maxsub(n),'Marker','+','MarkerSize',7,'MarkerEdgeColor',[1 1 1],'LineWidth',1.3,'LineStyle','none')
        
        legend({'Caldera center','max. subsidence',''},'Box','on','FontSize',10,'Location','NorthWest')
        annotation(gcf,'textbox',[0.2975 0.7567 0.16143 0.0638],'String',{sprintf('(%.2f %s',maxsub(n),'mm)')},...
        'LineStyle','none','HorizontalAlignment','center','FontSize',9); %print current subsidence value into legend box 

        ax = gca;
        axis([0.075 0.275 0.075 0.275]);
        ax.YDir = 'reverse';
        ax.XTick = [0.05 0.1 0.15 0.2 0.25 0.3];
        ax.YTick = [0.05 0.1 0.15 0.2 0.25 0.3];
        ax.XTickLabel = {'5','10','15','20','25','30'};
        ax.YTickLabel = {'30','25','20','15','10','5'};
        ax.XMinorTick='on'; 
        ax.YMinorTick='on'; 
        ax.XLabel.String = 'x [cm]';
        ax.YLabel.String = 'y [cm]';
        ax.XLabel.FontSize = 12;
        ax.YLabel.FontSize = 12;
        
        colormap(ax,flipud(gray));
        titleText = sprintf('Runtime: %d %s',runtime(n),'min');  %prints experiment duration instead of time step> see annotation below
        title(titleText,'FontSize',12)
        grid on
        
        filename=['14.Analysis plots/CaldArea&center_',timeSteps(n+3).name,'.jpg'];
        print('-painters','-djpeg','-r600',filename);
        filename=['14.Analysis plots/CaldArea&center_',timeSteps(n+3).name,'.eps'];
        print('-painters','-deps','-r600',filename);
        close all
    end 
end
%% %Write caldera data into table and save as mat.-table
CalderaData = table(runtime,caldera_area_cm2,caldera_center_cm(:,1),caldera_center_cm(:,2),Caldera_volume,caldera_diameter,caldera_eccentricity,caldera_maj_ax,caldera_min_ax,maxsub,'VariableNames',{'runtime','caldera_area_cm2','center_x','center_y','caldera_volume_cm3','caldera_diameter_cm','caldera_eccentricity','maj_ax_length','min_ax_length','maxsub'});
writetable(CalderaData,'14.Analysis plots/CalderaData.txt','Delimiter','\t') 
save('14.Analysis plots/CalderaData.mat', 'CalderaData')
%% Delta DEM profiles
z=viridis(length(runtime)); %colorcoding time in the plots

%Profile through caldera center in x-direction
figure()
for n=1:1:N-3
    ax=gca;
    plot(x-0.05,profilesx(n,:),'color', [z(n,1) z(n,2) z(n,3)],'LineWidth',0.8) ; grid on; box on;
    ax.YLim=[-28 1];
    ax.XLim=[0.05  0.25];
    ax.XTick = [0.05 0.1 0.15 0.2 0.25 ];
    ax.XTickLabel = {'5','10','15','20','25'};
    ax.XLabel.FontSize = 12;
    ax.YLabel.FontSize = 12;
    hold on
end
xlabel('x[cm]')
ylabel('$$\Delta$$DEM [mm]')
title('Elevation across caldera center','FontSize',12,'FontWeight','bold')

caxis([runtime(1) runtime(N-3)]);
c = colorbar;
c.FontSize = 10;
c.Label.String = 'Runtime [min]';
c.Label.Position=[2.97530865 85.48658332 0];
c.Label.Rotation = 90;
c.Label.FontSize = 12;
hold off

filename=['14.Analysis plots/Profile_x.jpg'];
print('-painters','-djpeg','-r600',filename);
filename=['14.Analysis plots/Profile_x.eps'];
print('-painters','-deps','-r600',filename);
close all

%Profile through caldera center in y-direction
figure()
for n=1:N-3
    ax=gca;
    plot((max(y)+0.011)-y,profilesy(n,:),'color', [z(n,1) z(n,2) z(n,3)],'LineWidth',0.8); grid on; box on; %invert y-axis and add GCP-offset
    ax.YLim=[-28 1];
    ax.XLim=[0.05  0.25];
    ax.XTick = [0.05 0.1 0.15 0.2 0.25];
    ax.XTickLabel = {'5','10','15','20','25'};
    ax.XLabel.FontSize = 12;
    ax.YLabel.FontSize = 12;
    hold on
end
xlabel('y [cm]')
ylabel('$\Delta$DEM [mm]')
title('Elevation across caldera center','FontSize',12,'FontWeight','bold')

caxis([runtime(1) runtime(N-3)]);
c = colorbar;
c.FontSize = 10;
c.Label.String = 'Runtime [min]';
c.Label.Position=[2.79012353552712 89.2716265643869 0];
c.Label.Rotation = 90;
c.Label.FontSize = 11;
hold off

filename=['14.Analysis plots/Profile_y.jpg'];
print('-painters','-djpeg','-r600',filename);
filename=['14.Analysis plots/Profile_y.eps'];
print('-painters','-deps','-r600',filename);
close all