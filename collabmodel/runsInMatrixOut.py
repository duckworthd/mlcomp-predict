maxRow = 0
maxColumn = 0

#pass 1
inFile = open('MulticlassClassification.txt', 'r')
inLine = inFile.readline()
while inLine != '':
    eles = inLine.split(' ')
    if int(eles[0]) > maxRow: maxRow = int(eles[0])
    if int(eles[1]) > maxColumn: maxColumn = int(eles[1])
    inLine = inFile.readline()
inFile.close()

#Create matrix structure
mat = [[None for y in range(maxColumn)] for x in range(maxRow)]

#pass 2
inFile = open('MulticlassClassification.txt', 'r')
inLine = inFile.readline()
while inLine != '':
    rawData = inLine[:len(inLine)-1]
    eles = rawData.split(' ')
    mat[int(eles[0])-1][int(eles[1])-1] = round(float(eles[2]), 3)
    inLine = inFile.readline()
inFile.close()

#output
outFile = open('matrixForm.txt', 'w')
outFile.write('\t'.join(["row"] + [str(x) for x in range(1, maxColumn+1)]) + '\n')
for row in range(maxRow):
    outFile.write('\t'.join([str(row+1)] + [str(mat[row][column]) for column in range(maxColumn)]) + '\n')
outFile.close()
