#Ville Tanskanen
#2021
#Data wrangling week 6
set.seed(123)

#1)
bprs = read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ")
rats = read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t")
dim(bprs) # => 40 x 11
dim(rats) # => 16 x 13

head(bprs)
#bprs had non-unique subject identifier, s lets create one
bprs$subject = 1:nrow(bprs)
#   treatment subject week0 week1 week2 week3 week4 week5 week6 week7 week8
# 1         1       1    42    36    36    43    41    40    38    47    51
# 2         1       2    58    68    61    55    43    34    28    28    28
# 3         1       3    54    55    41    38    43    28    29    25    24
# 4         1       4    55    77    49    54    56    50    47    42    46
# 5         1       5    72    75    72    65    50    39    32    38    32
# 6         1       6    48    43    41    38    36    29    33    27    25

head(rats)
#   ID Group WD1 WD8 WD15 WD22 WD29 WD36 WD43 WD44 WD50 WD57 WD64
# 1  1     1 240 250  255  260  262  258  266  266  265  272  278
# 2  2     1 225 230  230  232  240  240  243  244  238  247  245
# 3  3     1 245 250  250  255  262  265  267  267  264  268  269
# 4  4     1 260 255  255  265  265  268  270  272  274  273  275
# 5  5     1 255 260  255  270  270  273  274  273  276  278  280
# 6  6     1 260 265  270  275  275  277  278  278  284  279  281

# Wide format meaning that the longitudinal measurements are represented as columns (one of the columns determine the subject)
# ID in rates and subject in bprs

#2)
rats$ID = as.factor(rats$ID)
rats$Group = as.factor(rats$Group)

bprs$treatment = as.factor(bprs$treatment)
bprs$subject = as.factor(bprs$subject)

#3)
library(dplyr)
bprs = gather(bprs, key = weeks, value = bprs, -treatment, -subject)
rats = gather(rats, key = WD, value = measurement, -ID, -Group)
bprs$weeks = as.integer(gsub("week", "", bprs$weeks))
rats$WD = as.integer(gsub("WD", "", rats$WD))

#4)
#lets take a random sample from the long data
bprs[sample(nrow(bprs), 10),]
#     treatment subject weeks bprs
# 244         1       4     6   47
# 48          1       8     1   36
# 188         2       8     4   55
# 139         1      19     3   28
# 299         1      19     7   23
# 158         2      18     3   33
# 189         2       9     4   31
# 311         2      11     7   60
# 354         2      14     8   27
# 57          1      17     1   38

# Means first row means that subject 4 had treatment 1 and the measurement of bprs at week 6 was 47.

rats[sample(nrow(rats), 10),]
#     ID Group WD measurement
# 90  10     2 36         460
# 91  11     2 36         455
# 175 15     3 64         548
# 92  12     2 36         597
# 137  9     2 50         456
# 99   3     1 43         267
# 72   8     1 29         270
# 26  10     2  8         420
# 7    7     1  1         275
# 172 12     2 64         628

# Means last row means that rat with ID 12 who was in the treatment group 2 was measured at time point WD = 64 with measurement 628

#Notice that in the wide format the measurement row was spread along columns prefixed with "WD" in the rats case

#save the datasets
write.csv(bprs, "data/bprs.csv", row.names = FALSE)
write.csv(rats, "data/rats.csv", row.names = FALSE)

kek = read.csv("data/bprs.csv")
asd = read.csv("data/rats.csv")
#check that saving goes as expected
all(kek == bprs) # TRUE
all(asd == rats) # TRUE
