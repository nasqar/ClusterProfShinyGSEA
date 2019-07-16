tabItem(tabName = "goplotsTab",
        h2(strong("GO Plots")),
        tags$div(
          box(title = "Dot Plot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "dotplot",
              fluidRow(
                column(3,
                       wellPanel(
                         numericInput("showCategory_dot", "number of categories to show", value = 10)
                       )
                ),
                column(9,
                       wellPanel(
                         withSpinner(plotOutput(outputId = "dotPlot"),type = 8)
                       )
                       
                )
              )
          ),
          box(title = "Encrichment plot map", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "gsePlotMap",
              fluidRow(
                column(3,
                       wellPanel(
                         numericInput("showCategory_enrichmap", "number of categories to show", value = 5)
                       )
                )
                ,
                column(9,
                       wellPanel(
                         plotOutput(outputId = "gsePlotMap")
                       )
                )
              )
          ),
          box(title = "Category Netplot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "cnetplot",
              fluidRow(
                column(12,
                       wellPanel(
                         numericInput("showCategory_cnet", "number of categories to show", value = 5)
                       )
                )
                ,
                column(12,
                       wellPanel(
                         plotOutput(outputId = "cnetplot")
                       )
                )
              )
          ),
          box(title = "Ridge Plot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "ridgeplot",
              fluidRow(
                column(3,
                       wellPanel(
                         numericInput("showCategory_ridge", "number of categories to show", value = 10)
                       )
                ),
                column(9,
                       wellPanel(
                         withSpinner(plotOutput(outputId = "ridgePlot"),type = 8)
                       )
                )
              )
          ),
          box(title = "GSEA Plot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "gseaplot",
              fluidRow(
                column(12,
                       wellPanel(
                         numericInput("geneSetId_gsea", "Gene Set ID", value = 1)
                       )
                ),
                column(12,
                       wellPanel(
                         plotOutput(outputId = "gseaplot",width = "100%", height = "400px")
                       )
                )
              )
          )
        , style = "display:table;")
        
)