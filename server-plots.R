output$dotPlot = renderPlot({
  withProgress(message = "Plotting dotplot ...",{
  go_gse = gseGoReactive()$go_gse
  
  dotplot(go_gse, 
          #drop = TRUE, 
          showCategory = input$showCategory_dot, 
          #title = "GO Biological Pathways",
          font.size = 8,
          split=".sign") + facet_grid(.~.sign)
  })
  
})

output$gsePlotMap = renderPlot({
  withProgress(message = "Plotting  enrichment map ...",{
    go_gse = gseGoReactive()$go_gse
  
    emapplot(go_gse, showCategory = input$showCategory_enrichmap)
  })
  
})


output$ridgePlot = renderPlot({
  withProgress(message = "Plotting ridgeplot ...",{
    go_gse = gseGoReactive()$go_gse
    
    ridgeplot(go_gse, 
            showCategory = input$showCategory_ridge
            )
  })
  
})



output$gseaplot = renderPlot({
  withProgress(message = "Plotting  gsea plot ...",{
  
  go_gse = gseGoReactive()$go_gse
  
  # Use the `Gene Set` param for the index in the title, and as the value for geneSetId
  gseaplot(go_gse, by = "all", title = go_gse$Description[input$geneSetId_gsea], geneSetID = input$geneSetId_gsea)
  
  #goplot(go_gse, showCategory = input$showCategory_goplot)
  
  })
  
})

output$cnetplot = renderPlot({
  
  withProgress(message = "Plotting Gene-Concept Network ...",{
  go_gse = gseGoReactive()$go_gse
  
  cnetplot(go_gse, categorySize="pvalue", foldChange=myValues$gene_list, showCategory = input$showCategory_cnet)
  })
  
})



### KEGG


output$dotPlot_kegg = renderPlot({
  withProgress(message = "Plotting dotplot ...",{
    kegg_gse = gseGoReactive()$kegg_gse
    
    dotplot(kegg_gse, 
            #drop = TRUE, 
            showCategory = input$showCategory_dot_kegg, 
            title = "Enriched Pathways",
            font.size = 8)
  })
  
})

output$gsePlotMap_kegg = renderPlot({
  withProgress(message = "Plotting Enrichment Map ...",{
    kegg_gse = gseGoReactive()$kegg_gse
    
    emapplot(kegg_gse, showCategory = input$showCategory_enrichmap_kegg)
    
  })
  
})


output$cnetplot_kegg = renderPlot({
  
  withProgress(message = "Plotting Gene-Concept Network ...",{
    kegg_gse = gseGoReactive()$kegg_gse
    
    cnetplot(kegg_gse, categorySize="pvalue", foldChange=myValues$kegg_gene_list, showCategory = input$showCategory_cnet_kegg)
  })
  
})

output$ridgePlot_kegg = renderPlot({
  withProgress(message = "Plotting ridgeplot ...",{
    kegg_gse = gseGoReactive()$kegg_gse
    
    ridgeplot(kegg_gse, 
              showCategory = input$showCategory_ridge_kegg
    )
  })
  
})



output$gseaplot_kegg = renderPlot({
  withProgress(message = "Plotting  gsea plot ...",{
    
    kegg_gse = gseGoReactive()$kegg_gse
    
    # Use the `Gene Set` param for the index in the title, and as the value for geneSetId
    gseaplot(kegg_gse, by = "all", title = kegg_gse$Description[input$geneSetId_gsea_kegg], geneSetID = input$geneSetId_gsea_kegg)
    
    
  })
  
})



pathviewReactive = eventReactive(input$generatePathview,{
  withProgress(message = 'Plotting Pathview ...', {
  
    isolate({
      kegg_gse = gseGoReactive()$kegg_gse
      
      setProgress(value = 0.3, detail = paste0("Pathview ID ",input$pathwayIds," ..."))
      dme <- pathview(gene.data=myValues$gene_list, pathway.id=input$pathwayIds, species = myValues$organismKegg, gene.idtype=input$geneid_type)
      file.copy(paste0(input$pathwayIds,".pathview.png"),paste0("testimage"))
      
      setProgress(value = 0.7, detail = paste0("Pathview ID ",input$pathwayIds," generating pdf ..."))
      dmePdf <- pathview(gene.data=myValues$gene_list, pathway.id=input$pathwayIds, species = myValues$organismKegg, gene.idtype=input$geneid_type,kegg.native = F)
      
      myValues$imagePath = paste0(input$pathwayIds,".pathview.")
      return(list(
        src = paste0("testimage"),
        filetype = "image/png",
        alt = "pathview image"
      ))
    })
    
})
})

output$pathview_plot  = renderImage({
  
    return(pathviewReactive())
    
})

output$pathviewPlotsAvailable <-
  reactive({
    return(!is.null(pathviewReactive()))
  })
outputOptions(output, 'pathviewPlotsAvailable', suspendWhenHidden=FALSE)

output$downloadPathviewPng <- downloadHandler(
  filename = function()  {paste0(myValues$imagePath,"png")},
  content = function(file) {
    file.copy(paste0(getwd(),'/',myValues$imagePath,"png"), file)
  }
)

output$downloadPathviewPdf <- downloadHandler(
  filename = function()  {paste0(myValues$imagePath,"pdf")},
  content = function(file) {
    file.copy(paste0(getwd(),'/',myValues$imagePath,"pdf"), file)
  }
)


output$pmcPlot = renderPlotly({
  withProgress(message = "Generating  pmc plot ...",{
    
    if(input$plotTrends)
    {
      isolate({
        
        go_gse = gseGoReactive()$go_gse
        
        terms <- input$pubmedTerms
        if(is.null(terms))
          return(NULL)
        pmcplot(terms, seq(input$year_from,input$year_to), proportion=FALSE)
      })
      
    }
    
    
  })
  
})
