#!/usr/bin/python

import networkx as nx
import re

file_name1 = "outfile_filtered.csv"
file_name2 = "outfile_blast.out"
file_name3 = "outfile.csv"

seq_ids = []

upper_similarity = 100
lower_similarity = 95.0

dictionario = {}

f1 = open(file_name1, "r")

for line in f1:
	seq_ids.append(line.strip())

f1.close()

similarity_network = nx.Graph()
similarity_network.add_nodes_from(seq_ids)


f2 = open(file_name2, "r")

for line in f2:
	data = re.split('\t', line)
	node1 = data[0]
	node2 = data[1]
	similarity = float(data[2])
	if lower_similarity <= similarity and similarity <= upper_similarity and node1 != node2:
			similarity_network.add_edge(node1, node2)

f2.close()

nx.number_connected_components(similarity_network)

f3 = open(file_name3, "r")

for line in f3:
	line = line.strip()
	data = re.split('\t', line)
	l1 = data[0]
	l2 = data[1]
	dictionario[l2] = l1

f3.close()


sub = 1
for component in list(nx.connected_components(similarity_network)):
	for c in component:
		print sub, dictionario[c]
	sub = sub + 1
