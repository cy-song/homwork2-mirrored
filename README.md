# homwork2-mirrored

# Your Name <span style="color:red">(id)</span>
#宋展延 <span style="color:red">105061587</span>
# Project 2 / Panorama Stitching

## Overview
The project is related to 
> quote
在這一次的作業，我們要match SIFT keypoints從數個分開來的圖片來做出他原本一張的全景圖片。
在生活中有運用在全景拍照或智慧型手機和 stitching software such as Photosynth and AutoStitch上面

* Detect SIFT points and extract SIFT descriptor for each keypoint in an image using vlfeat.

* Compare two sets of SIFT descriptors coming from two different images and find matching keypoints (SIFTSimpleMatcher.m).

* Given a list of matching keypoints, use least-square method to find the affine transformation matrix that maps positions in image 1 to positions in image 2 (ComputeAffineMatrix.m).

* Use RANSAC to give a more robust estimate of affine transformation matrix (RANSACFit.m).

* Given that transformation matrix, use it to transform (shift, scale, or skew) image 1 and overlay it on top of image 2, forming a panorama. 

## Implementation
1. Matching SIFT Descriptors
 計算歐式距離，再由小到大排序找到最小和第二小做match 計算，用EvaluateSIFTMatcher.m確認正確
Match one set of SIFT descriptors (descriptor1) to another set of descriptors (decriptor2).
Each descriptor from descriptor1 can at most be matched to one member of descriptor2, but descriptors from 
descriptor2 can be matched more than once.
Matches are determined as follows:
For each descriptor vector in descriptor1, find the Euclidean distance
between it and each descriptor vector in descriptor2. If the smallest
distance is less than thresh*(the next smallest distance), we say that
the two vectors are a match, and we add the row [d1 index, d2 index] to
the "match" array.
```
n1 = length(descriptor1(:,1)); 
n2 = length(descriptor2(:,1));
for i=1:n1
dcolumn1=descriptor1(i,:);
d1=repmat(dcolumn1,n2,1);
d2=descriptor2;
Euc=sqrt(sum((d1-d2).^2,2));
[minvalue,minindex]=min(Euc);
sortvector=sort(Euc);
if minvalue<thresh*sortvector(2)
match=[match;[i,minindex]];
end
end
```

2 . Fitting the Transformation Matrix
We will use this to find a transformation matrix that maps an image 1 point to the corresponding coordinates in image 2. 
With a sufficient number of points, MATLAB can solve for the best H for us.ComputeAffineMatrix computes the transformation matrix that transforms a point from coordinate frame 1 to coordinate frame 2
跑EvaluateAffineMatrix.m to check your implementation. 結果正確
```
H=(P1'\P2')'
```
3 . RANSAC
Use RANSAC to find a robust affine transformation.Compute the error 
using transformation matrix H to transform the point in pt1 to its matching point in pt2.
跑TransformationTester.m 測試正確
```
dists = zeros(size(match,1),1);
n=size(match,1);
pt1match=pt1(match(:,1),:);
pt2match=pt2(match(:,2),:);
transpose_P1=pt1match';
transpose_P2=pt2match';

p1=[transpose_P1;ones(1,n)]; %
p2=[transpose_P2;ones(1,n)]; % 
transform_pt1=p1'*H'
d=sum((transform_pt1-p2').^2,2);
dists=d.^0.5;
```
4.Stitching Multiple Images
our code takes every neighboring pair of images and computes the transformation matrix which converts points from the coordinate frame of \(Img_i\) to the frame of \(Img_{i+1}\).We want our final panorama image to be in the coordinate frame of \(Img_r\).
we need a transformation matrix that will convert points in frame i to frame ref. 
跑TransformationTester.m 來測試我們的code 正確
```
T=eye(3);
if currentFrameIndex<refFrameIndex
for i=currentFrameIndex:refFrameIndex-1
T=i_To_iPlusOne_Transform{i}*T;
end
end
if currentFrameIndex >refFrameIndex
for i=refFrameIndex:currentFrameIndex-1
T=i_To_iPlusOne_Transform{i}*T;
end
T=pinv(T);
end
```

## Installation
* Other required packages.
VLFeat 0.9.17 binary package. We are only using the vl_sift function. VL Feat Matlab reference: http://www.vlfeat.org/matlab/matlab.html
* How to compile from source?
We can type addpath on common windows the position of vl_setup.m 
or open vl_setup.m to run it in matlab.
Then we can operate vl_sift function in TransformationTester.m 



#### Results
<table border=1>

<tr>
<td>
*人社院 李存敏館和工科館的原圖
<img src="c1.jpg" width="24%"/>
<img src="c2.jpg" width="24%"/>
<td>
<tr>
<tr>
<td>

panoramic image

<img src="c.jpg" width="24%"/>

<td>
<tr>


<table border=1>

*李存敏館和工科館駐警隊的原圖
<tr>
<td>

<img src="campus1.jpg" width="24%"/>
<img src="campus2.jpg" width="24%"/>

<td>
<tr>
<table border=1>
panoramic image
<tr>
<td>

<img src="campus.png" width="24%"/>
<td>
<tr>










<table border=1>
- 以下是各種的影像panoramic image 合成照，程式結果
<tr>
<td>
<img src="Hanging.jpg" width="24%"/>
<img src="MelakwaLake.jpg" width="24%"/>
<img src="Rainier.jpg" width="24%"/>
<img src="uttower.jpg" width="24%"/>
</td>
</tr>

<tr>
<td>
<img src="c.jpg" width="24%"/>
<img src="campus.png" width="24%"/>
<img src="evaluatesiftmatcher result.JPG" width="24%"/>
<img src="EvaluateAffineMatrix result.JPG" width="24%"/>

</td>
</tr>

</table>
