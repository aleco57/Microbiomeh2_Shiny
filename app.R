# Now we want to make a script to plot our h2 outputs and find consistent h2 signal

library(shiny)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(viridis) 
library(plotly)
library(DT)
library(rlang)
library(scales)

load("dataforplots.RData")

#Lets remove MiBioGen Twins data and Ruhl as they overlap or were not reported by the original GWAS
h2_clean <- h2_clean %>%
  filter(population != "MiBioGen_Twins_2022" & population != "Ruhl_2021")

# UI
ui <- fluidPage(
  titlePanel("Interactive h² Plot"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("taxonomy", "Select Taxonomy Level:",
                  choices = names(all_traits_map_split),
                  selected = "Phylum"),
      uiOutput("trait_select")
    ),
    
    mainPanel(
      plotlyOutput("h2_plot", height = "600px"),
      br(),
      h4("Raw Data Table"),
      dataTableOutput("results_table")  
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Dynamic UI for trait selection
  output$trait_select <- renderUI({
    taxonomy_column <- input$taxonomy
    traits <- unique(all_traits_map_split[[taxonomy_column]]$clean_traits)
    selectInput("trait", "Select Trait:",
                choices = traits,
                selected = traits[1])
  })
  
  # Plot rendering
  output$h2_plot <- renderPlotly({
    req(input$trait)  # ensure trait input is available
    
    taxonomy_column <- input$taxonomy
    selected_trait <- input$trait
    
    traits2 <- all_traits_map_split[[taxonomy_column]] %>%
      filter(clean_traits == selected_trait) %>%
      select(-taxonomy, -clean_traits) %>%
      unlist(use.names = F) %>% 
      na.omit()
    
    # Filter data safely
    filtered_data <- h2_clean %>%
      filter(Taxon %in% traits2)
    
    # Create ggplot with tooltip text
    p <- ggplot(filtered_data, aes(x = reorder(population, H2), y = H2, color = method,
                                   text = paste0("Population: ", population,
                                                 "<br>H2: ", round(H2, 2),
                                                 "<br>95%CI: ", paste0(round(lower_CI, 2), "-", round(upper_CI, 2))))) +
      geom_errorbar(aes(ymin = lower_CI, ymax = upper_CI), width = 0.15, size = 0.7) +
      geom_point(size = 4, shape = 21, stroke = 1.2, fill = "white") +
      scale_color_viridis_d(option = "plasma", end = 0.9) +
      #Add a red dashed line through 0 
      geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      coord_flip() +
      labs(
        title = paste("Heritability (h²) for", selected_trait),
        y = expression("Heritability"),
        x = "Population / Study",
        color = "Estimation Method"
      ) +
      theme_bw(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", size = 16),
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 13),
        legend.position = "right",
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
      )
    
    ggplotly(p, tooltip = "text")  # Make it interactive
  })
  
 ## Output raw data table
 output$results_table <- renderDataTable({
   req(input$trait)
   
   taxonomy_column <- input$taxonomy
   selected_trait <- input$trait
   
   traits2 <- all_traits_map_split[[taxonomy_column]] %>%
     filter(clean_traits == selected_trait) %>%
     select(3:14) %>%
     unlist(use.names = F) %>% 
     na.omit()
   
   h2_clean %>%
     filter(Taxon %in% traits2) %>%
     #Make all numeric columns rounded to 3 decimal places, except p value
     mutate(across(where(is.numeric) & !matches("^p$"), ~ round(., 3))) %>%
     mutate(p = formatC(p, format = "e", digits = 1)) %>%
     select(population, method, H2, lower_CI, upper_CI, p)
   })
  
}

shinyApp(ui = ui, server = server)


