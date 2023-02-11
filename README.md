# SpiderBumps
3D-display of many overlapping spider web diagrams (radar plots).

HOW TO CREATE SPIDER BUMPS
--------------------------
hekube - February 2023


Content
--------
- prepare data
- call function raster
- calculate Matrix S
- display S with rgl
- helper
- prerequisites
- note for Windows users

Prepare data
------------
Create a list (here called DL) including a data frame D and vectors a and b.
D has a row per case and k variables which define the spider webs of the cases.

The vectors a and b have length k. The elements correspond with the variables as
they stand from left to right in D. The vector a includes the smallest and the
vector b the biggest values of the axes of the spider web. Use function dataLimits(D)
with D as data.frame to create the list with automatically calculated limits.


Call function raster
--------------------
Function raster "draws" the spider web of each single case into a matrix, here called M.
A spider web in matrix M is presented as a filled polygon. Its vertices are derived from
the data of the cases. The elements of M are equal to 1 or 0, depending whether the
spider web covers the matrix element. The vertex of the first variable is on top. All others
follow counterclockwise. A clockwise arrangement can be achieved by reversing the sequence
of the columns in the data set. The number of rows and columns of M, determined by parameter n,
define the resolution of the raster. n MUST be odd.

Function raster calculates the polar coordinates for the cases considering the axes parameters
a and b. Then, the polar coordinates are transformed to Euclidian coordinates, which are finally
mapped to the raster.

Euclidian coordinate system with values for 4 variables.
```
+y . . . | . . .
   . . . | o . .
   . o . | . . .
   - - - + - - -
   . . o | . . .
   . . . | . o .
-y . . . | . . .
  -x          +x
```
Raster with resolution n=7 and 4 vertices x, corresponding with the values o.
```
   1 2 3 4 5 6 7
1  . . . . . . .
2  . . . . x . .
3  . x . . . . .
4  . . . . . . .
5  . . x . . . .
6  . . . . . x .
7  . . . . . . .
```
Filling the polygon described by the vertices is done with function pnpoly (cf.
https://wrfranklin.org/Research/Short_Notes/pnpoly.html). The R-implementation is
from https://github.com/ornelles/EBImageExtra/.

The application of pnpoly could be easily realized but this is not an efficient solution.
The program would be much faster with the scanline polygon filling algorithm. However, this
not an issue if function raster runs in parallel (batches of cases on different cores).

The spider web of a single case is "drawn" into the matrix M as a filled
polygon, where the data of the cases are the vertices. The elements of M are
equal to 1 or 0, depending whether the spider web covers the matrix element.
```
. . . . . . .
. . . 1 1 . .
. 1 1 1 1 . .
. . 1 1 1 . .
. . 1 1 1 1 .
. . . . 1 . .
. . . . . . .
```

Calculate matrix S
------------------
S is the sum of matrices M for all cases. The Elements of S are the numbers of
overlapping spider webs.
```
. . . . . . .
. . . 1 1 . .
. 1 2 2 1 1 .
. 2 4 5 4 2 .
. 2 3 3 2 1 .
. . 2 2 1 . .
. . . . . . .
```

Display S with rgl
------------------
```
z=t(S[nrow(S):1,]) ### reverse rows so that variable 1 is on top, bot on bottom
x=1:nrow(z)
y=1:ncol(z)
persp3d(x,y,z,box=FALSE,col=rgb(102,103,171,maxColorValue=255))
aspect3d(1,1,0.5)
```

Helper
------
The list DL can be created automatically using function dataLimits
If "data" is the name of the data.frame including the data, just call
DL=dataLimits(data), then the vectors a and b include the minima and maxima
of the corresponding variables.

Function spiderBump(DL) is a wrapper to do all calculations and the display with rgl.

Function kompakt(<matrix>) shows the matrices stored in the output of raster
in a compact form. It is only useful for small matrices with 1-digit elements.


Prerequisites
-------------
Package EBImage is from Bioconductor. If not done earlier, do the next two steps:
```
install.packages("BiocManager")
BiocManager::install("EBImage")
```
Package EBImageExtra is from github. If not done earlier, do the next two steps:
```
install.packages("devtools")
library(devtools)
install_github("ornelles/EBImageExtra")
```
Package rgl is from CRAN.


Note for Windows users
----------------------
Function raster uses function mclapply from package parallel. This may not work under Windows.
Windows users may replace mclappy by function lapply.

