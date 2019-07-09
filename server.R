
# Max upload size
options(shiny.maxRequestSize = 60*1024^2)

# Define server 
server <- function(input, output, session) {
  
  source("server-inputData.R",local = TRUE)
  # 
  source("server-gseGo.R",local = TRUE)
  # 
  source("server-plots.R",local = TRUE)
  
  
  GotoTab <- function(name){
    #updateTabItems(session, "tabs", name)
    
    shinyjs::show(selector = paste0("a[data-value=\"",name,"\"]"))
    
    shinyjs::runjs("window.scrollTo(0, 0)")
  }
}