# Jags-Ydich-Xnom1subj-MbernBetaModelComp.R
# Accompanies the book:
#   Kruschke, J. K. (2014). Doing Bayesian Data Analysis: 
#   A Tutorial with R, JAGS, and Stan. 2nd Edition. Academic Press / Elsevier.


JagsYdichXnom1subjMbernBetaModelComp <- function()
{
  out <- list()
  
  oldClass(out) <- "JagsYdichXnom1subjMbernBetaModelComp"
  return(out)
}

mod <- JagsYdichXnom1subjMbernBetaModelComp()

#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
codaSamples <- genMCMC(mod)
  
#------------------------------------------------------------------------------- 
# Display diagnostics of chain:

parameterNames = varnames(codaSamples) # get all parameter names
for ( parName in parameterNames ) {
  diagMCMC( codaSamples , parName=parName)
}

#------------------------------------------------------------------------------
# EXAMINE THE RESULTS.

plotMCMC(mod, codaSamples)
