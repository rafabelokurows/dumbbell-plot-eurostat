install.packages("eurostat")
library(eurostat)
library(tidyverse)

# specify the code for the indicator you want to download
indicator_code <- "sdg_05_20"

# specify the code for the countries you want to download
country_codes <- c("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "EL", "ES", "FI", "FR", "HR", "HU", "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK")

# download the data from Eurostat
data <- get_eurostat(id = indicator_code, 
                     type = "label",
                     time_format = "num", filters = list(geo = country_codes))

# view the data
head(data)
df=data %>% group_by(geo) %>% summarize(`2006`=first(values,na_rm = T),
                                     #yearantes=first(time),
                                    `2021`=last(values,na_rm = T),
                                     #yeardepois=last(time)
                                     ) %>% 
  mutate(geo=ifelse(str_detect(geo,"Germany"),"Germany",geo))%>% arrange(`2021`)

dflong = df %>% 
  mutate(`2006`=`2006`/100,`2021`=`2021`/100) %>% 
  pivot_longer(cols = c(`2006`,`2021`))


df=df %>% mutate(colorDumb=ifelse(`2006`>`2021`,"#CDFFCC","#FFCCCB"))

ggplot( df) + 
  geom_point(data = dflong, aes(x = value, color = name,y=reorder(geo,value,last)), size = 3) +
  geom_dumbbell(aes(x = (`2021`/100), xend = (`2006`/100),
                    y=geo), size=3, color=df$colorDumb,#"#e3e2e1", 
                colour_x = "#0e668b", colour_xend = "#a3c4dc",
                dot_guide=TRUE, dot_guide_size=0.15) +
  theme_bw() +
  scale_color_manual(name = "year", values = c("#a3c4dc","#0e668b","#CDFFCC","#FFCCCB") )+
  #scale_color_manual(name = "color", values = c("#CDFFCC","#FFCCCB") )+
  scale_x_continuous(label=percent)+ labs(title="Gender pay gap",
                                          subtitle="According to Eurostat")+
  theme_bw()+
  theme(plot.background=element_rect(fill="#f7f7f7"))+
  theme(panel.background=element_rect(fill="#f7f7f7"))+
  theme(panel.grid.minor=element_blank())+
  theme(panel.grid.major.y=element_blank())+
  theme(panel.grid.major.x=element_line())+
  theme(axis.ticks=element_blank())+
  theme(legend.position="right",legend.background = element_rect(fill="#f7f7f7"),
  legend.key = element_rect(fill="#f7f7f7"))+
  theme(panel.border=element_blank())+geom_vline(aes(xintercept=0),linetype="dashed")
