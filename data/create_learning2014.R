#Ville Tanskanen
#date 11.11.21
#description TODO
data = read.csv("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t")
#describe the data
str(data)
#get the dimensions
dim(data)

#many of the outputs look like factor (discrete variables rather than int)

#generate the data
# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

a_data = data[c("gender", "Age", "Attitude", "Points")]
a_data["deep"] = rowMeans(data[deep_questions])
a_data["stra"] = rowMeans(data[strategic_questions])
a_data["surf"] = rowMeans(data[surface_questions])
#trim the rows
a_data = a_data[a_data$Points != 0,]
dim(a_data)

setwd("~/Koulu/IODS-project")
write.csv(a_data, "data/wk2data.csv", row.names = FALSE)
#test reading the data
a_data2 = read.csv("data/wk2data.csv", header = TRUE)
dim(a_data2) == dim(a_data)
