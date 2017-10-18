filtered = read.csv("outfile_filtered.csv", header = F)
dictionary = read.csv("outfile.csv", header = F, sep = "\t")
colnames(filtered) = "ids"
colnames(dictionary) = c("entry", "ids")
z = merge(filtered, dictionary, by.x = "ids", by.y = "ids")
