
import csv

# total numer of section assing isotrpic by default 
N = 12 
centID = 2
comboNo = 1


# read and sparse data
f = open("comboIds.csv", 'r')
csvreader = csv.reader(f)
comboIds = list(csvreader)
combo = comboIds[(comboNo - 1)]
#print(comboIds[(comboNo - 1)])



text_file = open("materAssign.txt","w")

text_file.write("p = mdb.models['JobTmp'].parts['PART-1'] \n")

#ISO
text_file.write("mdb.models['JobTmp'].HomogeneousSolidSection(material='Material-151', name=\n    'Section-ISO', thickness=None)\n" )
text_file.write("region = p.sets['ISO'] \n" )
text_file.write("p.SectionAssignment(region=region, sectionName='Section-ISO') \n" )


#center 1 
text_file.write("mdb.models['JobTmp'].HomogeneousSolidSection(material='Material-%s', name=\n    'Section-CENT', thickness=None)\n" %(centID))
text_file.write("region = p.sets['CENT'] \n")
text_file.write("p.SectionAssignment(region=region, sectionName='Section-CENT') \n" )

#center, layer 2
text_file.write("mdb.models['JobTmp'].HomogeneousSolidSection(material='Material-%s', name=\n    'Section-CENT2', thickness=None)\n" %(combo[0]))
text_file.write("region = p.sets['CENT2'] \n" )
text_file.write("p.SectionAssignment(region=region, sectionName='Section-CENT2') \n" )


for x in range (1, N+1):
        text_file.write("mdb.models['JobTmp'].HomogeneousSolidSection(material='Material-%s', name=\n    'Section-%s', thickness=None)\n" % (combo[x], x))
        text_file.write("region = p.sets['POLY%s'] \n" %(x))
        text_file.write("p.SectionAssignment(region=region, sectionName='Section-%s') \n" % (x))
        print(combo[x])
	
		
text_file.close()
