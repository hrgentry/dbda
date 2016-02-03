# Example for Jags-Ydich-XnomSsubj-MbinomBetaOmegaKappa.R 
#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
#graphics.off() # This closes all of R's graphics windows.
#rm(list=ls())  # Careful! This clears all of R's memory!
#------------------------------------------------------------------------------- 


JagsYdichXnomSsubjMbinomBetaOmegaKappa <- function()
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
  
  out$numSavedSteps = 1000 # 20000
  out$thinSteps = 10
  
  oldClass(out) <- "JagsYdichXnomSsubjMbinomBetaOmegaKappa"
  return(out)
}

mod <- JagsYdichXnomSsubjMbinomBetaOmegaKappa()


#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
startTime = proc.time()
out = genMCMC(mod,  data=mod$myData , sName=mod$sName , yName=mod$yName , 
                    numSavedSteps=mod$numSavedSteps , saveName=mod$saveName ,
                    thinSteps=mod$thinSteps )
stopTime = proc.time()
show( stopTime-startTime )

stop()

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
                        diffIdVec=c(1,14,28), compValDiff=0.0, 
                        saveName=fileNameRoot )
# Display posterior information:
plotMCMC( mcmcCoda , data=myData , sName="s" , yName="y" , 
          compVal=0.5 , #rope=c(0.45,0.55) ,
          diffIdVec=c(1,14,28), compValDiff=0.0, #ropeDiff = c(-0.05,0.05) ,
          saveName=fileNameRoot , saveType=graphFileType )
#------------------------------------------------------------------------------- 
