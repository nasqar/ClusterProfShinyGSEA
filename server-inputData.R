
observe({
  
  shinyjs::hide(selector = "a[data-value=\"gseGoTab\"]")
  shinyjs::hide(selector = "a[data-value=\"gseKeggTab\"]")
  shinyjs::hide(selector = "a[data-value=\"goplotsTab\"]")
  shinyjs::hide(selector = "a[data-value=\"keggPlotsTab\"]")
  shinyjs::hide(selector = "a[data-value=\"pathviewTab\"]")
  shinyjs::hide(selector = "a[data-value=\"pubmedTab\"]")

  inputDataReactive()
  
  
})

inputDataReactive <- reactive({
  
  print("inputting data")
  
  query <- parseQueryString(session$clientData$url_search)
  
  # Check if example selected, or if not then ask to upload a file.
  shiny:: validate(
    need( identical(input$data_file_type,"examplecounts")|(!is.null(input$datafile)),
          message = "Please select a file")
  )
  
  if (!is.null(query[['countsdata']]) ) {
    inFile = decryptUrlParam(query[['countsdata']])
    
    shinyjs::show(selector = "a[data-value=\"datainput\"]")
    shinyjs::disable("data_file_type")
    shinyjs::disable("datafile")
    #js$collapse("uploadbox")
    
  }
  else
  {
    inFile <- input$datafile
    # if (is.null(inFile))
    #   return(NULL)
    #
    # inFile = inFile$datapath
  }
  
  #inFile <- input$datafile
  js$addStatusIcon("datainput","loading")
  
  if (!is.null(inFile) ) {
    
    seqdata <- read.csv(inFile$datapath, header=TRUE, sep=",")
    print('uploaded seqdata')
    if(ncol(seqdata)==1) { # if file appears not to work as csv try tsv
      seqdata <- read.tsv(inFile, header=TRUE)
      print('changed to tsv, uploaded seqdata')
    }
    shiny::validate(need(ncol(seqdata)>1,
                         message="File appears to be one column. Check that it is a comma or tab delimited (.csv) file."))
    
    js$addStatusIcon("datainput","done")
    js$collapse("uploadbox")
    return(list('data'=seqdata))
  }
  else{
    if(input$data_file_type=="examplecounts")
    {
      #data = read.csv("www/exampleData/SRX003935_vs_SRX003924.csv")
      
      data = read.csv("www/exampleData/drosphila_example_de.csv")
      
      
      js$addStatusIcon("datainput","done")
      js$collapse("uploadbox")
      return(list('data'=data))
    }
    return(NULL)
  }
})


output$countdataDT <- renderDataTable({
  tmp <- inputDataReactive()
  
  if(!is.null(tmp))
  {
    tmp$data
  }
  
},
options = list(scrollX = TRUE))

# check if a file has been uploaded and create output variable to report this
output$fileUploaded <- reactive({

    if(!is.null(inputDataReactive()))
    {
      updateSelectInput(session, "geneColumn", choices = names(inputDataReactive()$data))
      updateSelectInput(session, "log2fcColumn", choices = names(inputDataReactive()$data))
      updateSelectInput(session, "padjColumn", choices = names(inputDataReactive()$data))
      
      if(input$data_file_type=="examplecounts")
      {
        updateSelectInput(session, "geneColumn", selected = "X")
        updateSelectInput(session, "log2fcColumn", selected = "log2FoldChange")
        updateSelectInput(session, "padjColumn", selected = "padj")
      }
      
      return(T)
    }
  
  return(F)
    
})
outputOptions(output, 'fileUploaded', suspendWhenHidden=FALSE)


observeEvent(input$nextInitParams,{
  
  js$collapse("iParamsbox")
  
  organismsDbChoices = c("Human (org.Hs.eg.db)"="org.Hs.eg.db","Mouse (org.Mm.eg.db)"="org.Mm.eg.db","Rat (org.Rn.eg.db)"="org.Rn.eg.db",
                         "Yeast (org.Sc.sgd.db)"="org.Sc.sgd.db","Fly (org.Dm.eg.db)"="org.Dm.eg.db","Arabidopsis (org.At.tair.db)"="org.At.tair.db",
                         "Zebrafish (org.Dr.eg.db)"="org.Dr.eg.db","Bovine (org.Bt.eg.db)"="org.Bt.eg.db","Worm (org.Ce.eg.db)"="org.Ce.eg.db",
                         "Chicken (org.Gg.eg.db)"="org.Gg.eg.db","Canine (org.Cf.eg.db)"="org.Cf.eg.db","Pig (org.Ss.eg.db)"="org.Ss.eg.db",
                         "Rhesus (org.Mmu.eg.db)"="org.Mmu.eg.db","E coli strain K12 (org.EcK12.eg.db)"="org.EcK12.eg.db","Xenopus (org.Xl.eg.db)"="org.Xl.eg.db",
                         "Chimp (org.Pt.eg.db)"="org.Pt.eg.db","Anopheles (org.Ag.eg.db)"="org.Ag.eg.db","Malaria (org.Pf.plasmo.db)"="org.Pf.plasmo.db",
                         "E coli strain Sakai (org.EcSakai.eg.db)"="org.EcSakai.eg.db")
  
  updateSelectInput(session, "organismDb", choices = organismsDbChoices)
  
  if(input$data_file_type=="examplecounts"){
    updateSelectInput(session, "organismDb", selected = "org.Dm.eg.db")
    updateSelectInput(session, "pAdjustMethod", selected = "none")
    updateNumericInput(session, "minGSSize", value = 3)
    updateNumericInput(session, "maxGSSize", value = 800)
  }
    
  
  
  js$collapse("createGoBox")
  
})


observeEvent(input$organismDb,{
  if(input$organismDb == "")
    return(NULL)
  
  library(input$organismDb, character.only = T)
  
  annDb = eval(parse(text = input$organismDb))
  keytypes = keytypes(annDb)
  updateSelectInput(session, "keytype", choices = keytypes, selected = "ENSEMBL")
  
})







