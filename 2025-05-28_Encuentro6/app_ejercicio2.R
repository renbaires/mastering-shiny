#librerias

library(shiny)


# Define UI f
ui<-fluidPage( 
  sidebarLayout(
  sidebarPanel(
    p("Suba su base de datos y elija una variable"),
    fileInput("tabla", "Suba su base datos", buttonLabel = "Subir tabla", accept = ".csv"),
    selectInput("Variables","Ingrese la Variable", choices = "variables")
    ),
  mainPanel(
    h3("Muestra de la base de datos"),
    tableOutput("vista"),
    verbatimTextOutput("ttest")
  )
)
)
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  # Upload ---------------------------------------------------------
  basedatos <- reactive({
    req(input$tabla)
    vroom::vroom(input$tabla$datapath)
    
  })
  
  output$vista <- renderTable(head(basedatos()))
  
  #observe({
   # x <- names(basedatos())
    #   updateSelectInput(session, "Variables",
     #                 #label = paste("Select input label", length(x)),
      #                choices = x
                      #,
                      #selected = tail(x, 1)
  #  )
  #})
 
  
  # create the select input based on the numeric columns in the dataframe
  observeEvent(input$tabla, {
    req(basedatos())
    num_cols <- dplyr::select_if(basedatos(), is.numeric)
    updateSelectInput(session, "Variables", choices = colnames(num_cols))
  })
  
  # print t-test results
  output$ttest <- renderPrint({
    if(!is.null(input$Variables))
      t.test(basedatos()[input$Variables])
  }) 
}
 

# Run the application 
shinyApp(ui = ui, server = server)
