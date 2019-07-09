tabItem(tabName = "datainput",
         hr(),
         fluidRow(column(6,
                         box(title = "Upload Data", solidHeader = T, status = "success", width = 12, collapsible = T,id = "uploadbox",

                             #downloadLink("instructionspdf",label="Download Instructions (pdf)"),
                             radioButtons('data_file_type','Use example file or upload your own data',
                                          c(
                                            'Upload .CSV'="csvfile",
                                            'Example Data'="examplecounts"
                                          ),selected = "csvfile"),

                             conditionalPanel(condition="input.data_file_type=='csvfile'",
                                              p("CSV counts file")

                             ),
                             conditionalPanel(condition = "input.data_file_type=='csvfile' || input.data_file_type=='upload10x'",
                                              fileInput('datafile', 'Choose File(s) Containing Data', multiple = TRUE)
                             )

                         ),
                         conditionalPanel("output.fileUploaded",
                                          box(title = "Initialize Parameters", solidHeader = T, status = "primary", width = 12, collapsible = T,id = "iParamsbox",
                                              
                                              wellPanel(
                                                column(
                                                  6,
                                                       selectInput("geneColumn","Select Genes column:", choices = c("sdfs","dfs"))
                                                ),
                                                column(6,
                                                       selectInput("log2fcColumn","Select Log2FC column:", choices = c("sdfs","dfs"))
                                                ),
                                                # column(4,
                                                #        selectInput("padjColumn","Select padj column:", choices = c("sdfs","dfs"))
                                                # ),
                                                tags$div(class = "clearBoth")
                                              ),
                                              actionButton("nextInitParams","Next", class = "btn-info", style = "width: 100%")
                                              
                                          ),
                                          
                                          
                                          box(title = "gseGO object Parameters", solidHeader = T, status = "primary", width = 12, collapsible = T,id = "createGoBox", collapsed = T,
                                            wellPanel(
                                              column(4,
                                                     selectInput("organismDb","Organism:", choices = NULL, selected = NULL)
                                              ),
                                              column(4,
                                                     selectInput("keytype","Keytype:", choices = c(""), selected = NULL)
                                              ),
                                              column(4,
                                                     selectInput("ontology","Ontology:", choices = c("MF", "BP", "CC","ALL"), selected = "ALL")
                                              ),
                                              column(4,
                                                     numericInput("nPerm","Permutation #s:", value = 1000, min = 1, max = 100000)
                                              ),
                                              column(4,
                                                     numericInput("minGSSize","minGSSize:", value = 10)
                                              ),
                                              column(4,
                                                     numericInput("maxGSSize","maxGSSize:", value = 500)
                                              ),
                                              column(4,
                                                     numericInput("pvalCuttoff","P-Value Cutoff:", value = 0.05)
                                              ),
                                              column(4,
                                                     selectInput("pAdjustMethod","pAdjustMethod:", choices = c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"), selected = "fdr")
                                              ),
                                              column(4,
                                                     selectInput("keggKeyType","keggKeyType:", choices = c("kegg", "ncbi-geneid", "ncib-proteinid","uniprot"), selected = "ncbi-geneid")
                                              ),
                                              tags$div(class = "clearBoth")
                                            ),
                                            actionButton("initGo","Create gseGO Object", class = "btn-info", style = "width: 100%")
                                          )
                         )
         ),#column
         column(6,
                bsCollapse(id="input_collapse_panel",open="data_panel",multiple = FALSE,
                           bsCollapsePanel(title="Data Contents Table:",value="data_panel",
                                           p("Note: if there are more than 20 columns, only the first 20 will show here"),
                                           textOutput("inputInfo"),
                                           withSpinner(dataTableOutput('countdataDT'))
                           )
                )#bscollapse
         )#column
         )#fluidrow
)#tabpanel
