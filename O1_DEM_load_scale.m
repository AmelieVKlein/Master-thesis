%Load and scale elevation data produced with MicMac

% code has been modified from the original developed by:
% H. S. Bertelsen    haavasb@fys.uio.no           2015
% F.B.B. Guldstrand  f.b.b.guldstrand@geo.uio.no  2017

clc; clear all; close all;
%% Input
rootFolder = 'exp3_repeat_output/';
timeSteps = dir(rootFolder);

xMin = 0.05;            % Bounding box coordinates in meters
xMax = 0.3;
yMin = 0.05;
yMax = 0.3;

% Thresholds for removing outliers:
thresholdDEM = 0.2;    % Cut off limit DEM in meters, adapt based on data
thresholdU = 0.2;      % Cut off limit displacement in meters                     
%% Initialize
% Extract scaling parameters from XML
folderName = strcat(rootFolder,timeSteps(3).name,filesep);
pathXML = strcat(folderName,'DEM.xml');
tagName = 'OrigineAlti';
originAlti = parseXML(pathXML,tagName);
tagName = 'ResolutionAlti';
resolutionAlti = parseXML(pathXML,tagName);
tagName = 'NombrePixels';
nPixels = parseXML(pathXML,tagName);
nPxlCol = nPixels(1);
nPxlRow = nPixels(2);

% Figure scaling
x = xMin:(xMax-xMin)/(nPxlCol-1):xMax;
y = yMin:(yMax-yMin)/(nPxlRow-1):yMax;

% Allocate memory to variables
M = length(timeSteps)-3;                
DEM = zeros(M,nPxlRow,nPxlCol); 
U_DEM = zeros(M-1,nPxlRow,nPxlCol);
%% Load and format elevation and displacement data
for m = [1:62]
    folderName = strcat(rootFolder,timeSteps(m+2).name,filesep);
    
    %%% DEM
    imgName = strcat(folderName,'DEM.tif');
    img = imread(imgName);
    img = double(img) * resolutionAlti + originAlti;

    if m == 1
    initElevation = nanmean(nanmean(img));  % define mean initial elevation as reference
    end
    img = img - initElevation;
    img(img < -thresholdDEM | img > thresholdDEM) = NaN;
    dem = img;
    DEM(m,:,:) = img;

    if m > 1  
    %%% delta DEM
    U_DEM(m-1,:,:) = DEM(m,:,:) - DEM(1,:,:); % total elevation change i.e. with respect to initial surface
    Corners_n = squeeze((U_DEM(m-1,10:50,10:50) + U_DEM(m-1,end-49:end-9,10:50) + U_DEM(m-1,10:50,end-49:end-9) + U_DEM(m-1,end-49:end-9,end-49:end-9))) / 4;
    Ushift = mean(Corners_n(:));
    U_DEM(m-1,:,:) = U_DEM(m-1,:,:) - Ushift;
    %U_DEM(m-1,:,:) = DEM(m,:,:) - DEM(m-1,:,:); %incremental change wrt time step before
    end
end

clearvars -except timeSteps x y DEM U_DEM  
