%% Calculate and plot divergence and shear strain fields of model surface
clear all; clc; close all;

QUAL=['-r600']; % set image quality
%Calibration of image data
rootFolder = 'exp17_output/';
calim=imread('exp17_output/000/ORT.tif'); %calibration/reference image
[y,x,~]=size(calim);  %get number of pixels in x- and y-direction
LX=0.25/x; %m/pixel    pixel to length conversion factor >> box size here: [0.05 30]
LY=0.25/y; %m/pixel

clear calim                      
%% Initialize

%load colormap
RdWBu=load('RdWBu');
RdWBu=RdWBu.RdWBu;

timeSteps = dir(rootFolder);

% Figure scaling
nPxlCol = x;
nPxlRow = y;
x =0:1:nPxlCol;
y =0:1:nPxlRow;

xMin = 0.05;           %box coordinates in meters
xMax = 0.30;
yMin = 0.05;
yMax = 0.30;

x_cm = xMin:(xMax-xMin)/(nPxlCol-1):xMax;
y_cm = yMin:(yMax-yMin)/(nPxlRow-1):yMax;
y_cm=y_cm+0.021;       %shift coordinate axis to account for GCP offsets

t1=[0:1:30]';
t2=[35:5:185]'; 
runtime=[t1;t2];       %runtime of experiment in min

% Allocate memory to variables
M = length(timeSteps)-4;
U_x = zeros(M,nPxlRow,nPxlCol);
U_x_cum=zeros(nPxlRow,nPxlCol);
U_y = U_x;
U_y_cum=zeros(nPxlRow,nPxlCol);

shear_strain = U_x;
shear_strain_cum=zeros(nPxlRow,nPxlCol);
divergence = U_x;
divergence_cum=zeros(nPxlRow,nPxlCol);
%% Load and format displacement data
% displacements all in meters, but are plotted in mm for more intuitive scale

for m = 1:M
    folderName = strcat(rootFolder,timeSteps(m+3).name,filesep); 
    %be careful with the index, check how many rows need to be skipped in the table
      %%% Horizontal displacement fields  
        % x-direction
        imgName = strcat(folderName,'U_X.tif');
     
        U_x(m,:,:)= LX*smooth2a(double(imread(imgName)),1,1);  %window size here set to 1 to calculate shear strain and divergence with unsmoothed data>> smoothed afterwards
        Corners_nx = squeeze((U_x(m,10:50,10:50) + U_x(m,end-49:end-9,10:50) + U_x(m,10:50,end-49:end-9) + U_x(m,end-49:end-9,end-49:end-9))) / 4;
        Ushiftx = mean(Corners_nx(:)); %subtract average displacement of the pixels in box corners to only get relative displacement due to caldera formation
        
        U_x(m,:,:) = U_x(m,:,:) - Ushiftx;  
 
        % y-direction
        imgName = strcat(folderName,'U_Y.tif');
        U_y(m,:,:)= LY*smooth2a(double(imread(imgName)),1,1);
        Corners_ny = squeeze((U_y(m,10:50,10:50) + U_y(m,end-49:end-9,10:50) + U_y(m,10:50,end-49:end-9) + U_y(m,end-49:end-9,end-49:end-9))) / 4;
        Ushifty = mean(Corners_ny(:));
        U_y(m,:,:) = U_y(m,:,:) - Ushifty; 
        U_y(m,:,:)=U_y(m,:,:).*(-1);  % reverse sign of U_y to have correct displacement directions in the plot

        mmy(1,m)=max(max(squeeze(U_y(m,:,:) )));
        mmy(2,m)=min(min(squeeze(U_y(m,:,:))));
 
        %%% Cauchy tensorial strain components, horizontal plane using engineering convention for shear strain:     
        [dUxdx,dUxdy]= gradient(squeeze(U_x(m,:,:))); %gamma_xy
        [dUydx,dUydy]= gradient(squeeze(U_y(m,:,:))); 
   
        shear_strain=  1/2*(dUxdy+dUydx); %infinitesimal shear strain tensor components: epsilon_xy = epsilon_yx = 1/2*gamma_xy
end

%% Shear strain and divergence
set(0,'defaulttextinterpreter','latex')
clear U_x U_y shear_strain divergence 

t1=[0:1:30]';
t2=[35:5:185]'; 
runtime=[t1;t2];

divergence_cum=zeros(size(U_x_cum));
shear_strain_cum=zeros(size(U_x_cum));

mkdir 5.Shear_strain_inc
mkdir 6.Shear_strain_cum
mkdir 7.Divergence_inc
mkdir 8.Divergence_cum

for m = 1:61
    folderName = strcat(rootFolder,timeSteps(m+3).name,filesep);
    
    % Horizontal displacement fields
     imgName = strcat(folderName,'U_X.tif');
     U_x= double(imread(imgName))*LX;
     Corners_nx = (U_x(10:50,10:50) + U_x(end-49:end-9,10:50) + U_x(10:50,end-49:end-9) + U_x(end-49:end-9,end-49:end-9)) / 4;
     Ushiftx = mean(Corners_nx(:));
     U_x = U_x - Ushiftx;

     imgName = strcat(folderName,'U_Y.tif');
     U_y=(double(imread(imgName)))*LY;
     Corners_ny = (U_y(10:50,10:50) + U_y(end-49:end-9,10:50) + U_y(10:50,end-49:end-9) + U_y(end-49:end-9,end-49:end-9)) / 4;
     Ushifty = mean(Corners_ny(:));
     U_y = U_y - Ushifty; % do NOT reverse sign of U_y here; displacements are correctly orientated in image-coordinates 

     % Cauchy tensorial strain components, horizontal plane using engineering convention for shear strain
     [dUxdx,dUxdy]= gradient(squeeze(U_x));
     [dUydx,dUydy]= gradient(squeeze(U_y));

     shear_strain= 1/2*(dUxdy+dUydx);
     divergence= (dUxdx+dUydy);

     shear_strain=smooth2a(shear_strain,10,10); %smooth strain and divergence calculated from unsmoothed dispkacement fields 
     divergence=smooth2a(divergence,10,10);

     figSS_inc = figure;    %plot incremental shear strain  
     imagesc(x_cm,y_cm,shear_strain), axis equal, axis tight, box on
     axis([0.076 0.276 0.076 0.276]);
     ax = gca;
     ax.XLabel.String = 'x [cm]';
     ax.YLabel.String = 'y [cm]';
     ax.XLabel.FontSize = 12;
     ax.YLabel.FontSize = 12;

     colormap(ax,RdWBu);
     caxis([-0.000005 0.000005]) % select colorbar limit at end such that it properly resolves all experiments
     c = colorbar;
     c.FontSize = 10;

     titleText = sprintf('Runtime: %d %s',runtime(m+1),'min');
     title(titleText,'FontSize',12)
     supt=suptitle('Incremental Shear Strain');
     supt.Position=[0.455 -0.048 0]; 
     supt.FontWeight='bold';

      filename=['5.Shear_strain_inc/s_s',timeSteps(m+3).name,'.jpg'];
      print('-painters','-djpeg',QUAL,filename)
      hold off
      close all

      figSS_cum=figure; %plot cumulative Shear Strain
      shear_strain_cum=shear_strain_cum+shear_strain; 
      imagesc(x_cm,y_cm,shear_strain_cum), axis equal, axis tight, box on
      axis([0.076 0.276 0.076 0.276]);
      ax = gca;
      ax.XTick = [0.1 0.15 0.2 0.25];
      ax.YTick = [0.1 0.15 0.2 0.25];
      ax.XTickLabel = {'10','15','20','25'};
      ax.XMinorTick='on'; 
      ax.XAxis.MinorTickValues = 0.08:0.01:0.27;
      ax.YTickLabel = {'25','20','15','10'};
      ax.YMinorTick='on'; 
      ax.YAxis.MinorTickValues = 0.08:0.01:0.27;
      ax.XLabel.String = 'x [cm]';
      ax.YLabel.String = 'y [cm]';
      ax.XLabel.FontSize = 12;
      ax.YLabel.FontSize = 12;

      colormap(ax,RdWBu);
      caxis([-0.00005 0.00005]) % select colorbar limit at end such that it properly resolves all experiments
      c = colorbar;
      c.FontSize = 10;
      titleText = sprintf('Runtime: %d %s',runtime(m+1),'min');
      title(titleText,'FontSize',12)
      supt=suptitle('Cumulative Shear Strain');
      supt.Position=[0.455 -0.048 0]; 
      supt.FontWeight='bold';

      filename=['6.Shear_strain_cum/s_s',timeSteps(m+3).name,'.jpg'];
      print('-painters','-djpeg',QUAL,filename)
      close all     

     figDiv_cum = figure;  %plot incremental Divergence
     imagesc(x_cm,y_cm,divergence), axis equal, axis tight, box on
     axis([0.076 0.276 0.076 0.276]);
     ax = gca;
     ax.XLabel.String = 'x [cm]';
     ax.YLabel.String = 'y [cm]';
     ax.XLabel.FontSize = 12;
     ax.YLabel.FontSize = 12;

     colormap(ax,RdWBu);
     caxis([-0.000008 0.000008]) % select colorbar limit at end such that it properly resolves all experiments
     c = colorbar;
     c.FontSize = 10;   

     titleText = sprintf('Runtime: %d %s',runtime(m+1),'min');
     title(titleText,'FontSize',12)
     supt=suptitle('Incremental Divergence');
     supt.Position=[0.455 -0.048 0]; 
     supt.FontWeight='bold';

     filename=['7.Divergence_inc/Div',timeSteps(m+3).name,'.jpg'];
     print('-painters','-djpeg',QUAL,filename)
     close all

     figDiv = figure; % plot cumulative Divergence 
     divergence_cum=divergence_cum+divergence;
     imagesc(x_cm,y_cm,divergence_cum), axis equal, axis tight, box on
     axis([0.076 0.276 0.076 0.276]);
     ax = gca;
     ax.XLabel.String = 'x [cm]';
     ax.YLabel.String = 'y [cm]';
     ax.XLabel.FontSize = 12;
     ax.YLabel.FontSize = 12;

     colormap(ax,RdWBu);
     caxis([-0.0001 0.0001]) % select colorbar limit at end such that it properly resolves all experiments
     c = colorbar;
     c.FontSize = 10;

     titleText = sprintf('Runtime: %d %s',runtime(m+1),'min');
     title(titleText,'FontSize',12)
     supt=suptitle('Cumulative Divergence');
     supt.Position=[0.455 -0.048 0]; 
     supt.FontWeight='bold';

     filename=['8.Divergence_cum/Div',timeSteps(m+3).name,'.jpg'];
     print('-painters','-djpeg',QUAL,filename)
     close all
end   