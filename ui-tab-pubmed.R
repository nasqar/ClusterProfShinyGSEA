tabItem(tabName = "pubmedTab",
        h2(strong("PubMed Trends of Enriched Terms")),
        box(title = "Trends", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "pubmed",
            fluidRow(
              column(3,
                     wellPanel(
                       numericInput("year_from", "From", value = 2010),
                       numericInput("year_to", "To", value = 2018),
                       selectizeInput("pubmedTerms", label="Select GO Terms",
                                      choices=NULL,
                                      multiple=T,
                                      options = list(
                                        placeholder =
                                          'Start typing GO Term ...'
                                      )
                       ),
                       actionButton("plotTrends","Plot Trends", class = "btn btn-info")
                       
                     )
              ),
              column(9,
                     wellPanel(
                       #wordcloud2Output(outputId = "pmcPlot")
                       withSpinner(plotlyOutput(outputId = "pmcPlot"))
                     )
                     
              )
            )
        )
        
)