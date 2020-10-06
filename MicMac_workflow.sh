#!/bin/bash

# Input and user preferences
BOX='[0.05,0.05,0.3,0.3]' # set cropbox size/ select area of interest
DIR="000"
NrofIm="61" # Set number of timesteps

# DATA I/O Structure
DIR_INPUT="../input/$DIR"
DIR_OUTPUT="../output/$DIR"

# KEY FILES FOR PROCESSING
ORT="1.JPG" # Image to base orthophoto on
IMG=".*.JPG" # CHOOSE ALL IMAGES
DIC="GCP.xml" # FILE WITH GCP MEASUREMENTS
MES="Measure-S2D.xml" # GCPS MEASURED IN PHOTOS
XML="MEC-Malt/NuageImProf_STD-MALT_Etape_9.xml" # XML Nuage info for creating point cloud
ZLIM="MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml" # Raw DEM scale info
ZLIMMASKTIF="MEC-Malt/Z_Num9_DeZoom1_STD-MALT_MasqZminmax.tif" # MASKED DEM
TIF="Ortho-MEC-Malt/Ort_1.tif" # ORTHOPHOTO 
IMGinit="1.JPG"
[ -d output ] || mkdir output

# Prepare temporary working folder
mkdir tmp
cd tmp
cp $DIR_INPUT/* ./
cp ../Measure-S2D.xml Measure-S2D.xml
cp ../Measure-S3D.xml Measure-S3D.xml
cp ../GCP.xml GCP.xml

# Calculate tie points
mm3d Tapioca All $IMG -1 @SFS

# Calculate internal and external distortion
mm3d Tapas FraserBasic $IMG Out=G ImInit="$IMGinit"
mm3d AperiCloud $IMG G Out=RelOri.ply


# MEASURE GCPS

mm3d GCPBascule $IMG G TG $DIC $MES # CONVERT Arbitrary to Absolute orientation G->TG
mm3d Campari $IMG TG TGC #GCP=[GCP.xml,0.2,Measure-S2D.xml,0.5]  # Bundle Adjustment TG->TGC
mm3d AperiCloud $IMG TGC Out=AbsOri.ply

# Calculate orthophoto, DEM and pointcloud
mm3d Malt Ortho $IMG TGC ZoomF=1 ImOrtho=$ORT BoxTerrain=$BOX Regul=0.005 SzW=3

mm3d Zlimit $ZLIM -0.30 0.10 #Masks point cloud from min to max range

mm3d Nuage2ply $XML Mask=$ZLIMMASKTIF Attr=$TIF Out=OrthoPointCloudMasked.ply # Masked Point Cloud
mm3d Nuage2ply $XML Attr=$TIF Out=OrthoPointCloud.ply # Unmasked Point Cloud

# Collate output
[ -d $DIR_OUTPUT ] || mkdir $DIR_OUTPUT
mv Ortho-MEC-Malt/Ort_1.tif $DIR_OUTPUT/ORT.tif #Copy Orthophoto to Output
mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml $DIR_OUTPUT/DEM.xml #Copy raw DEM scale info
mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.tif $DIR_OUTPUT/DEM.tif  #Copy raw DEM

cp OrthoPointCloud.ply $DIR_OUTPUT/ORT_nonmasked.ply #Copy HighRes Pointcloud
cp OrthoPointCloudMasked.ply $DIR_OUTPUT/ORT_masked.ply #Copy HighRes Masked Pointcloud

mv RelOri.ply $DIR_OUTPUT/CAM_Rel.ply # copy sparse point cloud in relative orientation
mv AbsOri.ply $DIR_OUTPUT/CAM_Abs.ply # copy sparse point cloud in absolute orientation
cp -R Ori-TGC $DIR_OUTPUT/Ori-TGC # Copy calibration and distortion
cp MEC-Malt/Correl_STD-MALT_Num_8.tif $DIR_OUTPUT/CorrMap.tif #Copy correlation map
# Clear space and prepare next
cd ..
rm -R tmp

DIR_PRE=$DIR_OUTPUT
DIR_INI=$DIR_PRE

# START OF LOOP

for N in `seq 1 $NrofIm`; do 
    
    Input and user preferences
    DIR="$(echo 00${N} | tail -c4)"
    DIR_INPUT="../input/$DIR"
    DIR_OUTPUT="../output/$DIR"
    
    echo $DIR
    echo $DIR_INPUT
    echo $DIR_OUTPUT

    # Prepare temporary working folder
    mkdir tmp
    cd tmp
    cp $DIR_INPUT/* ./                 # Imagery
    cp -R $DIR_INI/Ori-TGC ./          # Distortion model
    
    # Calculate orthophoto, DEM and pointcloud
    mm3d Malt Ortho $IMG TGC ZoomF=1 ImOrtho=$ORT BoxTerrain=$BOX Regul=0.005 SzW=3
    mm3d Zlimit $ZLIM -0.30 0.10 #Masks point cloud from min to max range

    mm3d Nuage2ply $XML Mask=$ZLIMMASKTIF Attr=$TIF Out=OrthoPointCloudMasked.ply # Masked Point Cloud
    mm3d Nuage2ply $XML Attr=$TIF Out=OrthoPointCloud.ply # Unmasked Point Cloud
    # Collate output
    [ -d $DIR_OUTPUT ] || mkdir $DIR_OUTPUT
    mv Ortho-MEC-Malt/Ort_1.tif $DIR_OUTPUT/ORT.tif
    mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.xml $DIR_OUTPUT/DEM.xml
    mv MEC-Malt/Z_Num9_DeZoom1_STD-MALT.tif $DIR_OUTPUT/DEM.tif
    cp OrthoPointCloud.ply $DIR_OUTPUT/ORT_nonmasked.ply #Copy HighRes Pointcloud
    cp OrthoPointCloudMasked.ply $DIR_OUTPUT/ORT_masked.ply #Copy HighRes Masked Pointcloud
    cp MEC-Malt/Correl_STD-MALT_Num_8.tif $DIR_OUTPUT/CorrMap.tif #Copy correlation map    
    # Calculate displacement
    cp $DIR_PRE/ORT.tif ORT1.tif
    cp $DIR_OUTPUT/ORT.tif ORT2.tif
    
    mm3d MM2DPosSism ORT1.tif ORT2.tif Reg=0.005 Inc=4.0
    
    # Collate output    
    mv MEC/Px1_Num6_DeZoom1_LeChantier.tif $DIR_OUTPUT/U_X.tif
    mv MEC/Px2_Num6_DeZoom1_LeChantier.tif $DIR_OUTPUT/U_Y.tif
    mv MEC/Z_Num6_DeZoom1_LeChantier.xml $DIR_OUTPUT/INF.xml 
        
    
    # Clear space and prepare next
    cd ..
    rm -R tmp
    DIR_PRE=$DIR_OUTPUT

done

exit 0