%% Plots elevation data produced by MicMac 
close all;

QUAL=['-r600']; %set image quality
set(0,'defaulttextinterpreter','latex')
N = numel(timeSteps);

x=x+0.026;  %shift x and y values to account for GCP offset from the box corners 
y=y-0.011;  %depends on the cropping parameters used in the MicMac workflow

% %time corresponding to the time steps in minutes
t1=[0:1:30]';
t2=[35:5:185]'; % length varies for single experiments
runtime=[t1;t2];
% %load colormap 
RdWBu=load('RdWBu');
RdWBu=RdWBu.RdWBu;

%% DEM evolution

figDEM = figure;
mkdir('11.DEM')
cmin_DEM =-22;           %set uniform color scale for all experiments (in mm)
cmax_DEM =cmin_DEM*(-1);    

for n = 1:N-3
  imagesc(x,y,(squeeze(DEM(n,:,:))).*1000), axis equal, axis tight  %plot elevation in mm
  ax = gca;
  axis([0.025 0.325 0.025 0.325]);
  ax.XTick = [0.05 0.1 0.15 0.2 0.25 0.3];
  ax.YTick = [0.05 0.1 0.15 0.2 0.25 0.3 ];
  ax.XTickLabel = {'5','10','15','20','25','30'};
  ax.YTickLabel = {'30','25','20','15','10','5'};
  ax.XLabel.String = 'x [cm]';
  ax.YLabel.String = 'y [cm]';
  ax.XLabel.FontSize = 12;
  ax.YLabel.FontSize = 12;
 
  colormap(ax,RdWBu);
  caxis([cmin_DEM cmax_DEM])
  c = colorbar;
  c.FontSize = 10;
  c.Label.String = '[mm]';
  c.Label.Position=[0.567901335380696 25.4865838732901 0];
  c.Label.Rotation = 0;
  c.Label.FontSize = 11;

  titleText = sprintf('Runtime: %d %s',runtime(n),'min');  %prints runtime of current figure
  title(titleText,'FontSize',12)  
  supt=suptitle('DEM');
  supt.Position=[0.455 -0.048 0]; 
  supt.FontWeight='bold';

% print experiment parameters in figure, change for each experiment
  annotation(gcf,'textbox',[0.609 0.0994762 0.1357 0.138095],'String',{'100 % GB','D=65 mm','H=80 mm'},...
  'LineStyle','none','HorizontalAlignment','center','FontSize',9);
  filename=['11.DEM/DEM_',timeSteps(n+2).name,'.jpg'];
  print('-painters','-djpeg',QUAL,filename)

  close all
end
%% U_DEM evolution

runtime(1)=[]; % U_DEM's start at 1 min and not 0

figU_DEM = figure; 
mkdir('12.UDEM')

cmin_DEM =-22;           %set uniform color scale for all experiments (in mm)
cmax_DEM =cmin_DEM*(-1);   

for n =1:N-3
  imagesc(x,y,(squeeze(U_DEM(n,:,:)).*1000)), axis equal, axis tight %plot elevation change in mm
  ax = gca;
  axis([0.025 0.325 0.025 0.325]);
  ax.XTick = [0.05 0.1 0.15 0.2 0.25 0.3];
  ax.YTick = [0.05 0.1 0.15 0.2 0.25 0.3 ];
  ax.XTickLabel = {'5','10','15','20','25','30'};
  ax.YTickLabel = {'30','25','20','15','10','5'};
  ax.XLabel.String = 'x [cm]';
  ax.YLabel.String = 'y [cm]';
  ax.XLabel.FontSize = 12;
  ax.YLabel.FontSize = 12;
  
  colormap(ax,RdWBu);
  caxis([cmin_DEM cmax_DEM])
  c = colorbar;
  c.FontSize = 10;
  c.Label.String = '[mm]';
  c.Label.Position=[0.567901335380696 25.4865838732901 0];
  c.Label.Rotation = 0;
  c.Label.FontSize = 11;
  colormap(ax,RdWBu);
  
  titleText = sprintf('Runtime: %d %s',runtime(n),'min');  %prints runtime of current figure
  title(titleText,'FontSize',12)
  supt=suptitle('$\Delta$DEM');
  supt.Position=[0.455 -0.048 0]; 
  supt.FontWeight='bold';

% print experiment parameters in figure, change for each experiment
  annotation(gcf,'textbox',[0.609 0.0994762 0.1357 0.138095],'String',{'100 % GB','D=65 mm','H=80 mm'},...
  'LineStyle','none','HorizontalAlignment','center','FontSize',9);
  filename=['12.UDEM/UDEM_',timeSteps(n+3).name,'.jpg'];
  print('-painters','-djpeg',QUAL,filename)
  close all
end