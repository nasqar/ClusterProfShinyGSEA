tabItem(tabName = "gseKeggTab",
        
        conditionalPanel("output.gseKEGGAvailable",
                         
                                  column(2,
                                         h3(strong("gseKEGG Results")),
                                         hr(),
                                         checkboxInput("showAllColumns_kegg","Show all columns", value = F),
                                         downloadButton('downloadgseKEGGCSV','Save Results as CSV File', class = "btn btn-info", style="margin: 7px;"),
                                         actionButton("gotoKeggPlots","gseKEGG Plots",class = "btn btn-warning",icon = icon("chart-area"), style="margin: 7px;"),
                                         actionButton("gotoPathview","Generate Pathview Plot",class = "btn btn-warning",icon = icon("chart-area"), style="margin: 7px;"),
                                         
                                         wellPanel(h4(strong("Output warning:"), tags$a(href = "#", bubbletooltip = "Description ...",icon("info-circle"))),
                                                   htmlOutput("warningText"), style = "background-color: #f9d8d3;")
                                         
                                         ),
                                  column(10,
                                         tags$div(class = "BoxArea2",
                                         withSpinner(dataTableOutput('gseKEGGTable'))
                                         ),
                                         tags$div(class = "clearBoth")
                                         ),
                                  tags$div(class = "clearBoth")
                         
        )
)