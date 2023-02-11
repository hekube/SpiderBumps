### Spider Bumps - sample programs
### hekube- February 2023
      
rm(list=ls())

library(mclust)
library(parallel)
library(EBImage)
library(EBImageExtra)
library(rgl)


#############################################################
###  Quick start with the Flury RiedWyl banknote example  ###
#############################################################
### load data
data(banknote)
B=banknote
### prepare data
DL=dataLimits(as.data.frame(B[,-1])) ### exclude variable "Status")
### call wrapper
spiderBump(DL)


################################################
###  The detailed way with the same example  ###
################################################
### call function raster
M=raster(DL)

### calculate matrix S
S=Reduce("+",M)

### display S with RGL
z=t(S[nrow(S):1,]) ### reverse rows so that variable 1 is on top
x=1:nrow(z)
y=1:ncol(z)
persp3d(x,y,z,box=FALSE,col="#BB2649") ### Pantone's viva magenta
aspect3d(1,1,0.33)
clear3d(type = "lights")
light3d(ambient="white",diffuse = "white", specular = "black")


##########################################################################
###  Mount Fuji - simulated with uniformly distributed random numbers  ###
##########################################################################
nC=1000 ### number of cases
nV=50   ### number of variables
set.seed(123)
H=as.data.frame(matrix(runif(nC*nV),nrow=nC,ncol=nV))
gleich=list(D=H,
            a=rep(0,nV),
            b=rep(1,nV)
           )
spiderBump(gleich,n=51)


