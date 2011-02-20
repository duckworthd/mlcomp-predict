import pickle,sys,traceback

lookup = pickle.load(open('runsLookup.p', 'r'))
domains = lookup.keys()
invertedLookup = lookup
for d,i in invertedLookup.items():
    invertedLookup[d][0] = dict([[v,k] for k,v in invertedLookup[d][0].items()])
    invertedLookup[d][1] = dict([[v,k] for k,v in invertedLookup[d][1].items()])

opt = int(raw_input("0. Print domains\n1. Lookup index by name\n2. Lookup name by index\n3. Quit\n> ").strip())
while opt != 3:
    try:
        if opt == 1:
            domain = raw_input("Domain: ").strip()
            pord = int(raw_input("1. Program\n2. Dataset\n> ").strip())
            if pord == 1:
                programName = raw_input("Program Name: ").strip()
                hyp = raw_input("Tune Hyper Params: ").strip()
                print "Index: " + str(lookup[domain][0][programName+', '+hyp])+"\n\n"
            else:
                datasetName = raw_input("Dataset Name: ").strip()
                print "Index: " + str(lookup[domain][1][datasetName]) + "\n\n"
        elif opt == 0:
            print str(domains) + "\n\n"
        elif opt == 2:
            domain = raw_input("Domain: ").strip()
            pord = int(raw_input("1. Program\n2. Dataset\n> ").strip())
            if pord == 1:
                index = int(raw_input("Index: ").strip())
                print "Program Name: " + str(invertedLookup[domain][0][index])
            else:
                index = int(raw_input("Index: ").strip())
                print "Dataset Name: " + str(invertedLookup[domain][1][index])
        else:
            opt = int(raw_input("0. Print domains\n1. Lookup index by name\n2. Lookup name by index\n3. Quit\n> ").strip())
    except Exception, err:
        traceback.print_exc(file=sys.stdout)
        opt = int(raw_input("0. Print domains\n1. Lookup index by name\n2. Lookup name by index\n3. Quit\n> ").strip())
    
    opt = int(raw_input("0. Print domains\n1. Lookup index by name\n2. Lookup name by index\n3. Quit\n> ").strip())

