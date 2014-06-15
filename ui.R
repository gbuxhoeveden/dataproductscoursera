shinyUI(fluidPage(
  
  titlePanel(HTML(text="<img src='rail.jpeg', width=48, align='left'><img src='rail.jpeg', width=48, align='right'><center><code>Railway Incident Explorer</code></center>"),
             windowTitle="Railway Incident Explorer"),
  
  sidebarLayout(
    
    sidebarPanel(
      uiOutput("selectCountry"),
      uiOutput("incidentType"),
      sliderInput("range", strong("Time span"),
                  min = 2000, max = 2014, value = c(2006,2013), format="#", ticks=FALSE)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Country Breakdown",
                 plotOutput(outputId = "ctr", height = "600px")
        ),
        tabPanel("Type Breakdown",
                 plotOutput(outputId = "bar", height = "400px")
        ),
        tabPanel("Trend",
                 plotOutput(outputId = "plot", height = "400px")
        ),
        tabPanel("Table",
                 dataTableOutput(outputId = "table")
        ),
        tabPanel("Interactive Chart",
                 showOutput("myChart", "polycharts")
        ),
        tabPanel("Help", 
                 h4("Online Help"),
                 htmlOutput("helptext"))
      )
    )
  )
))
