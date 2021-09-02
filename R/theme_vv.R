theme_vv <- function(){
  font <- "Arial Narrow"   #assign font family up front
  
  theme_minimal() %+replace%    #replace elements we want to change
    
    theme(
      
      #grid elements
      panel.grid.major = element_blank(),    #strip major gridlines
      panel.grid.minor = element_blank(),    #strip minor gridlines
      axis.ticks = element_blank(),          #strip axis ticks
      
      #since theme_minimal() already strips axis lines, 
      #we don't need to do that again
      
      #text elements
      plot.title = element_text(             #title
        family = font,            #set font family
        size = 20,                #set font size
        face = 'bold',            #bold typeface
        hjust = 0,                #left align
        vjust = 2),               #raise slightly
      
      plot.subtitle = element_text(          #subtitle
        family = font,            #font family
        size = 14,
        hjust = 0),               #font size
      
      plot.caption = element_text(           #caption
        family = font,            #font family
        size = 9,                 #font size
        hjust = 1),               #right align
      
      axis.title = element_text(             #axis titles
        family = font,            #font family
        size = 12,
        face = 'bold'),               #font size
      
      axis.text = element_text(              #axis text
        family = font,            #axis famuly
        size = 9),                #font size
      
      axis.text.x = element_text(            #margin for axis text
        margin=margin(5, b = 10))
      
      #since the legend often requires manual tweaking 
      #based on plot content, don't define it here
    )
}
