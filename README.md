# MUCT Cropped dataset

This is a cropped version of the MUCT dataset - www.milbo.org/muct.

## Original dataset

The original samples can be downloaded from the website of MUCT. 

## Cropped version

We cropped the image samples, using MATLAB, based on the landmarks provided by MUCT.

## Used as an imbalanced dataset

1. Download the image samples, where some of them have 3x5=15 samples, and the others have only 2x5=10 samples;
2. Load the dataset with the MATLAB script. 

```  
loadMUCTCrop.m % gray-scale data
%loadMUCTCropRGB.m % RGB data
numOfTrain=8; % 1 - 8 
prepareTrainData; % split data to training and testing set
```  

## Used the objects with 3x5=15 samples

1. Download the image samples, where all of them have 3x5=15 samples;
2. Load the dataset with the MATLAB script. 

```  
loadMUCTCropo3.m % gray-scale data
%loadMUCTCropRGBo3.m % RGB data
numOfTrain=10; % 1 - 10 
prepareTrainData; % split data to training and testing set
```  

## Using deep features extracted via FaceNet

```  
loadMUCTCrop.m % gray-scale data
%loadMUCTCropRGB.m % RGB data
numOfTrain=8; % 1 - 8 
%loadMUCTCropo3.m % gray-scale data
%loadMUCTCropRGBo3.m % RGB data
%numOfTrain=10; % 1 - 10 
prepareTrainDataDeep; % split data to training and testing set
```  

The tool to extract deep features via FaceNet can be found in https://github.com/zengsn/facenet .

## Please cite our work, as well as the original MUCT

```   
@article{Milborrow10,
  author ={S. Milborrow and J. Morkel and F. Nicolls},
  title  ={{The MUCT Landmarked Face Database}},
  journal={Pattern Recognition Association of South Africa},
  year   =2010,
  note   ={\url{http://www.milbo.org/muct}}
}

@misc{Zeng2018,
  author = {Shaoning, Zeng},
  title  = {The Cropped MUCT Landmarked Face Database},
  month  = jun,
  year   = {2018},
  url    = {https://github.com/zengsn/muct-cropped/}
}
```  

## Benchmark work

[1] Pose and illumination variable face recognition via sparse representation and illumination dictionary, 2016  
[2] Integration of multiple soft biometrics for human identification, 2015  
[3] Fusion of lattice independent and linear features improving face identification, 2013  
[4] Our work (96+%), 2018, to be published.   
