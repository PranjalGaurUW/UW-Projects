  # install.packages("ggplot2")
  #install.packages("lmtest")
  #install.packages("reshape2")
  #install.packages("Hmisc")
#install.packages("descr")
library("descr")
  library(foreign)
  library(lmtest)
  library(ggplot2)
  library(MASS)
  library(Hmisc)
  library(reshape2)
  dat <- read.csv("/Users/pranjalgaur/1. UW Courses/609/Pranjal_TermPaper_OLS/Model 4/Model 4-Filtered.csv")
  head(dat)
  hist(dat$HR_10,probability=T, main="Histogram of DV",xlab="HR_10")
  lines(density(dat$HR_10),col=2)
  
 crosstab(dat$HR_10, dat$PTC_05E, chi_square = TRUE)
  
  # Scatterplot(dat$HR_10, dat$PTC_05E, data=dat,
  #      xlim=c(0,10) , ylim=c(0,10), 
  #      pch=18, 
  #      cex=2, 
  #      col="#69b3a2",
  #      xlab="HR_10", ylab="HR_05C",
  #      main="Scatterplot"
  # )
  
  
 hist(dat$PEDUC_LC, xlab="PEDUC_LC", ylim=c(0, 1000), main="Histogram of PEDUC_LC (IV)", border="black", col=rgb(0.662,0.737,0.431))
 hist(dat$HR_10, xlab="HR_10", main="Histogram of HR_10 (DV)", border="black", col=rgb(0.513, 0.69, 0.76))
 hist(dat$HR_05C, xlab="HR_05C",main="Histogram of HR_05C (IV)", border="black", col=rgb(0.513, 0.69, 0.76))
 hist(dat$FCR_05, xlab="FCR_05", main="Histogram of FCR_05 (IV)", border="black", col=rgb(0.662,0.737,0.431))
 hist(dat$PTC_05E, xlab="PTC_05E", main="Histogram of PTC_05E (IV)", border="black", col=rgb(0.8,0.737,0.431))
  
  
  
  x1=dat$RURURB
  x2=dat$SEX
  x3=dat$AGEGRP
  hist(dat$PEDUC_LC, xlab="PEDUC_LC", ylim=c(0, 1000), main="Histogram of PEDUC_LC (IV)", border="black", col="purple")
  hist(x1, col="yellow", xlim=c(0, 7),border="black",
  xlab='Variables', ylab='Frequency', main='Histogram for control variables')
  hist(x2, col="blue",border="black", add=TRUE)
  hist(x3, col="red",border="black", add=TRUE)
  
  # shapiro.test(dat$HR_10)
  cor.test(dat$HR_10, dat$HR_05C, method="spearman", exact=FALSE)
  cor.test(dat$HR_10, dat$FCR_05, method="spearman", exact=FALSE)
  cor.test(dat$HR_10, dat$PTC_05E, method="spearman", exact=FALSE)
  cor.test(dat$HR_10, dat$PEDUC_LC, method="spearman", exact=FALSE)