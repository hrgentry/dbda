# Example for Jags-Ydich-XmetMulti-Mznormal.R
#------------------------------------------------------------------------------- 

#------------------------------------------------------------------------------- 
# Data

ilogit <- function(x) 1 / (1 + exp(-x))
iprobit <- binomial(link="probit")$linkinv
ithresh <- function(x, thresh = 0) 1 - pnorm(thresh, x, 1)

set.seed(1)
N <- 500

b0 <- 0
b1 <- 4

x <- runif(N)
x <- (x - mean(x)) / sd(x)

mu1 <- ilogit(b0 + b1*x)
mu2 <- iprobit(b0 + b1*x)
mu3 <- ithresh(b0 + b1*x)
 
y1 <- rep(NA, N)
y2 <- rep(NA, N)
y3 <- rep(NA, N)
for(i in 1:length(x)) {
  y1[i] <- sample(c(0, 1), size = 1, prob = c(1 - mu1[i], mu1[i]))
  y2[i] <- sample(c(0, 1), size = 1, prob = c(1 - mu2[i], mu2[i]))
  y3[i] <- sample(c(0, 1), size = 1, prob = c(1 - mu3[i], mu3[i]))
}

dat <- data.frame(x = x, 
  y1 = y1, y2 = y2, y3 = y3,
  mu1 = mu1, mu2 = mu2, mu3 = mu3)

myData <- dat
#myData$y1 <- as.factor(y1)
#myData$y2 <- as.factor(y2)

xName = "x"; yName = "y3"
numSavedSteps = 5000; thinSteps = 1

#------------------------------------------------------------------------------- 
# Model

JagsYdichXmetMultiMznormal <- function()
{
  out <- list()
  oldClass(out) <- "JagsYdichXmetMultiMznormal"

  return(out)
}

mod <- JagsYdichXmetMultiMznormal()

#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
mcmcCoda = genMCMC(mod, data=myData , xName=xName , yName=yName , 
                    numSavedSteps=numSavedSteps , thinSteps=thinSteps , 
                    saveName=fileNameRoot )

##
codaSamples <- mcmcCoda

mcmcMat <- as.matrix(codaSamples, chains = TRUE)
chainLength = NROW( mcmcMat )
thresh  = mcmcMat[,grep("^thresh",colnames(mcmcMat))]
zbeta0 = mcmcMat[,"zbeta0"]
zbeta  = mcmcMat[,grep("^zbeta$|^zbeta\\[",colnames(mcmcMat))]
beta0 = mcmcMat[,"beta0"]
beta  = mcmcMat[,grep("^beta$|^beta\\[",colnames(mcmcMat))]



#------------------------------------------------------------------------------- 
# Plot
#plotMCMC(mod, mcmcCoda, myData, xName = "x", yName = "y1", showCurve = F) 
