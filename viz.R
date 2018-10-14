# 
library(tidyverse)
library(reshape2)
library(ggplot2)
library(ggthemes)

#
# Data manually parsed from Aged Care Workforce Report 2016
#

# roles
occ <- c("Nurse Practitioner (NP)",
"Registered Nurse (RN)",
"Enrolled Nurse (EN)",
"Personal Care Attendant (PCA)",
"Allied Health Professional (AHP)",
"Allied Health Assistant (AHA)")

abbv <- c("NP", "RN", "EN", "PCA", "AHP", "AHA")

occ_2016 <- c(386,
              22455,
              15697,
              108126,
              2210,
              4979)

emp <- data.frame(occupation = occ, count = occ_2016, occ_code = abbv)

ggplot(data = emp, aes(occ_code, count)) +
    geom_bar(stat="identity", fill="tomato2") + ggtitle("") +
    theme_gdocs() + 
    theme(axis.text.x = element_text(size = 12, angle = 45, hjust = 1, vjust = 1),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.minor.x = element_line(size = 0.5, colour = "grey"),
          panel.grid.major.x = element_line(size = 0.8, colour = "grey")) + 
    xlab("Occupation") + 
    coord_flip() +
    ggtitle("Employees in the Residential Aged Care Workforce (2016)")



## culture
cult <- c("No Cultural Spec.",
          "Polish" ,
          "Aboriginal/Torres Strait Islander",
          "Italian",
          "Chinese",
          "Dutch",
          "Greek",
          "LGBTI",
          "German",
          "Indian",
          "Other")

cult_percentage <- c(57.5,
                    13.1,
                    28.9,
                    17.4,
                    15.2,
                    11.7,
                    15.3,
                    17.4,
                    13.0,
                    12.7,
                    5.2)


cult_df <- data.frame(cultures = cult, cult_count = cult_percentage)

# static plots
# export to csv to make interactive
ggplot(data = cult_df, aes(cultures, cult_count)) +
    geom_bar(stat="identity", fill="#ffcc00") + ggtitle("") +
    theme_gdocs() + 
    theme(axis.text.x = element_text(size = 12, angle = 45, hjust = 1, vjust = 1),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.minor.x = element_line(size = 0.5, colour = "grey"),
          panel.grid.major.x = element_line(size = 0.8, colour = "grey")) + 
    xlab("Culture") + 
    ylab("% of facilities") +
    coord_flip() +
    ggtitle("Specialised Services for specific \nethnic/cultural groups (2016)")


### in demand skills

train_area <- c("Dementia",
                "Palliative Care",
                "Mgmt and\n Leadership",
                "Wound Mgmt",
                "Mental Health",
                "Allied Health",
                "Other")

rn_count <- c(51.3, 45.9, 50.2, 38.9, 21.0, 4.3, 6.1)
en_count <- c(54.9, 58.2, 27.8, 57.0, 31.2, 4.9, 4.3)
pca_count <- c(63.3, 52.0, 17.5, 29.3, 32.9, 9.0, 5.0)
ah_count <- c(68.1, 32.1, 27.4, 4.7, 28.2, 24.8, 7.0)


skill_df <- data.frame(area = train_area, RN = rn_count, EN = en_count, PCA = pca_count, AH = ah_count)


skill_plot<- melt(skill_df)

ggplot(data = skill_plot, aes(x = variable, y = value)) +
    geom_bar(stat="identity", fill="purple") +
    facet_grid(~area, scales = "free") +
    theme_bw() + 
    theme(axis.text.x = element_text(size = 12, angle = 45, hjust = 1, vjust = 1),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank()) + 
    xlab("Occupation") + 
    ylab("%") +
    ggtitle("Areas of Training in Demand Within Next 12 Months by Role")






