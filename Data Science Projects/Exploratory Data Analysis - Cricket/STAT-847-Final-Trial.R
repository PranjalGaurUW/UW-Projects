library(ggplot2)
library(tidyverse)
library(reshape)
library(prob)
library(syuzhet)
library(plyr)

match_data= read.csv("Gamelog T20I Stat 847.csv")
head(match_data)
dim(match_data)

data1=match_data

sort(unique(match_data$MatchNo))
summary(match_data$NumOutcome)

################################################## data cleaning #########################

rowsToExclude=which(data1$NumOutcome==2015)
data1=match_data[-rowsToExclude,]
data1=data1[!(is.na(data1$MatchNo)),]
data1=data1[!(is.na(data1$NumOutcome)),]
data1=data1[-which(data1$Format ==" "),]
match_ids_faulty= c()
match_ids_faulty = c(match_ids_faulty, unique(data1[which(data1$Wickets>9), 2]))

faulty_matches = c(191, 440, 200903, 200906, 200933,200938,200947,200948,201103,201109, 201112,201128,201131,201211,201228,201258
                   ,201273,201275,201536,201554)
match_ids_faulty = c(match_ids_faulty, faulty_matches)
data2=data1[-which(data1$MatchNo %in% match_ids_faulty),]

total_runs_per_match_clean_data = ddply(data2, 
                                        .(MatchNo),
                                        summarize,
                                        total_runs = sum(NumOutcome[which(NumOutcome >=0 & NumOutcome<=7)])
)
summary(total_runs_per_match_clean_data)
matches_with_redundant_records = total_runs_per_match_clean_data[which(total_runs_per_match_clean_data$total_runs > 465),1]
data2=data2[-which(data2$MatchNo %in% matches_with_redundant_records),]
################################################## Part(a) ########################

#total sixes hit in each over in an inning
df_split_1=ddply(data2, 
               .(Over,Inning),
               summarize,
               total_six_hit = length(which(NumOutcome == 6))
               )

ggplot(df_split_1,aes(x=Over,y=as.factor(Inning), fill=total_six_hit)
       ,xlab="Over"
       ,ylab="Inning") +  geom_tile()


#total wickets taken in each over across format
df_split_2=ddply(data2, 
                 .(Over,Format),
                 summarize,
                 total_wickets = length(which(NumOutcome == -1))
)

ggplot(df_split_2,aes(x=Over,y=Format, fill=total_wickets)
       ,xlab="Over"
       ,ylab="Inning") + geom_tile() +scale_fill_gradient(low = "orange", high = "maroon")

# Analysis of percentage of total sixes hit in each over by an IPL team
df_split_3=ddply(subset(data2, Format == "IPL" & !(TeamBowling %in% c("IND"))), #only including IPL teams
                 .(TeamBowling,Over),
                 summarize,
                 total_wickets = mean(NumOutcome == 6)*100
)

ggplot(df_split_3,aes(y=TeamBowling,x=Over, fill=total_wickets)
       ,xlab="Over"
       ,ylab="Team") + geom_tile() +scale_fill_gradient(low = "green", high = "dark green")


################################################## Part(b) ########################
DLS = read.csv("DLS_T20.csv")[,-1]
result_highlights = data.frame()
match_ids = unique(data2$MatchNo)

for(match in match_ids)
{
  resource_used_vector = c()
  resource_left_vector = c()
  runs_needed_to_keep_up=c()
  
  data_first_inning=subset(data2,MatchNo ==match & Inning==1)
  target = by(data_first_inning$NumOutcome>=0 & data_first_inning$NumOutcome<=7, data_first_inning$Inning, sum)
  data_second_inning=subset(data2,MatchNo == match & Inning==2)
  
  sample_text <- data_second_inning$FullNotes
  afinn_vector=get_sentiment(sample_text, method="afinn", lang="english")
  
  for(i in 1:nrow(data_second_inning))
  {
    resource_left = (1-(data_second_inning[i,7]/6))*DLS[data_second_inning[i,6]+1,data_second_inning[i,21]+1] + data_second_inning[i,7]/6*DLS[data_second_inning[i,6]+2,data_second_inning[i,21]+1]
    resource_used = DLS[data_second_inning[i,6]+1,data_second_inning[i,21]+1] - resource_left
    runs_needed_to_keep_up = c(runs_needed_to_keep_up,round(resource_used * target, 3))
    resource_used_vector = c(resource_used_vector, round(resource_used, 4)) # round to 4 digits
    resource_left_vector = c(resource_left_vector, round(resource_left, 4)) 
  }
  
  ball_score=c(as.numeric(afinn_vector[1]))
  highlight_balls = data.frame(cbind(data_second_inning,ball_score[1]))
  colnames(highlight_balls)[dim(highlight_balls)[2]] = "Score"
  
  for(i in 2:length(afinn_vector))
  {
    emotional_valence = abs(afinn_vector[i])
    resource_usage_difference = abs(resource_used_vector[i-1] - resource_used_vector[i])
    resource_left_difference = abs(resource_left_vector[i] - resource_left_vector[i-1])
    
    if(data_second_inning[i,15] == -1 )
      ball_score = c(ball_score, 2.5*(emotional_valence) + 100*resource_usage_difference)
    else if(data_second_inning[i,15] >= 4  & data_second_inning[i,15] < 6)
      ball_score = c(ball_score, 1.5*(emotional_valence) + 100*resource_usage_difference)
    else if(data_second_inning[i,15] >= 6)
      ball_score = c(ball_score, 2.5*(emotional_valence) + 100*resource_usage_difference)
    else
      ball_score = c(ball_score, (emotional_valence + resource_usage_difference))
    highlight_balls[nrow(highlight_balls)+1,] = c(data_second_inning[i,], ball_score[i])
    
  }
  Final_highlight_balls = highlight_balls
  Final_highlight_balls[,22] = highlight_balls[,22]
  Final_highlight_balls = Final_highlight_balls[order(-Final_highlight_balls$Score),]
  Final_highlight_balls = Final_highlight_balls[1:20,]
  Final_highlight_balls = Final_highlight_balls[order(Final_highlight_balls$Over, Final_highlight_balls$Ball),]
  
  result_highlights = rbind(result_highlights,Final_highlight_balls)
  
}

head(result_highlights, n=22)
####################################################### Part(c) ########################
cluster_df = data2
df_matches = ddply(cluster_df, "MatchNo", summarize,
                    total_wickets = length(which(NumOutcome == -1)),
                    total_six = length(which(NumOutcome == 6 | NumOutcome ==7)),
                    total_four = length(which(NumOutcome == 4 | NumOutcome ==5)),
                    total_runs = sum(pmax(NumOutcome, 0, na.rm=TRUE))
)

gr1 <- ggplot(df_matches, aes(x = total_six,  y = total_wickets)) +
  geom_point() +
  ylab("wickets taken during the match") +
  xlab("sixes hit during the match")
plot(gr1)

gr2 <- ggplot(df_matches, aes(x = total_six,  y = total_wickets)) +
  geom_density_2d_filled() +
  ylab("wickets taken during the match") +
  xlab("sixes hit during the match")
plot(gr2)

df_shot_risk = subset(df_matches, select = c(total_six, total_wickets))
wssd <- rep(NA,9)
for(k in 2:10) {
  shot_clust <- kmeans(df_shot_risk, centers = k)
  wssd[k-1] <- shot_clust$tot.withinss
}

centers <- 2:10
dat <- data.frame(centers, wssd)
gr3 <- ggplot(dat, aes(x=centers, y=wssd)) +
  geom_line() +
  geom_point() +
  xlab("number of clusters") +
  ylab("WSSD")
plot(gr3)

# We can take 5 clusters in our case as can be seen from elbow chart

shot_clust_5 <- kmeans(df_shot_risk, centers = 5) 
shot_clust_5$centers

msd <- sqrt(shot_clust_5$withinss / shot_clust_5$size)
msd
####################################################### Part(d) ########################
DLT = read.csv("DLS_T20.csv")[,-1]
dls_df = data.frame(subset(data2,!(MatchNo %in% faulty_matches) & Inning==1))

dls_df$over2 = dls_df[,6] + dls_df[,7]/6
dls_df$Nruns = pmax(dls_df[,15], 0)

dls_df_result = data.frame()

func_calc_prop = function(match)
{
  df_temp = data.frame()
  df_temp = data.frame(subset(dls_df, MatchNo==match))
  target = sum(df_temp$Nruns)
  
  for(i in 1:nrow(df_temp))
  {
    df_temp$cum = cumsum(df_temp$Nruns)
    df_temp$prop[i] = df_temp$cum[i]/target
  }
  return(rbind(dls_df_result,df_temp))
}

for(match in match_ids)
  dls_df_result = func_calc_prop(match)


over2 = dls_df_result$over2
wicket = dls_df_result$Wickets
prop = dls_df_result$prop

#loss function
loss_function = function(x, prop) {
  A = x[1]
  B = x[2]
  C = x[3]
  D = x[4]
  prop_smooth = A*over2^2 + B*(10-wicket)^2 + C*over2^3 + D*over2*(10-wicket)
  error = sum((prop - prop_smooth)^2)
  return(error)
}


best_params = optim(par=c(0,0,0,0), loss_function, prop=prop)$par
A = best_params[1]
B = best_params[2]
C = best_params[3]
D = best_params[4]
#Make a matrix. 20 rows for 20 overs, 10 columns for the 0-9 wickets taken # NA for cell values to start so that
# we know if we missed something because it will still be NA
newDLT = matrix(NA, nrow=20, ncol=10)
# Compute the matrix row by row, where each row is an over
for(overcount in 1:20) {
  # Apply the example formula. 1 - (formula) because resource = 1 - proportion.
  newDLT[overcount,] = 1 - (A*overcount^2 + B*(0:9)^2 + C*overcount^3 + D*overcount*(0:9)) 
  }
# Compare
newDLT
#View(dls_df_result)

for(loopcount in 1:10)
{
  
  temp = rbind(newDLT[2:20,], rep(0, 10))
  newDLT = pmax(temp, newDLT)
}


range = max(newDLT) - min(newDLT)

newDLT2 = (newDLT - min(newDLT)) / range

round(newDLT2,3)


