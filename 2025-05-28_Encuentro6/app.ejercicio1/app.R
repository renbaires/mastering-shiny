#


library(shiny)
library(ambient)

nw <- noise_worley(
  dim,
  frequency = 0.01,
  distance = "euclidean",
  fractal = "none",
  octaves = 3,
  lacunarity = 2,
  gain = 0.5,
  value = "cell",
  distance_ind = c(1, 2),
  jitter = 0.45,
  pertubation = "none",
  pertubation_amplitude = 1
)

gridej <- long_grid(seq(1, 10, length.out = 1000), seq(1, 10, length.out = 1000))
grid$noise <- gen_worley(grid$x, grid$y, value = 'distance')
plot(gridej, noise)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
   titlePanel("EJEMPLO DE UTILIZACION DEL PAQUETE AMBIENT"),

   column(12, plotOutput("plot")),
   column(12,downloadButton("dl", "Descarga el archivo .PNG"))

)

# Define server logic required to draw a histogram
server <- function(input, output) {
 output$plot <- renderPlot(gridej)
 
 output$dl <- downloadHandler(
  
  filename = paste("Histograma", input$Exten, sep = "."),
  content = function(file) {
    ggsave(file, plot_output(), device = input$Exten)}
    
)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
