#Ville Tanskanen 26.11.21
#create human data wrangling script
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

dim(hd) # => 195 x 8
dim(gii) # => 195 x 10 

str(hd)
# 'data.frame':	195 obs. of  8 variables:
#   $ HDI.Rank                              : int  1 2 3 4 5 6 6 8 9 9 ...
# $ Country                               : chr  "Norway" "Australia" "Switzerland" "Denmark" ...
# $ Human.Development.Index..HDI.         : num  0.944 0.935 0.93 0.923 0.922 0.916 0.916 0.915 0.913 0.913 ...
# $ Life.Expectancy.at.Birth              : num  81.6 82.4 83 80.2 81.6 80.9 80.9 79.1 82 81.8 ...
# $ Expected.Years.of.Education           : num  17.5 20.2 15.8 18.7 17.9 16.5 18.6 16.5 15.9 19.2 ...
# $ Mean.Years.of.Education               : num  12.6 13 12.8 12.7 11.9 13.1 12.2 12.9 13 12.5 ...
# $ Gross.National.Income..GNI..per.Capita: chr  "64,992" "42,261" "56,431" "44,025" ...
# $ GNI.per.Capita.Rank.Minus.HDI.Rank    : int  5 17 6 11 9 11 16 3 11 23 ...

str(gii)
# 'data.frame':	195 obs. of  10 variables:
#   $ GII.Rank                                    : int  1 2 3 4 5 6 6 8 9 9 ...
# $ Country                                     : chr  "Norway" "Australia" "Switzerland" "Denmark" ...
# $ Gender.Inequality.Index..GII.               : num  0.067 0.11 0.028 0.048 0.062 0.041 0.113 0.28 0.129 0.157 ...
# $ Maternal.Mortality.Ratio                    : int  4 6 6 5 6 7 9 28 11 8 ...
# $ Adolescent.Birth.Rate                       : num  7.8 12.1 1.9 5.1 6.2 3.8 8.2 31 14.5 25.3 ...
# $ Percent.Representation.in.Parliament        : num  39.6 30.5 28.5 38 36.9 36.9 19.9 19.4 28.2 31.4 ...
# $ Population.with.Secondary.Education..Female.: num  97.4 94.3 95 95.5 87.7 96.3 80.5 95.1 100 95 ...
# $ Population.with.Secondary.Education..Male.  : num  96.7 94.6 96.6 96.6 90.5 97 78.6 94.8 100 95.3 ...
# $ Labour.Force.Participation.Rate..Female.    : num  61.2 58.8 61.8 58.7 58.5 53.6 53.1 56.3 61.6 62 ...
# $ Labour.Force.Participation.Rate..Male.      : num  68.7 71.8 74.9 66.4 70.6 66.4 68.1 68.9 71 73.8 ...

#Dont really know what to do with the renaming exercise hopefully the short names can be decided by yours truly.
hd = hd %>% rename(HDIR = HDI.Rank,
                  HDI = Human.Development.Index..HDI.,
                  LE = Life.Expectancy.at.Birth,
                  Eyears = Expected.Years.of.Education,
                  Meducation = Mean.Years.of.Education,
                  GNI = Gross.National.Income..GNI..per.Capita,
                  GNIcapita = GNI.per.Capita.Rank.Minus.HDI.Rank)

gii = gii %>% rename(GIIR = GII.Rank,
                     GII = Gender.Inequality.Index..GII.,
                     MomMortality = Maternal.Mortality.Ratio,
                     ABR = Adolescent.Birth.Rate,
                     PerPar = Percent.Representation.in.Parliament,
                     PSEF = Population.with.Secondary.Education..Female.,
                     PSEM = Population.with.Secondary.Education..Male.,
                     LFPF = Labour.Force.Participation.Rate..Female.,
                     LFPM = Labour.Force.Participation.Rate..Male.)

# make the new variables
gii$PSEfrac = gii$PSEF / gii$PSEM
gii$LFPfrac = gii$LFPF / gii$LFPM

human = dplyr::inner_join(gii, hd, by="Country")
dim(human) # 195 x 19
write.csv(human, "human.csv", row.names = FALSE)

#test load
all.equal(human, read.csv("human.csv")) #TRUE

#lets load the data so that we have the naming convention simlarly to everyone elses. Description of the data can be found above
data = read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt",  sep = ",")
dim(data) # => 195 x 19 
head(data)
# HDI.Rank     Country   HDI Life.Exp Edu.Exp Edu.Mean    GNI GNI.Minus.Rank GII.Rank   GII Mat.Mor Ado.Birth Parli.F Edu2.F Edu2.M Labo.F Labo.M   Edu2.FM   Labo.FM
#        1      Norway 0.944     81.6    17.5     12.6 64,992              5        1 0.067       4       7.8    39.6   97.4   96.7   61.2   68.7 1.0072389 0.8908297
#        2   Australia 0.935     82.4    20.2     13.0 42,261             17        2 0.110       6      12.1    30.5   94.3   94.6   58.8   71.8 0.9968288 0.8189415
#        3 Switzerland 0.930     83.0    15.8     12.8 56,431              6        3 0.028       6       1.9    28.5   95.0   96.6   61.8   74.9 0.9834369 0.8251001
#        4     Denmark 0.923     80.2    18.7     12.7 44,025             11        4 0.048       5       5.1    38.0   95.5   96.6   58.7   66.4 0.9886128 0.8840361
#        5 Netherlands 0.922     81.6    17.9     11.9 45,435              9        5 0.062       6       6.2    36.9   87.7   90.5   58.5   70.6 0.9690608 0.8286119
#        6     Germany 0.916     80.9    16.5     13.1 43,919             11        6 0.041       7       3.8    36.9   96.3   97.0   53.6   66.4 0.9927835 0.8072289

# 1)
data$GNI = as.numeric(gsub(",", "", data$GNI))

# 2)
keep_cols = c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
data = data[ ,keep_cols]

# 3)
data = data[complete.cases(data),]

#4)
data$Country
data = data[1:(nrow(data)-7),]
#remove the last 7
#5)
rownames(data) = data$Country
data$Country = NULL
head(data)
# =>
#             Edu2.FM   Labo.FM Edu.Exp Life.Exp   GNI Mat.Mor Ado.Birth Parli.F
# Norway      1.0072389 0.8908297    17.5     81.6 64992       4       7.8    39.6
# Australia   0.9968288 0.8189415    20.2     82.4 42261       6      12.1    30.5
# Switzerland 0.9834369 0.8251001    15.8     83.0 56431       6       1.9    28.5
# Denmark     0.9886128 0.8840361    18.7     80.2 44025       5       5.1    38.0
# Netherlands 0.9690608 0.8286119    17.9     81.6 45435       6       6.2    36.9
# Germany     0.9927835 0.8072289    16.5     80.9 43919       7       3.8    36.9
write.csv(data, "data/human.csv", row.names = TRUE)
