import os.path
import csv


#the orientation number of the Center grain on the surface
Cent = 2
direc  = 'Cent' + str(Cent)
current_directory = os.getcwd()
final_directory = os.path.join(current_directory, direc)
if not os.path.exists(final_directory):
    os.makedirs(final_directory)

print(final_directory)


# read combo index data
f = open("comboIds.csv", 'r')
csvreader = csv.reader(f)
comboIds = list(csvreader)
f.close()


N=40#number of combos for 1 cent grain

for comboNo in range (1, N+1):
    #identify combo indices
    combo = comboIds[(comboNo - 1)]
    with open('inptemplate1.txt') as part1, open('inptemplate2.txt') as part2:
        filename=final_directory + "\job"+str(Cent)+"-"+"%s" % (comboNo) + ".inp"
        text_filei = open(filename,"w")
        text_filei.write( "*Heading \n" )
        text_filei.write("** Job name: Job%s-%s Model name: Model-1 \n" % (Cent,comboNo))
	#write in the 1st half of the template
        for line in part1.readlines():
            text_filei.write(line)
                        
		#define material for Cent 1
        text_filei.write("\n ** Section: Section-1-CENT")	
        text_filei.write("\n *Solid Section, elset=CENT, material=MATERIAL-%s \n , " % (Cent))
        #define material for Cent 2
        text_filei.write("\n ** Section: Section-10-CENT2")	
        text_filei.write("\n *Solid Section, elset=CENT, material=MATERIAL-%s \n , " % (combo[0]))
                #define material for POLY 1 
        text_filei.write("\n ** Section: Section-2-POLY1")	
        text_filei.write("\n *Solid Section, elset=POLY1, material=MATERIAL-%s \n , " % (combo[1]))
        #define material for POLY 2 
        text_filei.write("\n ** Section: Section-4-POLY2")	
        text_filei.write("\n *Solid Section, elset=POLY2, material=MATERIAL-%s \n , " % (combo[2]))
        #define material for POLY 3 
        text_filei.write("\n ** Section: Section-5-POLY3")	
        text_filei.write("\n *Solid Section, elset=POLY3, material=MATERIAL-%s \n , " % (combo[3]))
                    #define material for POLY 4 
        text_filei.write("\n ** Section: Section-6-POLY4")	
        text_filei.write("\n *Solid Section, elset=POLY4, material=MATERIAL-%s \n , " % (combo[4]))
        #define material for POLY 5 
        text_filei.write("\n ** Section: Section-7-POLY5")	
        text_filei.write("\n *Solid Section, elset=POLY5, material=MATERIAL-%s \n , " % (combo[5]))
        #define material for POLY 6 
        text_filei.write("\n ** Section: Section-8-POLY6")	
        text_filei.write("\n *Solid Section, elset=POLY6, material=MATERIAL-%s \n , " % (combo[6]))
                        #define material for POLY 7 
        text_filei.write("\n ** Section: Section-9-POLY7")	
        text_filei.write("\n *Solid Section, elset=POLY7, material=MATERIAL-%s \n , " % (combo[7]))
        #define material for POLY 8 
        text_filei.write("\n ** Section: Section-11-POLY8")	
        text_filei.write("\n *Solid Section, elset=POLY8, material=MATERIAL-%s \n , " % (combo[8]))
        #define material for POLY 9 
        text_filei.write("\n ** Section: Section-12-POLY9")	
        text_filei.write("\n *Solid Section, elset=POLY9, material=MATERIAL-%s \n , " % (combo[9]))
        #define material for POLY 10 
        text_filei.write("\n ** Section: Section-13-POLY10")	
        text_filei.write("\n *Solid Section, elset=POLY10, material=MATERIAL-%s \n , " % (combo[10]))
        #define material for POLY 11 
        text_filei.write("\n ** Section: Section-14-POLY11")	
        text_filei.write("\n *Solid Section, elset=POLY11, material=MATERIAL-%s \n , " % (combo[11]))
        #define material for POLY 12 
        text_filei.write("\n ** Section: Section-15-POLY12")	
        text_filei.write("\n *Solid Section, elset=POLY12, material=MATERIAL-%s \n , " % (combo[12]))
		
        #write in the 2nd half of the template
        text_filei.write("\n")
        for line in part2.readlines():
            text_filei.write(line)
            
    text_filei.close()
    part1.close()
    part2.close()

