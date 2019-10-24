
myValues = reactiveValues()

observe({
  gseGoReactive()
})

gseGoReactive <- eventReactive(input$initGo,{
  
  withProgress(message = "Processing , please wait",{
    
    isolate({
      
      # remove notifications if they exist
      removeNotification("errorNotify")
      removeNotification("errorNotify1")
      removeNotification("errorNotify2")
      removeNotification("warnNotify")
      removeNotification("warnNotify2")
      
      validate(need(tryCatch({
        df <- inputDataReactive()$data
        # we want the log2 fold change 
        original_gene_list <- df[[input$log2fcColumn]]
        
        # name the vector
        names(original_gene_list) <- df[[input$geneColumn]]
        
        # omit any NA values 
        gene_list<-na.omit(original_gene_list)
        
        # sort the list in decreasing order (required for clusterProfiler)
        gene_list = sort(gene_list, decreasing = TRUE)
        
        myValues$gene_list = gene_list
        
        
        # 
        
        setProgress(value = 0.3, detail = "Performing GSE analysis, please wait ...")
        
        # go_gse <- gseGO(gene = genes,
        #                       universe = names(gene_list),
        #                       
        #                       readable = T,
        #                       qvalueCutoff = input$qvalCuttoff)
        go_gse <- gseGO(geneList=gene_list, 
                     ont = input$ontology, 
                     keyType = input$keytype, 
                     nPerm = input$nPerm, 
                     minGSSize = input$minGSSize, 
                     maxGSSize = input$maxGSSize, 
                     pvalueCutoff = input$pvalCuttoff, 
                     verbose = T, 
                     OrgDb = input$organismDb, 
                     pAdjustMethod = input$pAdjustMethod)
        
        if(nrow(go_gse) < 1)
        {
          showNotification(id="warnNotify", "No gene can be mapped ...", type = "warning", duration = NULL)
          showNotification(id="warnNotify2", "Tune the parameters and try again.", type = "warning", duration = NULL)
          return(NULL)
        }
        
        updateNumericInput(session, "showCategory_bar", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        updateNumericInput(session, "showCategory_dot", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        updateNumericInput(session, "showCategory_enrichmap", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        updateNumericInput(session, "showCategory_goplot", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        updateNumericInput(session, "showCategory_cnet", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        
        updateNumericInput(session, "showCategory_bar_kegg", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        updateNumericInput(session, "showCategory_dot_kegg", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        updateNumericInput(session, "showCategory_enrichmap_kegg", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        #updateNumericInput(session, "showCategory_goplot", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        updateNumericInput(session, "showCategory_cnet_kegg", max = nrow(go_gse@result) , min = 0, value = ifelse(nrow(go_gse@result) > 0, 5,0))
        
        
        updateSelectizeInput(session,'pubmedTerms', choices=go_gse@result$Description)
        
        ## KEGG gse
        
        # Convert gene IDs for gseKEGG function
        # We will lose some genes here because not all IDs will be converted
        myValues$convWarningMessage = capture.output(ids<-bitr(names(original_gene_list), fromType = input$keytype, toType = "ENTREZID", OrgDb=input$organismDb), type = "message")
        
        # remove duplicate IDS (here I use "ENSEMBL", but it should be whatever was selected as keyType)
        dedup_ids = ids[!duplicated(ids[c(input$keytype)]),]
        
        # Create a new dataframe df2 which has only the genes which were successfully mapped using the bitr function above
        #df2 = df[df$X %in% dedup_ids$ENSEMBL,]
        #df2 = df[df$X %in% dedup_ids[,1],]
        df2 = df[df[[input$geneColumn]] %in% dedup_ids[,1],]
        
        # Create a new column in df2 with the corresponding ENTREZ IDs
        df2$Y = dedup_ids$ENTREZID
        
        # Create a vector of the gene unuiverse
        kegg_gene_list <- df2[[input$log2fcColumn]]
        
        # Name vector with ENTREZ ids
        names(kegg_gene_list) <- df2$Y
        
        # omit any NA values 
        kegg_gene_list<-na.omit(kegg_gene_list)
        
        # sort the list in decreasing order (required for clusterProfiler)
        kegg_gene_list = sort(kegg_gene_list, decreasing = TRUE)
        # 
        # myValues$kegg_gene_list = kegg_gene_list
        # 
        # # Exctract significant results from df2
        # # ALLOW USERS TO EDIT 0.05 AS A PARAMETER
        # kegg_sig_genes_df = subset(df2, padj < input$padjCutoff)
        # 
        # # From significant results, we want to filter on log2fold change
        # kegg_genes <- kegg_sig_genes_df[[input$log2fcColumn]]
        # 
        # # Name the vector with the CONVERTED ID!
        # names(kegg_genes) <- kegg_sig_genes_df$Y
        # 
        # # omit NA values
        # kegg_genes <- na.omit(kegg_genes)
        # 
        # # filter on log2fold change (PARAMETER)
        # kegg_genes <- names(kegg_genes)[abs(kegg_genes) > input$logfcCuttoff]
        
        
        setProgress(value = 0.6, detail = "Performing KEGG enrichment analysis, please wait ...")
        
        organismsDbKegg = c("org.Hs.eg.db"="hsa","org.Mm.eg.db"="mmu","org.Rn.eg.db"="rno",
                            "org.Sc.sgd.db"="sce","org.Dm.eg.db"="dme","org.At.tair.db"="ath",
                            "org.Dr.eg.db"="dre","org.Bt.eg.db"="bta","org.Ce.eg.db"="cel",
                            "org.Gg.eg.db"="gga","org.Cf.eg.db"="cfa","org.Ss.eg.db"="ssc",
                            "org.Mmu.eg.db"="mcc","org.EcK12.eg.db"="eck","org.Xl.eg.db"="xla",
                            "org.Pt.eg.db"="ptr","org.Ag.eg.db"="aga","org.Pf.plasmo.db"="pfa",
                            "org.EcSakai.eg.db"="ecs")
        
        kegg_gse <- gseKEGG(geneList=kegg_gene_list, 
                            organism=organismsDbKegg[input$organismDb],
                            nPerm = input$nPerm, 
                            minGSSize = input$minGSSize, 
                            maxGSSize = input$maxGSSize, 
                            pvalueCutoff = input$pvalCuttoff,
                            pAdjustMethod = input$pAdjustMethod,
                            keyType = input$keggKeyType)
        
        myValues$organismKegg = organismsDbKegg[input$organismDb]
        
        updateSelectInput(session, "geneid_type", choices = gene.idtype.list, selected = input$keytype)
        updateSelectizeInput(session,'pathwayIds', choices=kegg_gse@result$ID)
        
      }, error = function(e) {
        myValues$status = paste("Error: ",e$message)
        
        showNotification(id="errorNotify", myValues$status, type = "error", duration = NULL)
        showNotification(id="errorNotify1", "Make sure the right organism was selected", type = "error", duration = NULL)
        showNotification(id="errorNotify2", "Make sure the corresponding required columns are correctly selected", type = "error", duration = NULL)
        return(NULL)
      }
      
      ), 
      "Error merging files. Check!"))
      
      
    })
    
    shinyjs::show(selector = "a[data-value=\"pubmedTab\"]")
    shinyjs::show(selector = "a[data-value=\"wordcloudTab\"]")
    shinyjs::show(selector = "a[data-value=\"pathviewTab\"]")
    shinyjs::show(selector = "a[data-value=\"keggPlotsTab\"]")
    shinyjs::show(selector = "a[data-value=\"goplotsTab\"]")
    shinyjs::show(selector = "a[data-value=\"gseKeggTab\"]")
    shinyjs::show(selector = "a[data-value=\"gseGoTab\"]")
    
    return(list('go_gse'=go_gse, 'kegg_gse' = kegg_gse))
    
  })
})



output$gseGoTable <- renderDataTable({
  gseGo <- gseGoReactive()
  
  if(!is.null(gseGo)){
    resultDF = gseGo$go_gse@result
    
    DT::datatable(resultDF, options = list(scrollX = TRUE, columnDefs = list(list(visible=input$showAllColumns, targets= 10:12 )) ))
  }
  
})

output$downloadgseGoCSV <- downloadHandler(
  filename = function()  {paste0("gsego",".csv")},
  content = function(file) {
    write.csv(gseGoReactive()$go_gse@result, file, row.names=TRUE)}
)

output$gseGoAvailable <-
  reactive({
    return(!is.null(gseGoReactive()$go_gse))
  })
outputOptions(output, 'gseGoAvailable', suspendWhenHidden=FALSE)


output$gseKEGGTable <- renderDataTable({
  gseKEGG <- gseGoReactive()
  
  if(!is.null(gseKEGG)){
    resultDF = gseKEGG$kegg_gse@result
    
    DT::datatable(resultDF, options = list(scrollX = TRUE, columnDefs = list(list(visible=input$showAllColumns_kegg, targets= 10:11 ))))
  }
  
},
options = list(scrollX = TRUE))

output$downloadgseKEGGCSV <- downloadHandler(
  filename = function()  {paste0("gseKEGG",".csv")},
  content = function(file) {
    write.csv(gseGoReactive()$kegg_gse@result, file, row.names=TRUE)}
)

output$gseKEGGAvailable <-
  reactive({
    return(!is.null(gseGoReactive()$kegg_gse))
  })
outputOptions(output, 'gseKEGGAvailable', suspendWhenHidden=FALSE)


output$warningText <- renderText({
  
  outputText = myValues$convWarningMessage
  if(length(outputText) == 3)
    outputText[3] = paste0('<strong>',outputText[3],'</strong>')
  
  paste("<p>",outputText,"</p>")
})

observeEvent(input$gotoGoPlots, {
  GotoTab('goplotsTab')
})

observeEvent(input$gotoKeggPlots, {
  GotoTab('keggPlotsTab')
})

observeEvent(input$gotoPathview, {
  GotoTab('pathviewTab')
})

observeEvent(input$gotoPubmed, {
  GotoTab('pubmedTab')
})