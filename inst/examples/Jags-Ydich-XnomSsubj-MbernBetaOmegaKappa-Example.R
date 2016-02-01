# Example for Jags-Ydich-XnomSsubj-MbernBetaOmegaKappa.R 
#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
#graphics.off() # This closes all of R's graphics windows.
#rm(list=ls())  # Careful! This clears all of R's memory!
#------------------------------------------------------------------------------- 

JagsYdichXnomSsubjMbernBetaOmegaKapp <- function()
{
  out <- list()
  
  # Read The data file:
  out$myData = read.csv(system.file("data", "TherapeuticTouchData.csv", package = "dbda"))
  out$yName = "y" # column name for 0,1 values
  out$sName = "s" # column name for subject ID
  # Optional: Specify filename root and graphical format for saving output.
  # Otherwise specify as NULL or leave saveName and saveType arguments 
  # out of function calls.
  out$fileNameRoot = "Jags-Ydich-XnomSsubj-MbernBetaOmegaKappa-" 
  out$graphFileType = "eps"
  
  out$numSavedSteps = 20000
  out$thinSteps = 10
  
  oldClass(out) <- "JagsYdichXnomSsubjMbernBetaOmegaKapp"
  return(out)
}

mod <- JagsYdichXnomSsubjMbernBetaOmegaKapp()

#------------------------------------------------------------------------------- 
# # Read The data file:
# myData = read.csv("StormTressoldiDiRisio2010data.csv")
# yName = "Correct" # column name for 0,1 values
# sName = "Study" # column name for "subject" ID
# # Optional: Specify filename root and graphical format for saving output.
# # Otherwise specify as NULL or leave saveName and saveType arguments 
# # out of function calls.
# fileNameRoot = "StormTressoldiDiRisio2010-" 
# graphFileType = "eps" 
#------------------------------------------------------------------------------- 
# Load the relevant model into R's working memory:
#source("Jags-Ydich-XnomSsubj-MbernBetaOmegaKappa.R")
#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
mcmcCoda = genMCMC(mod, data=mod$myData , sName=mod$sName , yName=mod$yName , 
                    numSavedSteps=mod$numSavedSteps , saveName=mod$fileNameRoot , thinSteps=mod$thinSteps )
#------------------------------------------------------------------------------- 
# Display diagnostics of chain, for specified parameters:
parameterNames = varnames(mcmcCoda) # get all parameter names for reference
for ( parName in parameterNames[c(1:3,length(parameterNames))] ) { 
  diagMCMC( codaObject=mcmcCoda , parName=parName , 
                saveName=fileNameRoot , saveType=graphFileType )
}
#------------------------------------------------------------------------------- 
# Get summary statistics of chain:
summaryInfo = smryMCMC( mcmcCoda , compVal=0.5 , 
                        diffIdVec=c(1,14,28),  # Therapeutic touch
                        # diffIdVec=c(38,60,2),  # ESP Tressoldi et al.
                        compValDiff=0.0 ,
                        saveName=fileNameRoot )
# Display posterior information:
plotMCMC( mcmcCoda , data=myData , sName=sName , yName=yName , 
          compVal=0.5 , #rope=c(0.45,0.55) , # Therapeutic touch
          diffIdVec=c(1,14,28),              # Therapeutic touch
          # compVal=0.25 , #rope=c(0.22,0.28) , # ESP Tressoldi et al.
          # diffIdVec=c(38,60,2),               # ESP Tressoldi et al.
          compValDiff=0.0, #ropeDiff = c(-0.05,0.05) ,
          saveName=fileNameRoot , saveType=graphFileType )
#------------------------------------------------------------------------------- 
