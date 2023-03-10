#install.packages("eurostat")
library(eurostat)
library(tidyverse)
#library(ggalt)

# specify the code for the countries you want to download
country_codes <- c("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", "ES", "FI", "FR", "HR", "HU", "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK")

# download data from Eurostat
data <- get_eurostat(id = "sdg_05_20", 
                     type = "label",
                     time_format = "num", filters = list(geo = country_codes))

df=data %>% group_by(geo) %>% 
  filter(!is.na(values)) %>% summarize(`2006`=first(values),
                                        `2021`=last(values)) %>% 
  mutate(geo=ifelse(str_detect(geo,"Germany"),"Germany",geo))%>% arrange(`2021`)

dflong = df %>% 
  mutate(`2006`=`2006`/100,`2021`=`2021`/100) %>% 
  pivot_longer(cols = c(`2006`,`2021`))

df$colorDumb =ifelse(df$`2006`>df$`2021`,"#CDFFCC","#FFCCCB")

plot = ggplot() +
  geom_segment(data = df, 
               aes(x    = (`2006`/100), 
                   xend = (`2021`/100), 
                   y    = reorder(geo, `2021`,desc), 
                   yend = reorder(geo, `2021`,desc)),
               size = 1.5, 
               colour = df$colorDumb,
               arrow = arrow(length = unit(0.45, "cm"))
               ) +
  geom_point(data = dflong,
             aes(x      = value, 
                 y      = geo, 
                 colour = name),
             size = 3) + coord_flip()+
  labs(title = 'Has the gender pay gap decreased in the EU in the last 15 years?',
       subtitle = "Industry, construction and services - selected countries",
       caption = 'Source: Eurostat, 2022 (series: SDG_05_20)',
       y = NULL, x = "Gender pay gap (%)") +
  scale_colour_manual(values = c('#5C83AB', '#1A1423')) +
  theme_bw() +
  scale_y_discrete(expand=c(0,2.5))+
  scale_x_continuous(label=percent,expand=c(0,0.024)) +
  theme(legend.position = c(0.85, 0.80),
        legend.title = element_blank(),
        legend.box.background = element_rect(colour = 'black'),
        panel.border = element_blank(),
        axis.ticks = element_line(colour = 'black'))+
  geom_vline(aes(xintercept=0),linetype="dashed")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  annotate("label", x = c(-0.032), y=27,size=3, label = c("The most leveled,\n Luxembourg -0.2%"))+
  annotate("label", x = c(0.283), y=18,size=3, label = c("The most points reduced,\n Greece - down 15 points"))+
  # geom_text(aes(label = scales::percent(df$`2021`/100,accuracy=0.1),x = (df$`2021`/100),y=reorder(df$geo, df$`2021`,desc)),
  #           size = 2.5,nudge_x = df$nudge)+
  annotate(
    geom = "curve", x = c(-0.019), y = 27, xend = c(-0.01), yend = 27, 
    curvature = 0, 
    arrow = arrow(length = unit(2, "mm"))
  ) +
  annotate(
    geom = "curve", x = 0.2705, y = 18, xend = c(0.26), yend = 18, 
    curvature = 0, 
    arrow = arrow(length = unit(2, "mm"))
  ) 

ggsave(plot,file="plot.png", type = "cairo")
