tabItem(tabName = "pathviewTab",
        h2(strong("Pathview Plot")),
        
        fluidRow(
          column(3,
                 wellPanel(
                   selectizeInput("pathwayIds", label="Select Pathway ID",
                                  choices=NULL,
                                  multiple=F,
                                  options = list(
                                    placeholder =
                                      'Start typing pathway id'
                                  )
                   ),
                   selectInput("geneid_type","Gene ID type:", choices = c(""), selected = NULL),
                   actionButton("generatePathview", "Generate Pathview", class = "btn btn-info"),
                   conditionalPanel("output.pathviewPlotsAvailable",
                                    hr(),
                                    downloadButton('downloadPathviewPng','Download .png', class = "btn btn-warning"),
                                    downloadButton('downloadPathviewPdf','Download .pdf', class = "btn btn-warning")
                   )
                 )
                 ),
          column(9,
                 withSpinner(imageOutput(outputId = "pathview_plot", inline = T),type = 8)
                 )
        )
        
        
        # wellPanel(
        #   column(6,
        #          
        #          selectizeInput("pathwayIds", label="Select Pathway ID",
        #                         choices=NULL,
        #                         multiple=F,
        #                         options = list(
        #                           placeholder =
        #                             'Start typing pathway id'
        #                         )
        #          )
        #          
        #          )
        #   ,
        #   column(6,
        #          selectInput("geneid_type","Gene ID type:", choices = c(""), selected = NULL)
        #          ),
        #   column(6,
        #          actionButton("generatePathview", "Generate Pathview", class = "btn btn-info")
        #          ),
        #   conditionalPanel("output.pathviewPlotsAvailable",
        #                    column(3,
        #                           downloadButton('downloadPathviewPng','Download .png', class = "btn btn-warning", style="margin: 7px;")
        #                    ),
        #                    column(3,
        #                           downloadButton('downloadPathviewPdf','Download .pdf', class = "btn btn-warning", style="margin: 7px;")
        #                    )
        #                    )
        #   ,
        #   tags$div(class = "clearBoth")
        #   
        # ),
        # withSpinner(imageOutput(outputId = "pathview_plot", inline = T),type = 8)
        
        
)