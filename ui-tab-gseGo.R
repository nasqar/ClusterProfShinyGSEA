tabItem(tabName = "gseGoTab",
        
        conditionalPanel("output.gseGoAvailable",
                         
                                  column(2,
                                         h3(strong("gseGo Results")),
                                         hr(),
                                         checkboxInput("showAllColumns","Show all columns", value = F),
                                         downloadButton('downloadgseGoCSV','Save Results as CSV File', class = "btn btn-info", style="margin: 7px;"),
                                         actionButton("gotoGoPlots","gseGo Plots",class = "btn btn-warning",icon = icon("chart-area"), style="margin: 7px;"),
                                         actionButton("gotoPubmed","Search PubMed Trends",class = "btn btn-warning",icon = icon("chart-area"), style="margin: 7px;")
                                         ),
                                  column(10,
                                         tags$div(class = "BoxArea2",
                                          withSpinner(dataTableOutput('gseGoTable'))
                                         ),
                                         tags$div(class = "clearBoth")
                                         ),
                                  tags$div(class = "clearBoth")
                         
        )
)