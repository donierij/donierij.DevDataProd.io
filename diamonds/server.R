library(shiny);library(ggplot2)library(dplyr)

function(input, output) {
    ds <- reactive({
        filter(diamonds, color == input$color & cut == input$cut)
    })
    output$clarity <-renderUI({
        selectInput("clarity","Clarity",unique(select(ds(), clarity)))
    })
    
    ds1 <- reactive({ filter(ds(), clarity == input$clarity)})
    
    
    output$weight <- renderUI({
        sliderInput("carat","Carat:",min = min(select(ds1(),carat)),
                    max = max(select(ds1(),carat)) ,
                    value = 1)
    })
    
    mdlpred <- reactive({
        fit <- lm(price ~ carat,data=ds1())
        weight <- input$carat
        predict(fit, newdata = data.frame(carat = weight))
    })
    
    output$plot <- renderPlot({
        weight <- input$carat
        
        g<- ggplot(data = ds1(),aes(x=carat,y=price))+theme_bw()+
            labs(x = "Weight of diamod (carat)", y = "Price in US dollars", title="Linear Regression Model Fit")+
            geom_point(color="skyblue2", shape = 7, size=2)+
            geom_smooth(method = "lm",color="red")+
            geom_point(aes(x=weight, y=mdlpred()), color = "red", size= 4)
        g
    })
    
    output$pred <- renderText({round(mdlpred(),2)})
    
    output$stats <- renderPrint({
        fit <- lm(price ~carat,data = ds1())
        x<- summary(fit)[[4]][2,]
        round(x,2)
    })
}