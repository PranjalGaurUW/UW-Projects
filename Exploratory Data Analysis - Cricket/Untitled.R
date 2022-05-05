#######################################################(a)#############################
data3=data2[which(data2$Inning==1),]
summary(data3$Wickets)

prop_runs_scored = by(data3$NumOutcome>=0 & data3$NumOutcome<=7, list(data3$Over,data3$Wickets),mean)

x_values = 1:20
y_values = 0:9
df1= matrix(prop_runs_scored, nrow=length(x_values), ncol=length(y_values))
df1=data.frame(df1)
rownames(df1)=x_values
colnames(df1)=y_values

df2=df1 %>%
  as.data.frame()%>%
  rownames_to_column("overs") %>%
  pivot_longer(-c(overs), names_to = "wickets", values_to = "proportion")

ggplot(df2,aes(x=overs,y=wickets, fill=proportion)) +  geom_tile()


##2.

data4=subset(data2,Format=="IPL")
sixes_scored_by_innings_and_wickets_IPL = by(data4$NumOutcome==6, list(data4$Inning,data4$Wickets),mean,na.rm = TRUE)
x_values2=1:2
y_values2=0:9

df3= matrix(sixes_scored_by_innings_and_wickets_IPL, nrow=length(x_values2), ncol=length(y_values2))
df3=data.frame(df3)
rownames(df3)=x_values
colnames(df3)=y_values

df4=df3 %>%
  as.data.frame()%>%
  rownames_to_column("innings") %>%
  pivot_longer(-c(innings), names_to = "wickets", values_to = "proportionOfSixes")

ggplot(df4,aes(x=innings,y=wickets, fill=proportionOfSixes)) +  geom_tile()
######################################################(b)#################################
resource_used_vector = c()
resource_left_vector = c()
runs_needed_to_keep_up=c()

data_first_inning=subset(data2,MatchNo ==40 & Inning==1)
target = by(data_first_inning$NumOutcome>=0 & data_first_inning$NumOutcome<=7, data_first_inning$Inning, sum)
data_second_inning=subset(data2,MatchNo == 40 & Inning==2)

sample_text <- data_second_inning$FullNotes
afinn_vector=get_sentiment(sample_text, method="afinn", lang="english")


for(i in 1:nrow(data_second_inning))
{
  resource_left = (1-(data_second_inning[i,7]/6))*DLS[data_second_inning[i,6]+1,data_second_inning[i,21]+1] + data_second_inning[i,7]/6*DLS[data_second_inning[i,6]+2,data_second_inning[i,21]+1]
  resource_used = DLS[data_second_inning[i,6]+1,data_second_inning[i,21]+1] - resource_left
  runs_needed_to_keep_up = c(runs_needed_to_keep_up,round(resource_used * target, 3))
  resource_used_vector = c(resource_used_vector, round(resource_used, 4)) # round to 3 digits
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
  print(paste("emotional_valence",emotional_valence))
  print(paste("resource_usage_difference",resource_usage_difference))
  
}
View(highlight_balls)
Final_highlight_balls = highlight_balls
Final_highlight_balls[,22] = highlight_balls[,22]
Final_highlight_balls = Final_highlight_balls[order(-Final_highlight_balls$Score),]
Final_highlight_balls = Final_highlight_balls[1:20,]
Final_highlight_balls = Final_highlight_balls[order(Final_highlight_balls$Over, Final_highlight_balls$Ball),]

View(Final_highlight_balls)
View(highlight_balls)


max_df = data.frame()
max_df = rbind(max_df,Final_highlight_balls)
View(max_df)
#####################################################################
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
  View(df_temp)
  
  return(rbind(dls_df_result,df_temp))
}

dls_df_result = func_calc_prop(40)

View(dls_df_result)
