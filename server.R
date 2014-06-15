library(ggplot2)
library(rCharts)
load("rail.RData")
df <- rail
shinyServer(function(input, output) {
  output$selectCountry    <- renderUI({
    countries <- sort(unique(df$Country))
    countries <- c("All",countries)
    selectInput(inputId = "country",
                label =strong("Country"),
                choices = countries,
                selected="All")
  })
  output$incidentType    <- renderUI({
    df <- countrySubset()
    incidents <- sort(unique(df$Occurrence.type))
    incidents <- c("All",incidents)
    selectInput(inputId = "type",
                label =strong("Incident type"),
                choices = incidents,
                selected="All"
                )
  })
  time           <- reactive({
    df <- subset(df, year >= input$range[1] & year <= input$range[2])
    return(df)
  })
  countrySubset <- reactive({
    df <- time()
    if(input$country=="All"){
      return(df)
    } else{
      df <- subset(df, Country==input$country)
      return(df)
    }
  })
  typeSubset <- reactive({
    df <- countrySubset()
    if(input$type=="All"){
      return(df)
    } else{
      df <- subset(df, Occurrence.type==input$type)
    }
    return(df)
  })
  output$plot       <- renderPlot({
    df <- typeSubset()
    if(nrow(df)>0){
      p <- ggplot(data=df, aes(y=Total.fatalities,x=Date.of.occurrence))
      p <- p + geom_point() + stat_smooth(method="lm", level=0.95, aes(group=1))
      txt <- paste(input$country,"-",input$type,"\n")
      p <- p + labs(title=txt) + xlab("Year") + ylab("Fatalities")
    } else{
      p <- ggplot() + annotate("text", label = "No data", x = 2, y = 15, size = 8, colour = "red") 
    }
    print(p)
  })
  output$ctr       <- renderPlot({
    df <- time()
    if(nrow(df)>0){
      p <- ggplot(data=df, aes(x=Country,  fill=factor(Occurrence.type))) + geom_bar(stat="bin") + coord_flip() + guides(fill=guide_legend(title="Type"))
      p <- p + labs(title="Country breakdown\n") + ylab("Number of Incidents") + xlab("Country")
    } else{
      p <- ggplot() + annotate("text", label = "No data", x = 2, y = 15, size = 8, colour = "red") 
    }
    print(p)
  })
  output$bar       <- renderPlot({
    df <- countrySubset()
    if(nrow(df)>0){
      p <- ggplot(data=df, aes(x=Occurrence.type,  fill=factor(Total.fatalities,levels=c(NA,0,1,2,3,4,5,10,100)))) + geom_bar(stat="bin") + coord_flip() + guides(fill=guide_legend(title="Fatalities"))
      p <- p + labs(title="Type breakdown\n") + ylab("Number of Incidents") + xlab("Incident type")
    } else{
      p <- ggplot() + annotate("text", label = "No data", x = 2, y = 15, size = 8, colour = "red") 
    }
    print(p)
  })
  output$table <-renderDataTable({
    df <- typeSubset()
    df
  })
  output$myChart <-renderChart({
    df <- typeSubset()
    names(df) = gsub('\\.', '', names(df))
    df$Dateofoccurrence <- as.numeric(as.POSIXct(df$Dateofoccurrence))
    r1 <- rPlot(Totalfatalities~Dateofoccurrence, data = df, type = "point", color = "Locationtype")
    r1$addParams(dom = 'myChart')
    return(r1)
    #df$Dateofoccurrence <- as.numeric(as.POSIXct(df$Dateofoccurrence))
    #p4 <- Rickshaw$new()
    #p4$layer(Totalfatalities~Dateofoccurrence, data = df, type = "scatterplot", width = 560)
    # add a helpful slider this easily; other features TRUE as a default
    #p4$set(slider = TRUE)
    #p4$addParams(dom = 'myChart')
    #p4$print("myChart")
    #return(p4)
  })
  output$helptext  <- renderText({
    helptext = readLines("www/helptext.html")
    HTML(text=helptext) 
  })
})