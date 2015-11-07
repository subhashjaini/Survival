
#install.packages(c("Rcpp", "httpuv", "shiny"))
library(shiny)
library(httr)


#setwd("C:/Users/User/Desktop/ShinyApps")
#runApp("SurvivalGeyser")
#library(shinyapps);deployApp("SurvivalGeyser")




shinyUI(
fluidPage(
		HTML("<link href='https://fonts.googleapis.com/css?family=Creepster' rel='stylesheet' type='text/css'><style>#rstudio_branding_bar{display:none}.form-control{width:50px}.shiny-split-layout>div{overflow: hidden;}body{background: -webkit-linear-gradient(#9bc2cf, #d6ebf2); */
    background: -o-linear-gradient(#9bc2cf, #d6ebf2);
    background: -moz-linear-gradient(#9bc2cf, #d6ebf2);
    background: linear-gradient(#9bc2cf,#d6ebf2);}img {border-radius:35px; 
   border:5px solid #2E0854;
   
}html{overflow: hidden;}h2{font-family: 'Creepster', cursive;font-size:80px;color:darkred}</style><center>"),
titlePanel("Survival"),
		plotOutput("Survival"),
		HTML("<p><br><p><br><p><br><p><br><p>")
		
#,fluidRow(DT::dataTableOutput("FullTable"))
)
)