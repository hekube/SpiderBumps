### Spider Bumps - functions
### hekube - February 2023


dataLimits <- function(D){
###   dataLimits creates the list DL=list(D,a,b)
###   with D as data.frame containing the spider web variables
###   and automatically calculated limtit vectors a and b.
###
    list(D=D,
         a=apply(D,2,min),
         b=apply(D,2,max)
    )
}


raster <- function(DL,n=101,mc=10){
### creates a list of matrices, one for each case.
### The matrices are rasters representing the pylogon
### defined by the variable values.
###
    D=as.data.frame(t(DL$D))
    a=DL$a
    b=DL$b

    k=nrow(D)

    r=(n-1)/2  ### distance from origin to margin
    o=(n+1)/2  ### offset

    mclapply(D,
        function(d){
            ### d is a case data vector
            ### process each variable = component of d
            ### 1. position on polar axis for radius = 1
            ### 2. conversion to euclidian coordinates
       
            ### modules and distances from
            ### origin of polar coordinates
            alpha=2*pi/k;
            phi=seq(from=pi/2,by=alpha,length.out=k) ## increasing seq = counterclockwise variable arrangement
            mu=1/(b-a) ### modules for radius = axis length = 1
            p=mu*(d-a) ### positions on polar axis = distances from origin

            ### euclidian coordinates
            ex=p*cos(phi);
            ey=p*sin(phi);

            ### vertices on raster (integers)
            ### component names x and y are required
            ### by function pnpoly
            V=list(
                x=round( ex*r)+o, ### here r=(n-1)/2 is used as the distance from the
                y=round(-ey*r)+o  ### center to margin of the raster and the offest o=(n+1)/2
            )
       
            ### polygon filling
            Q=expand.grid(x=1:n,y=1:n)
            matrix(as.numeric(pnpoly(Q,V)),nrow=n,ncol=n,byrow=TRUE)
        },
        mc.cores=mc
    )
}
   
  
kompakt <- function(A){
### displays a matrix with columns narrower than with function print.
### kompakt is only useful for small matrices with single digit elements.
    for (i in 1:nrow(A)) {
        for (j in 1:ncol(A)) {
            cat(A[i,j]," ")
        }
        cat("\n")
    }
}
  
   
spiderBump <- function(DL,n=101,mc=10,height=0.33,col="#BB2649"){
    G=raster(DL,n,mc)
    S=Reduce("+",G)
    z=t(S[nrow(S):1,]) ### reverse rows so that variable one is on top
    x=1:nrow(z)
    y=1:ncol(z)
    persp3d(x,y,z,box=FALSE,col=col)
    aspect3d(1,1,height)
    clear3d(type = "lights")
    light3d(ambient="white",diffuse="white",specular="black")
}