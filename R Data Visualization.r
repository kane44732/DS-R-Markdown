# Data Visualization

library(tidyverse)

# Review Data
mpg
glimpse(mpg)

# ggplot =grammar of graphic
ggplot(data= mpg, mapping = aes(x = cty)) + 
  geom_histogram() # Histrogram

ggplot(data=mpg, mapping = aes(x=cty)) +
  geom_density() # Line density

ggplot(data=mpg, mapping = aes(x=cty))+
  geom_boxplot() # Box plot

# more detail ggplot2
ggplot(mpg, aes(cty,hwy))+
  geom_point()

ggplot(mpg, aes(cty,hwy))+
  geom_jitter() # Similar Scatter pont but add random noise

ggplot(mpg, aes(cty,hwy))+
  geom_point()+
  geom_rug() # Add density line in axis

# add confident interval and model line
ggplot(mpg, aes(cty,hwy))+
  geom_point()+
  geom_rug()+
  geom_smooth(method = "lm") # se = std error

# remove confident interval
ggplot(mpg, aes(cty,hwy))+
  geom_point()+
  geom_rug()+
  geom_smooth(method = "lm", se = FALSE) # se = std error

#----------------------------------#
# Visualization 1 Variable - Discrete (factor)
### Raw data plt bar => Will use geom_bar
ggplot(mpg, aes(manufacturer))+
  geom_bar()

ggplot(mpg, aes(trans))+
  geom_bar()

## Aggregate result before plot
### Ex count aggreagate with order result
mpg %>%
  count(manufacturer,sort=TRUE)
### Plot with process = > Will use geom_col
mpg %>%
  count(manufacturer)%>%
  ggplot(., aes(x = reorder(manufacturer,-n),y =n))+
  geom_col()

ggplot(mpg %>%
           count(manufacturer), aes(x = reorder(manufacturer,-n),y =n))+
  geom_col()
#----------------------------------#
# Mapping vs setting
## Mapping is everything in aes()
## Setting is everything out of aes()
ggplot(mpg ,aes(cty,hwy)) +
  geom_jitter(color = 'salmon',
              size = 5,
              alpha = 0.2) +
  theme_minimal()
# Aesthetic mapping
# Columns mapped to aesthetic features
diamonds %>%
  sample_frac(0.1)%>%
  # x=carat, y =price , color = clarity, shape = cut
  # Note : aesthetic mapping maximum must not over 2
  ggplot(., mapping = aes(carat, price,
                          col = clarity,
                          shape = cut))+
  geom_point(size = 0.3, alpha = 0.1)+
  theme_minimal()+
  labs(title = "TITLE",
      x = "Carat Num",
      y = "Price USD",
      caption = "This is caption.")

#----------------------------------#
# Overplotting
# Can't see any pattern in our plot
## Solution adpat alpha and shape / use only sample
diamonds %>%
  sample_n(2000) %>%
  ggplot(., aes(carat,price))+
  geom_point(alpha = 0.5, shape = ".")
#----------------------------------#
# facet in R
# => plot seperate by type
# 1 var => facet_warp
diamonds %>%
  sample_frac(0.1) %>%
  ggplot(.,aes(carat,price, color = clarity))+
  geom_point(alpha = 0.2)+
  theme_minimal()+
  # facet column cut
  facet_wrap(~ cut,
             nrow =2,
             ncol=3)

# > 1 var => facet_grid
diamonds %>%
  sample_frac(0.1) %>%
  ggplot(., aes(carat,price)) +
  geom_point(alpha = 0.2)+
  # add model line with red color
  geom_smooth(col = "red")+
  theme_minimal()+
  # facet column cut and clarity
  facet_grid(cut ~ clarity)

#----------------------------------#
# Scale color manual
# scale color pattern
ggplot(mtcars, aes(wt, mpg,
                   color = factor(am)))+
  geom_point(size =5)

# use name vector for help
myBrandCar <- c(
  "Auto" = "Gold",
  "Manual" = "Blue"
)

mtcars %>%
  #change am from (0,1) to (Auto, Manual)
  mutate(am = factor(am,
                     levels = c(0,1),
                     labels = c("Auto","Manual"))) %>%
  #map plot x= wt, y =mpg, color = am
  ggplot(., aes(wt, mpg, color = am))+
  #plot scatter set size = 5
  geom_point(size = 5)+
  #set scale color
  scale_color_manual(values = myBrandCar)+
  #set theme
  theme_minimal()
#----------------------------------#
# Scale color brewer => order color pattern
# ex pattern => "YlGnBu"
diamonds %>%
  sample_n(1000) %>%
  ggplot(., aes(carat,price, col =cut))+
  geom_point(size = 5, alpha =0.4) +
  theme_minimal()+
  scale_color_brewer(palette = "YlGnBu",
                     direction = -1)

#----------------------------------#
# Shortcut ggplot => qplot
qplot(x = price, data = diamonds,
      geom = "histogram",
      bins =50)
## Similar result but different way to write
qplot(x = cut, y = price, data = diamonds,
      geom = "boxplot")
ggplot(diamonds, aes(x=cut, y=price))+
  geom_boxplot()

#----------------------------------#
# Save ggplot as object
base <- ggplot(diamonds, aes(price))
base + geom_histogram(bins = 50)
base + geom_density()
base + geom_freqpoly()

#----------------------------------#
# Flip Chart => coord_flip()
base +
  geom_boxplot(fill = "gold")+
  coord_flip()

#----------------------------------#
# Put multiple charts in one canvas
# library(gridExtra)
p1 <- qplot(mpg, data=mtcars, geom ="histogram")
p2 <- qplot(wt,mpg, data=mtcars, geom="point")
p3 <- qplot(mpg, data=mtcars, geom="density")

library(gridExtra)
grid.arrange(p1,p2,p3, nrow=1)

#----------------------------------#
# Create interactice chart => library(plotly)
library(plotly)

myplot <- ggplot(mpg, aes(cty,hwy))+
  geom_jitter()
ggplotly(myplot)

#----------------------------------#
# Set range axis => xlim, ylim
## Ex plot scatter with x=wt, y= mpg in data mtcars
##    Axis x = 3:4, Axis y = 15:20
ggplot(mtcars, aes(wt,mpg))+
  geom_point()+
  xlim(3,4)+
  ylim(15,20)

