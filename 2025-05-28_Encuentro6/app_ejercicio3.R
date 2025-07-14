#librerias

library(shiny)
library(plotly)


# Define UI f
ui<-fluidPage( 
  sidebarLayout(
  sidebarPanel(
    p("Suba su base de datos y elija una variable"),
    fileInput("tabla", "Suba su base datos", buttonLabel = "Subir tabla", accept = ".csv"),
    selectInput("Variables","Ingrese la Variable", choices = NULL),
    selectInput("Exten", "Tipo Archivo Descarga", choices = c("png", "pdf", "svg"))
    ),
  mainPanel(
    h3("Muestra de la base de datos"),
    tableOutput("vista"),
    plotlyOutput("histo"),
    downloadButton("dl", "Descarga tu histograma")
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
 
  
  # create the select input based on the numeric columns in the dataframe
  observeEvent(input$tabla, {
    req(basedatos())
    num_cols <- dplyr::select_if(basedatos(), is.numeric)
    updateSelectInput(session, "Variables", choices = colnames(num_cols))
  })
  
  # print t-test results
  histo <- reactive({
    if(!is.null(input$Variables))
    plot_ly(x = input$Variables, type = "histogram")
  })
  
  output$histo <- renderPlotly(histo())  
  
  output$dl <- downloadHandler(
    
    filename = paste("Histograma", input$Exten, sep = "."),
    content = function(file) {
      ggsave(file, plot_output(), device = input$Exten)
    }
  )
  
  
}
 

# Run the application 
shinyApp(ui = ui, server = server)
