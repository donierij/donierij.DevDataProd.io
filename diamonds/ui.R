library(shiny); library(ggplot2);library(dplyr)

dat <- select(diamonds, color,cut)

fluidPage(
    
    titlePanel(
        span("Diamonds Price Predictor",style="color:darkblue")
    ),
    sidebarLayout(
        
        sidebarPanel(
            h4("Documentation",.noWS = NULL),
            p(em("A diamond price predictor application. The model is based on the R dataset,"),
              code("diamonds"),em(", containing the prices of almost 54,000 diamonds with their respective attributes."),
              style = "font-size:14px"),
            h5("1. Start by selecting from the atributes below:"),
            
            selectInput("color", "Color", choices=unique(select(dat, color))),
            p(em("diamond color, from D (best) to J (worst)."), 
              style = "font-size:12px"),    
            
            selectInput("cut","Cut", unique(select(dat, cut))),
            p(em("quality of the cut (Fair, Good, Very Good, Premium, Ideal)."),style = "font-size:12px"),
            
            uiOutput("clarity"),
            p(em("measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))."),style = "font-size:12px"),
            
            h5("2. Select the diamond weight"),
            uiOutput("weight")
            
        ),
        
        mainPanel(
            fluidRow(
                column(7,h4(strong("The predicted price in US dollars is:"))),
                column(1,h4(span(textOutput("pred"), style="color:red")))
            ),
            hr(),
            fluidRow(plotOutput("plot")),
            fluidRow(
                strong("Note:"),
                p("The 'red' dot represents your prediction."),
                p("The model statistics are as follow:"),
                verbatimTextOutput("stats"),
                em("the units of the estimate is US dollars per unit increase in weight",style = "font-size:12px" )
            )
        )
    )
)
