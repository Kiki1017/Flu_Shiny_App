

ui <- fluidPage(
  
  # NOTE - Functions to access the www folder (e.g. theme = and src = for images) were unsuccessful (folder permissions maybe?)
  
  #Bring in extra CSS to style application
  includeCSS("fluapp.css"),
  
  #Add Google analytics global tracking code
  tags$head(HTML('<script async src="https://www.googletagmanager.com/gtag/js?id=UA-107917571-1"></script>')),
  tags$head(tags$script(HTML(" window.dataLayer = window.dataLayer || [];
                              function gtag(){dataLayer.push(arguments);}
                              gtag('js', new Date());
                              gtag('config', 'UA-107917571-1')"))),
  
  #Building the header 
  fluidRow(class = "header",
           column(class = "headimg", 2, align = "center", img(class = "imggen", src="https://www.cookcountypublichealth.org/wp-content/uploads/2018/12/CookCountyLogo.png", alt="CCDPH Logo")), 
           column(class = "headtitle", 10, HTML('
                                                <h1 style="font-weight: 700; font-size: 40px">Weekly Influenza Surveillance Data</h1>
                                                '))
           ),
  #Starting nav bar
  navbarPage("Menu", id = "menu", windowTitle = "Cook County Flu Surveillance",
    tabPanel("Home",
             #Building Vertical strip of images on home page
             fluidRow(
               column(2, style = "padding-right: 50px;",
                      fluidRow(
                        column(12, class = "homestrip", img(src="https://phil.cdc.gov/PHIL_Images/11213/11213_lores.jpg", class = "img-responsive imggen"))
                      ),
                      fluidRow(
                        column(12, class = "homestrip", img(src="https://phil.cdc.gov/PHIL_Images/11213/11213_lores.jpg", class = "img-responsive imggen"))
                      ),
                      fluidRow(
                        column(12, class = "homestrip", img(src="https://phil.cdc.gov/PHIL_Images/11213/11213_lores.jpg", class = "img-responsive imggen"))
                      )
               ),
               #Building home page text    
               
               column(7, h4(strong("Cook County Department of Public Health Weekly Influenza Surveillance"), style = "padding-bottom: 10px; padding-top: 5px"),
                      # p(id="risk", "As of ",strong(paste("Week", week))," the risk of influenza in Suburban Cook
                      #       County is ", strong(paste0(toupper(risk_level), "."))),   
                     p(id="risk", "Surveillance for the 2019-2020 influenza season has been suspended due to the demands of the COVID-19 response. We
                       apologize for the inconvenience and appreciate your understanding. A selection of our ILI metrics are being monitored weekly and can be viewed ",
                       a(href = "https://ccdphcd.shinyapps.io/covid19/", "here.", target = "_blank")),
                     p("The Cook County Department of Public Health collects and analyzes data on local influenza activity year-round. During periods when higher
                        influenza activity is expected (from MMWR Week 40 through MMWR Week 20*), this information is compiled into a weekly surveillance
                       report that is distributed to our partners in the healthcare community, schools, community groups, and the public. This application
                       is a companion to our weekly surveillance report. Copies of the reports can be found",
                       a(href = "https://www.cookcountypublichealth.org/data-reports/communicable-disease-data-reports/", "here."), "Please click ", 
                       a(href = "mailto:kbemis@cookcountyhhs.org?Subject=Shiny%20Flu%20App", "here"), " to send comments or questions on this application.", align = "justify", style = "padding-bottom: 10px"),
                     p("Influenza surveillance data is collected from multiple sources including emergency department (ED) visits, visits to outpatient
                       sentinel healthcare providers, laboratory tests, intensive-care unit (ICU) hospitalizations, and deaths. The goal of influenza
                       surveillance is to determine when and where influenza activity is occuring, what influenza viruses are circulating, and the amount of
                       severe outcomes, such as hospitalizations and deaths, that can be attributed to influenza. Data in this application will be updated
                       on Friday afternoons.", align = "justify", style = "padding-bottom: 10px"),
                     p("*The Centers for Disease Control and Prevention aggregates influenza data by ", a(href = "https://wwwn.cdc.gov/nndss/document/W2018-19.pdf",
                        "MMWR Weeks. "), "MMWR Weeks run from Sunday to Saturday. For simplicity, graphs in this application typically display the first day of the MMWR Week 
                        on the x axis. Starting dates are accurate for 2019 and 2020 but are approximations for all other years displayed."),
                     p(id = "info", "For more information on influenza, please visit the Centers for Disease Control and Prevention at ",
                       a(href = "https://www.cdc.gov/flu/", "https://www.cdc.gov/flu/. "), "Information and recommendations for healthcare professionals
                       can be found ", a(href = "https://www.cdc.gov/flu/professionals/index.htm", "here.")),
                     tags$small("The Cook County Department of Public Health would like to thank all of our surveillance partners for their help in collecting
                                 this information.",style = "font-style: italic")
               )
             ) #fluid Row closure
    ),#Home Tab Panel closure
    tabPanel("ED Data", id = "ED_Data", #ids added to potentially use in Google Analytics event tracking, may need modification for code to function
    
                      
#==========================================ED DATA BY SEASON (UI)=============================================================#          
  
  #Building the intro title and data source description
      fluidRow(
           column(4, h3(strong("Emergency Department Visits"), style = "padding-bottom: 10px; padding-top: 5px"), 
                  p("Emergency department data are extracted from the Illinois syndromic surveillance system, which is supported
                    by the CDC's National Syndromic Surveillace Program. All acute-care hospitals in Illinois report
                    emergency department data to this system. The graphs display the proportion of emergency room visits that were for influenza-like illness(ILI) among Suburban Cook County residents. 
                    ILI is defined as fever plus cough or sore throat.", 
                    align = "justify", style = "padding-bottom: 10px"))
      ),
  
  #Using Shiny built-in layout for graphs and control panel
      sidebarLayout(
    
    #Building the control panel to select which seasons to display
        sidebarPanel(
      
          checkboxGroupInput(inputId = "seasonpick", #inputID is used in server function to subset user-selected data 
                         label = "Display ED Data by Season for Suburban Cook County", 
                         choiceNames = list("2019-20", "Average of All Seasons Since 2010", "Average of H1N1 Seasons", "Average of H3N2 Seasons", 
                                             "2018-19 (H1N1 Predominant)",
                                            "2017-18 (H3N2 Predominant)", "2016-17 (H3N2 Predominant)", "2015-16 (H1N1 Predominant)", 
                                            "2014-15 (H3N2 Predominant)*","2013-14 (H1N1 Predominant)","2012-13 (H3N2 Predominant)",
                                            "2011-12 (H3N2 Predominant)", "2010-11 (Mixed Strain Predominant)"),
                         choiceValues = list("2019-20", "Average All Seasons", "Average H1N1 Seasons", "Average H3N2 Seasons", "2018-19", "2017-18",
                                             "2016-17", "2015-16", "2014-15", "2013-14", "2012-13", "2011-12", "2010-11"),
                         selected = "2019-20"),
      
          p("Include the 2018-19 Baseline?", tags$sup(HTML('&#167'), style = "font-weight: normal"), style = "font-weight: bold"),
      
          checkboxInput(inputId = "baselinecheck", label = "2019-20 Baseline", value = TRUE),
          
      #Adding footnotes  
          tags$div(tags$small("* Influenza surveillance data are aggregated by MMWR week. Most years have 52 weeks; however some have 53 weeks. 
                     2014 was a 53-week year. Because the last week of the calendar year is epidemiologically important for flu transmission, we have 
                     graphed Week 53 of the 2014-15 season with Week 52 of the other flu seasons. Consequently, all other data points prior to Week 53 
                     for the 2014-15 season have been moved forward one week, i.e., Week 52 displayed as Week 51, and so on.",
                     style = "font-style: italic"), style = "padding-bottom: 10px"),
      
          tags$div(tags$small(HTML('&#167'), "The baseline value reflects the expected proportion of ED visits for ILI during 'non-influenza' weeks. Non-influenza weeks are defined as 
                 periods of two or more consecutive weeks in which each week accounted for less than 2% of the season's total number of specimens that 
                 tested positive for influenza. Data from the previous three influenza seasons are used to calculate the baseline value.",
                 style = "font-style: italic; "))
        ),#ED season sidebarpanel closure
    
    #Building main panel with plot and download functionality
       mainPanel(
          div(  #Mirroring code from hover code credit in server function
            style = "position:relative", #Mirroring code from code credit
            
            #Displays plot from server function and stores mouse data when user hovers over point
            plotOutput("seasonplot", hover = hoverOpts("plot_hover_season", delay = 100, delayType = "debounce")), 
            
            uiOutput("hover_info_season"), #Displays values from server function to select data for hovered-over point
            
            downloadButton('downloadseason', 'Download Image')
          )
        )#ED season mainpanel closure
      ),#ED season sidebarlayout closure
  

  #==========================================ED DATA BY AGE (UI)=============================================================#
      div(style = "padding-top: 50px; padding-bottom: 30px", 
      
      #See code comments from ED DATA BY SEASON section
      sidebarLayout(
    
        sidebarPanel(
      
          checkboxGroupInput(inputId = "agepick", 
                         label = "Display ED Data by Age for Suburban Cook County*", 
                         choiceNames = list("0-4 year olds", "5-17 year olds","18-44 year olds","45-64 year olds", "65 years and older","All age groups"), 
                         choiceValues = list("0-4", "5-17","18-44","45-64", "65+","All"),
                         selected = c("0-4", "5-17","18-44","45-64", "65+","All")),
          
          tags$small("*For the current influenza season", style = "font-style: italic; ")

        ),#ED Age sidebarpanel closure
    
        mainPanel(
          div(  
            style = "position:relative", 
            
            plotOutput("ageplot", hover = hoverOpts("plot_hover_age", delay = 100, delayType = "debounce")),
            
            uiOutput("hover_info_age"), 
            
            downloadButton('downloadage', 'Download Image')
          )
        )#ED Age mainpanel closure
    
       )#ED Age sidebarlayout closure
      )#ED Age panel div closure

    ),#ED TabPanel closure


#==========================================ED DATA MAP (UI)=============================================================# 
    tabPanel("ED Data by Zip Code", id = "ED_Map",
             
      #See code comments from ED DATA BY SEASON section
      sidebarLayout(
        
        sidebarPanel(width = 3,
          
           tags$head(tags$style("#EDmap{height:100vh !important;}")), #ensures map takes up as much vertical space as possible
          
           h3(strong("ED Data by Zip Code"), style = "padding-bottom: 10px"),
          
           p("Emergency department data are extracted from the CCDPH syndromic surveillance system, ESSENCE. Forty-five hospital
              emergency departments participate in ESSENCE, including all hospitals located in Suburban Cook County. The map
            displays the proportion of emergency room visits that were for influenza-like illness(ILI) by the patient's zip code of residence. 
            ILI is defined as fever plus cough or sore throat.", align = "justify", style = "padding-bottom: 10px"),
           
           sliderInput(inputId = "mapweek",
                      label = "Drag the slider to select the week of interest* or click play to see an animation of all weeks to date:",
                      min = MMWRweek2Date(season, 35, 1), max = start, step = 7, ticks = FALSE, 
                      value = start, timeFormat = "%m-%d-%y",
                      animate = animationOptions(interval = 1200)),
          
           checkboxInput(inputId = "hosploc", label = "Show hospital locations on map?"),
           
           tags$div(tags$small("* Week starting date is displayed.",
                               style = "font-style: italic")) #, style = "padding-bottom: 10px")
          
        ), #ED map sidebar panel closure
        
        mainPanel(    
      
          leafletOutput("EDmap")
    
        ) #ED Map main panel closure
      ) #ED Map sidebay layout closure
    ),#ED Map TabPanel closure
#==========================================LAB DATA (UI)=============================================================#
   
    tabPanel("Laboratory Data", id = "Lab",
             
      fluidRow(
        column( 4, h3(strong("Laboratory Specimen Data"), style = "padding-bottom: 10px; padding-top: 5px"), 
                             p("Laboratory testing data for influenza are submitted on a weekly basis from the following laboratories: 
                                Illinois Department of Public Health Sentinel Laboratories, NorthShore University Health System, 
                                Loyola University Medical Center, and ACL Laboratories. Laboratories submit aggregate data for all influenza tests 
                                performed; therefore, data contains results for individuals that reside outside of suburban Cook County. 
                                Tests include viral culture, RT-PCR, and rapid antigen tests.", align = "justify", style = "padding-bottom: 10px"))
        ),
          
          #See code comments from ED DATA BY SEASON section   
          sidebarLayout(
               
             sidebarPanel(
                 
                 p("Display Laboratory Data by Influenza Strain", style = "font-weight: bold"),
               
                 radioButtons(inputId = "labbartype", 
                                    label = "Choose type of bar graph:", 
                                    choiceNames = list("Stacked ", "Side-by-Side"), 
                                    choiceValues = list("stack", "dodge"),
                                    selected = "stack"),
                                    #selected = "dodge"),
                 
                 checkboxGroupInput(inputId = "labbarstrain", 
                              label = "Select strains to display:", 
                              choices = list("A (H1N1)", "A (H3N2)", "A (Unknown Subtype)", "B"),
                              selected = list("A (H1N1)", "A (H3N2)", "A (Unknown Subtype)", "B"))
                              #selected = list("A (H1N1)", "A (H3N2)"))
                              
             ),#lab bar chart sidebarpanel closure
               
               
             mainPanel(
               
                   plotOutput("labbarplot"), 
                   
                   downloadButton('downloadlabbar', 'Download Image')
             )#lab bar chart mainpanel closure
          ),#lab bar chart sidebarlayout closure
      
      div(style = "padding-top: 50px; padding-bottom: 30px", 
        
          #See code comments from ED DATA BY SEASON section  
          sidebarLayout(
            
            sidebarPanel(
              
              checkboxGroupInput(inputId = "labpick", 
                                 label = "Display the Percent of Specimens Testing Positive for Influenza", 
                                 choices = list("2016-17", "2017-18", "2018-19", "2019-20"),
                                 selected = "2019-20") 
              
            ),#lab line chart sidebarpanel closure
            
            mainPanel(
              div(  
                style = "position:relative", 
                
                plotOutput("lablineplot", hover = hoverOpts("plot_hover_labline", delay = 100, delayType = "debounce")),
                
                uiOutput("hover_info_labline"), 
                
                downloadButton('downloadlabline', 'Download Image')
              )
            )#lab line chart  mainpanel closure
            
          )#lab line chart sidebarlayout closure
      )#lab line chart  panel div closure     
    ),#Lab TabPabel closure


#==========================================ICU HOSP (UI)=============================================================#
tabPanel("ICU Hospitalizations", id = "ICU",
         
         fluidRow(
           column( 4, h3(strong("Influenza-associated ICU Hospitalizations"), style = "padding-bottom: 10px; padding-top: 5px"), 
                   p("Individuals hospitalized in an intensive care unit (ICU) with a positive laboratory test for influenza must
                     be reported to the local health department where the patient resides. The Cook County Department of Public Health
                     jurisdiction includes all of suburban Cook County, excluding Evanston, Skokie, Oak Park, and Stickney township.
                     Reported cases are aggregated by week of hospital admission.", align = "justify", style = "padding-bottom: 10px"))
                   ),
         
         #See code comments from ED DATA BY SEASON section
         sidebarLayout(
           
           sidebarPanel(
             
             checkboxGroupInput(inputId = "icuseason", 
                                label = "Display ICU Hospitalizations by Season:", 
                                choiceNames = list( "2016-17 (H3N2 Predominant)", "2017-18 (H3N2 Predominant)", "2018-19 (H1N1 Predominant)",
                                                   "2019-20"), 
                                choiceValues = list("2016-17","2017-18", "2018-19", "2019-20"),
                                selected = "2019-20")
             
           ),#icu sidebarpanel closure
           
           mainPanel(
             
             plotOutput("icuplot"),  
             
             downloadButton('downloadicu', 'Download Image')
           )#icu mainpanel closure
         )#icu sidebarlayout closure
      ),#icu tab closure


#==========================================PI DEATH (UI)=============================================================#

tabPanel("Mortality", id = "PI",
         
         fluidRow(
           column( 4, h3(strong("Pneumonia/Influenza Mortality"), style = "padding-bottom: 10px; padding-top: 5px"), 
                   p("Mortality data is reported for all residents of Cook County, including Chicago. Deaths reported with pneumonia
                     and/or influenza listed as the immediate cause of death or a contributing factor are considered associated with
                     pneumonia/influenza (P/I).", align = "justify", style = "padding-bottom: 5px"))
                   ),
         
         #See code comments from ED DATA BY SEASON section
         sidebarLayout(
           
           sidebarPanel(
             
             p("The smoothed proportion of deaths associated with P/I (3-week running median) is displayed
               in the graph. Mortality data lags one week behind other flu surveillance indicators.", align = "justify", style = "padding-bottom: 5px"),
             
             p("Baseline and epidemic threshold values for P/I mortality are calculated based on the previous four
               years of data using a CDC robust regression model. P/I mortality exceeding the epidemic threshold indicates the
               observed proportion of deaths is significantly higher than would be expected for that time of year, in the absence
               of substantial influenza-related mortality.", align = "justify", style = "padding-bottom: 10px") 
             
             ),#pi sidebarpanel closure 1
           
           mainPanel(
             div(  
               style = "position:relative", 
               
               plotOutput("piplot", hover = hoverOpts("plot_hover_pi", delay = 100, delayType = "debounce")), 
               
               uiOutput("hover_info_pi"), 
               
               downloadButton('downloadpi', 'Download Image'), br(), br(), br()
              )
            )#pi mainpanel closure 1
           ) #,#pi sidebarlayout closure 1

       #   div(style = "padding-top: 50px; padding-bottom: 30px",
       # 
       #       #See code comments from ED DATA BY SEASON section
       #       sidebarLayout(
       # 
       #         sidebarPanel(
       # 
       #          p("Select a season to view raw (unsmoothed) P/I mortality data in the table.", align = "justify", style = "padding-bottom: 10px"),
       # 
       #           selectInput("piyear","Season:", choices = list("2013-14","2014-15","2015-16","2016-17","2017-18", "2018-19"), selected = "2018-19")
       # 
       #         ),#pi sidebarpanel closure 2
       # 
       #         mainPanel(
       #           DT::dataTableOutput('pitable', width = '75%')
       #         )#pi mainpanel closure 2
       #       )#pi sidebarlayout closure 2
       # ) #pi div closure
    )#pi tab closure

  )#Navbarpage closure

#Adding GA event tracker to count tab hits and downloads -- NOT TRACKING, NEED MORE WORK HERE
# tags$script(HTML(
#   "
#   $(document).on('shiny:filedown', function(event) {
#   gtag('event', 'download', {'event.name': event.name,'href': href});
#   });
#   
#   $(document).on('click', '#ED_Data', function() {
#   gtag('event', 'tabclick', {'event.name': 'ED_Data'});
#   });
#   
#   $(document).on('click', '#ED_Map', function() {
#   gtag('event', 'tabclick', {'event.name': 'ED_Map'});
#   });
#   
#   $(document).on('click', '#Lab', function() {
#   gtag('event', 'tabclick', {'event.name': 'Lab'});
#   });
#   
#   $(document).on('click', '#ICU', function() {
#   gtag('event', 'tabclick', {'event.name': 'ICU'});
#   });
#   
#   "
# ))

)#UI fluidpage closure
