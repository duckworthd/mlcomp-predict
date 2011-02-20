import pickle

domains = set()
progs = {}
datasets = {}

#Pass 1
inputFile = open('runs.txt', 'r')
inLine = inputFile.readline()
inLine = inputFile.readline() #ignore first line
while(inLine != ''):
    rawData = inLine.strip('\n')
    eles = inLine.split('\t')
    if(eles[0] in domains):
        progs[eles[0]] = progs[eles[0]].union([eles[2]+', '+eles[6]])
        datasets[eles[0]] = datasets[eles[0]].union([eles[4]])
    else:
        progs[eles[0]] = set([eles[2]+', '+eles[6]])
        datasets[eles[0]] = set([eles[4]])
    domains = domains.union([eles[0]])
    inLine = inputFile.readline()
inputFile.close()

#Create output matrix structure
#Create lookups for datasets and programs
output = {}
lookup = {}
for d in domains:
    output[d] = {}
    lookup[d] = [{}, {}]
    pIndex = 1
    dIndex = 1
    for p in progs[d]:
        output[d][p] = {}
        lookup[d][0][p] = pIndex
        pIndex += 1
        for ds in datasets[d]:
            output[d][p][ds] = None
    for ds in datasets[d]:
        lookup[d][1][ds] = dIndex
        dIndex += 1

#Store lookup:
pickle.dump(lookup, open("runsLookup.p", "wb"))

#Pass 2
inputFile = open('runs.txt', 'r')
inLine = inputFile.readline()
inLine = inputFile.readline() #ignore first line
while(inLine != ''):
    rawData = inLine[:len(inLine)-1]
    eles = rawData.split('\t')
    if not eles[7].isalpha():
        output[eles[0]][eles[2]+', '+eles[6]][eles[4]] = eles[7]
    inLine = inputFile.readline()
inputFile.close()

#write output files
for d in domains:
    outputFile = open(d+'.txt', 'w')
    for p in progs[d]:
        for ds in datasets[d]:
            if output[d][p][ds] != None and not output[d][p][ds] == '':
                outputFile.write(str(lookup[d][1][ds])+' '+str(lookup[d][0][p])+' '+output[d][p][ds]+'\n')
    outputFile.close()
        
