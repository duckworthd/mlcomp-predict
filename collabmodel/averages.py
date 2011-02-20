import pickle

sparseRowMatrix = {}
sparseColumnMatrix = {}
globalVals = []

#pass 1
maxRow = 0
maxColumn = 0
inFile = open('MulticlassClassification.txt', 'r')
inLine = inFile.readline()
while inLine != '':
    eles = inLine.split(' ')
    if int(eles[0]) > maxRow: maxRow = int(eles[0])
    if int(eles[1]) > maxColumn: maxColumn = int(eles[1])
    globalVals += [float(eles[2])]
    try:
        sparseRowMatrix[int(eles[0])] += [float(eles[2])]
    except:
        sparseRowMatrix[int(eles[0])] = [float(eles[2])]

    try:
        sparseColumnMatrix[int(eles[1])] += [float(eles[2])]
    except:
        sparseColumnMatrix[int(eles[1])] = [float(eles[2])]

    inLine = inFile.readline()
inFile.close()

#Calculate averages
columnAverages = dict([[i, sum(columns) / len(columns)] for i, columns in sparseColumnMatrix.items()])
rowAverages = dict([[i, sum(rows) / len(rows)] for i, rows in sparseRowMatrix.items()])
globalAverage = sum(globalVals) / len(globalVals)

lookup = pickle.load(open('runsLookup.p', 'r'))
invertedLookup = lookup
for d,i in invertedLookup.items():
    invertedLookup[d][0] = dict([[v,k] for k,v in invertedLookup[d][0].items()])
    invertedLookup[d][1] = dict([[v,k] for k,v in invertedLookup[d][1].items()])

progOut = open("programAverages.txt", "w")
for k,v in columnAverages.items():
    progOut.write(str(k) + " (" + str(invertedLookup['MulticlassClassification'][0][k])+"): " + str(v) + "\n")
progOut.close()

dsOut = open("datasetAverages.txt", "w")
for k,v in rowAverages.items():
    dsOut.write(str(k) + " (" + str(invertedLookup['MulticlassClassification'][1][k])+"): " + str(v) + "\n")
dsOut.close()

print "Global Average: " + str(globalAverage)
