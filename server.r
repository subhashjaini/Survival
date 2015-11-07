library(shiny)
library(httr)
library(OIsurv)
library(rvest)


Ofile <- "http://www.imperialconcepts.org/wp-content/uploads/Old_Faithful.csv"
O <- read.csv(Ofile,header=T)
O$Diff <- c(NA,diff(O$Time,1))
O <- O[O$Diff > 100 & O$Diff < 325 & O$Major.Minor!= "" & !is.na(O$Major.Minor),]
O$Major <- as.numeric(O$Major.Minor=="Major")
SurvO <- Surv(O$Diff,O$Major)
my_fit <- survfit(SurvO ~ 1)
URL = "http://geysertimes.org/geyser.php?id=OldFaithful"


# Define a server for the Shiny app
shinyServer(function(input, output,session) {
autoInvalidate <- reactiveTimer(60000, session)

observe({


output$Survival <- renderPlot({
autoInvalidate()
Site <- URL %>%
	read_html() %>%
#html_node(xpath='//*[@id="805273"]/b/a') %>%
	html_nodes('#current_interval') %>%
	html_text()
#unlist(strsplit(unlist(strsplit(Site,"@ "))[2]," "))[1]
#CurrentMinutesInDay = as.numeric(format(Sys.time(),"%H"))*60+as.numeric(format(Sys.time(),"%M"))
#MostRecentGeyser = 60*as.numeric(substring(unlist(strsplit(unlist(strsplit(Site,"@ "))[2]," "))[1],1,2))+as.numeric(substring(unlist(strsplit(unlist(strsplit(Site,"@ "))[2]," "))[1],3,4))+120
#CurrentDifferenceFromLastGeyser = CurrentMinutesInDay-MostRecentGeyser
CurrentDifferenceFromLastGeyser= eval(parse(text=gsub("m ago","",gsub("h","\\*60\\+",Site[1]))))

#summary(my_fit)$surv[summary(my_fit)$time==CurrentDifferenceFromLastGeyser]
#,main="Likelihood to Survive When \n Standing On Geyser Spout"
plot(my_fit,col="brown",cex=3,lwd=2,sub="Data Based Off Old Faithful Geyser",xlab="Time Difference Between Eruptions (in minutes)", ylab="Likelihood ")

if(CurrentDifferenceFromLastGeyser > min(summary(my_fit)$time) & CurrentDifferenceFromLastGeyser < max(summary(my_fit)$time))
	{
	
	CurrentPercent = summary(my_fit)$surv[which.min(abs(CurrentDifferenceFromLastGeyser - summary(my_fit)$time))]
	CurrentColor = data.frame(Color=c(rep("#566c73",2),rev(rainbow(4)),rep("red",5)),Worry=c(1,.9,.8,.7,.6,.5,.4,.3,.2,.1,0))
	WorryColor = as.character(CurrentColor$Color[CurrentColor$Worry==round(CurrentPercent,1)])
	AdditionalText = if(CurrentPercent> .75){"You are PROBABLY fine."}else if(CurrentPercent> .6){"Kinda cuttin it close"}else if(CurrentPercent> .4){"You might not survive if you don't get out"}else if(CurrentPercent> .3){"Can ya add me to your will?"}else{"Good bye, \nidiot!"}
	text(CurrentDifferenceFromLastGeyser,.05+CurrentPercent,paste0("Point In Eruption Lifecycle: ",AdditionalText),col=WorryColor,cex=2)
	points(CurrentDifferenceFromLastGeyser,CurrentPercent,cex=3,col=WorryColor,bg=WorryColor,pch=19)
	}else{
	text(50+CurrentDifferenceFromLastGeyser,.9,"You are fine to have fun there",col="#566c73",cex=2)
	points(CurrentDifferenceFromLastGeyser,1,cex=3,col="darkblue",bg="darkblue",pch=19)
	}
	text(25,0,paste0("As of: ",Sys.time()),cex=1)

})
 


  
 
  })

})



#code subset data based on schoolname (SCH_NAME) and grade (TEST-LEVEL)
#x <- OriginalDataWithCluster[Cluster==OriginalDataWithCluster[SCH_NAME==SCHOOL]$Cluster]$AVG_SOL_SCALE_SCOREEnglishTestScoreA
#ecdf(x)(SCORE)





