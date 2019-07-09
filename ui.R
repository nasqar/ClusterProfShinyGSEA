require(shinydashboard)
require(shinyjs)
require(shinyBS)
require(shinycssloaders)
require(DT)
require(shiny)


library(clusterProfiler)
library(DOSE)
library(GOplot)
library(enrichplot)
library(pathview)
library(wordcloud2)
library(plotly)

# BiocInstaller::biocLite(c("org.Hs.eg.db","org.Mm.eg.db","org.Rn.eg.db","org.Sc.sgd.db","org.Dm.eg.db","org.At.tair.db","org.Dr.eg.db","org.Bt.eg.db","org.Ce.eg.db","org.Gg.eg.db","org.Cf.eg.db","org.Ss.eg.db","org.Mmu.eg.db","org.EcK12.eg.db","org.Xl.eg.db","org.Pt.eg.db","org.Ag.eg.db","org.Pf.plasmo.db","org.EcSakai.eg.db"))


ui <- tagList(
  dashboardPage(
    skin = "purple",
    dashboardHeader(title = "ClusterProfShinyGSEA"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("User Guide", tabName = "introTab", icon = icon("info-circle")),
        menuItem("Input Data", tabName = "datainput", icon = icon("upload")),
        menuItem("gseGO Results", tabName = "gseGoTab", icon = icon("th")),
        menuItem("gseKegg Results", tabName = "gseKeggTab", icon = icon("th")),
        menuItem("Go Plots", tabName = "goplotsTab", icon = icon("bar-chart")),
        menuItem("KEGG Plots", tabName = "keggPlotsTab", icon = icon("bar-chart")),
        menuItem("Pathview Plots", tabName = "pathviewTab", icon = icon("bar-chart")),
        menuItem("PubMed GO Trends", tabName = "pubmedTab", icon = icon("bar-chart"))
      )
    ),
    dashboardBody(
      shinyjs::useShinyjs(),
      extendShinyjs(script = "www/custom.js"),
      tags$head(
        tags$style(HTML(
          " .shiny-output-error-validation {color: darkred; }"
        )),
        tags$style(
          type="text/css",
          "#pathview_plot img {max-width: 100%; width: 100%; height: auto}"),
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
      ),
      tabItems(
        source("ui-tab-intro.R", local = TRUE)$value,
        source("ui-tab-inputdata.R", local = TRUE)$value,
        source("ui-tab-gseGo.R", local = TRUE)$value,
        source("ui-tab-gseKegg.R", local = TRUE)$value,
        source("ui-tab-goplots.R", local = TRUE)$value,
        source("ui-tab-keggplots.R", local = TRUE)$value,
        source("ui-tab-pathview.R", local = TRUE)$value,
        source("ui-tab-pubmed.R", local = TRUE)$value
      )
      
    )
    
  ),
  tags$footer(
    wellPanel(
      HTML(
        '
        <p align="center" width="4">Core Bioinformatics, Center for Genomics and Systems Biology, NYU Abu Dhabi</p>
        <p align="center" width="4">Github: <a href="https://github.com/nasqar/ClusterProfShiny/">https://github.com/nasqar/ClusterProfShiny/</a></p>
        <p align="center" width="4">Maintained by: <a href="ay21@nyu.edu">Ayman Yousif</a> </p>
        <p align="center" width="4">Using ClusterProfiler</p>
        <p align="center" width="4"><strong>Acknowledgements: </strong></p>
        <p align="center" width="4">1) <a href="https://github.com/GuangchuangYu/clusterProfiler" target="_blank">GuangchuangYu/clusterProfiler</a></p>
        <p align="center" width="4">2) <a href="https://learn.gencore.bio.nyu.edu/rna-seq-analysis/gene-set-enrichment-analysis/" target="_blank">Mohammed Khalfan - Gene Set Enrichment Tutorial </a></p>
        <p align="center" width="4">Copyright (C) 2019, code licensed under GPLv3</p>'
        )
      ),
    tags$script(src = "imgModal.js")
    )
  )