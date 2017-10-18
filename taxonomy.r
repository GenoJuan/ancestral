library(myTAI)
library(stringr)

taxonomy_levels = c("superkingdom", "kingdom", "phylum", "class", "order", "family", "genus", "species")

ids = read.csv("/Users/ewiggin/Dropbox/ids_filtered.csv", header = F)
organisms = rep(NA, nrow(ids))
for(o in 1:nrow(ids)){
    name = regmatches(as.character(ids[o,]),regexpr("\\[(.+)\\]", as.character(ids[o,]), perl = T))
    name = gsub("\\[", "", name)
    name = gsub("\\]", "", name)
    if(length(name) != 0){
        organisms[o] = name
    }
}

organisms = organisms[!is.na(organisms)]
organisms = unique(organisms)

taxonomy_matrix = matrix(nrow = length(organisms), ncol = length(taxonomy_levels), data = NA)
colnames(taxonomy_matrix) = taxonomy_levels
rownames(taxonomy_matrix) = organisms


for(o in 1:length(organisms)){
    x = taxonomy( organism = organisms[o], db = "ncbi", output   = "classification" )
    for(t in 1:length(taxonomy_levels)){
        if(length(subset(x$name, x$rank == taxonomy_levels[t])) == 1){
            taxonomy_matrix[organisms[o],taxonomy_levels[t]] = subset(x$name, x$rank == taxonomy_levels[t])
        }
    }
    print(o)
}

