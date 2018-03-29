#Load libraries
library("dplyr")
library("ggplot2")
library("png") #For importing image

#Load data
data <- read.csv("data.csv")

#BBC logo
img <- readPNG("~/Documents/Projects/ggplot.templates/bbc_logo_grey.png")
logo <- rasterGrob(img)

###STYLE TEMPLATE###
bbc_style <- theme(

  #Text format
  plot.title = element_text(family="Helvetica",
                            size=28,
                            face="bold",
                            color="#222222"),
  plot.subtitle = element_text(family="Helvetica",
                               size=22),
  plot.caption = element_text(family="Helvetica",
                              size=14,
                              color="#555555",
                              hjust = 0),

  #Legend format
  legend.position = "top",
  legend.text.align = 0,
  legend.background = element_blank(),
  legend.title = element_blank(),
  legend.key = element_blank(),
  legend.text = element_text(family="Helvetica",
                             size=18,
                             color="#555555"),

  #Axis format
  axis.title = element_blank(),
  axis.text = element_text(family="Helvetica",
                           size=18,
                           color="#555555"),
  axis.text.x = element_text(margin=margin(b=10)),
  axis.ticks = element_blank(),
  axis.line = element_blank(),

  #Grid lines
  panel.grid.minor = element_blank(),
  panel.grid.major.y = element_line(color="#eeeeee"),

  #Blank background
  panel.background = element_blank())

###ADDING LOGO AND HORIZONTAL LINE:
plot +
  geom_hline(yintercept = -2, size = 0.2, colour = "#555555") +
  annotation_custom(logo,
                    xmin=94, xmax=98,ymin=-3.3, ymax=-2.3)

gt <- ggplot_gtable(ggplot_build(plot))
gt$layout$clip[gt$layout$name=="panel"] <- "off"
grid.draw(gt)
