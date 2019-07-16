tabItem(tabName = "keggPlotsTab",
        h2(strong("KEGG Plots")),
        tags$div(
          box(title = "Dot Plot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "dotplot",
              fluidRow(
                column(3,
                       wellPanel(
                         numericInput("showCategory_dot_kegg", "number of categories to show", value = 10)
                       )
                ),
                column(9,
                       wellPanel(
                         withSpinner(plotOutput(outputId = "dotPlot_kegg"),type = 8)
                       )
                )
              )
          ),
          box(title = "Encrichment plot map", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "gsePlotMap_kegg",
              fluidRow(
                column(3,
                       wellPanel(
                         numericInput("showCategory_enrichmap_kegg", "number of categories to show", value = 5)
                       )
                )
                ,
                column(9,
                       wellPanel(
                         plotOutput(outputId = "gsePlotMap_kegg")
                       )
                )
              )
          ),
          box(title = "Category Netplot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "cnetplot",
              fluidRow(
                column(12,
                       wellPanel(
                         numericInput("showCategory_cnet_kegg", "number of categories to show", value = 5)
                       )
                ),
                column(12,
                       wellPanel(
                         plotOutput(outputId = "cnetplot_kegg",width = "100%", height = "400px")
                       )
                )
              )
          ),
          box(title = "Ridge Plot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "ridgeplot_kegg",
              fluidRow(
                column(3,
                       wellPanel(
                         numericInput("showCategory_ridge_kegg", "number of categories to show", value = 10)
                       )
                ),
                column(9,
                       wellPanel(
                         withSpinner(plotOutput(outputId = "ridgePlot_kegg"),type = 8)
                       )
                )
              )
          ),
          box(title = "GSEA Plot", solidHeader = T, status = "danger", width = 12, collapsible = T,id = "gseaplot_kegg",
              fluidRow(
                column(12,
                       wellPanel(
                         numericInput("geneSetId_gsea_kegg", "Gene Set ID", value = 1)
                       )
                ),
                column(12,
                       wellPanel(
                         plotOutput(outputId = "gseaplot_kegg",width = "100%", height = "400px")
                       )
                )
              )
          )
        ,style = "display:table;")
        
)