import urllib2, sys, re
from BeautifulSoup import BeautifulSoup
from BeautifulSoup import NavigableString

#Start run ID
runID = 11626

#sparse matrix of data
matrix = {}

#errorRate matcher regexp
p = re.compile('(errorRate:)(\d+\.\d+)')

#Programs and datasets
programs = []
datasets = []

while runID <= 11673:
    eRate = 1.0
    #Extract html from run address
    address = "http://mlcomp.org/runs/" + str(runID)
    html = urllib2.urlopen(address).read()

    #Build parse tree
    soup = BeautifulSoup(html)
    
    #Extract program name and dataset name
    datasetlinks = soup.findAll(attrs={"type" : "Dataset"})
    programlinks = soup.findAll(attrs={"type" : "Program"})
    dataset1 = re.sub('\s+', '-', datasetlinks[0].text)
    dataset2 = re.sub(',', '', dataset1)
    if not programlinks[0].text in programs:
        programs += [programlinks[0].text]
    if not dataset2 in datasets:
        datasets += [dataset2]
    #Extract error rate
    liItems = soup.findAll('li')
    for itm in liItems:
        m = p.match(itm.text)
        if m != None:
            eRate = m.group(2)
            break

    try:
        matrix[dataset2][programlinks[0].text] = eRate
    except:
        matrix[dataset2] = {}
        matrix[dataset2][programlinks[0].text] = eRate

    print runID
    runID+=1

#Output in matrix form
fOut = open('syntheticMatrix.txt', 'w')
#Print the label for columns
out = "blah"
for prog in programs:
    out += "\t"+prog
fOut.write(out+"\n")

#Actually print out the matrix
for ds in datasets:
    out = ds
    for prog in programs:
        try:
            error = matrix[ds][prog]
            out += "\t"+str(error)
        except:
            out += "\tNone"
    fOut.write(out+"\n")
fOut.close()
