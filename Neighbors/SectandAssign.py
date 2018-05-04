#Abaqus script

N=151#number of grains 


text_file = open("Assignment.txt","w")


for x in range (1, N+1):
# Material creation 
    text_file.write("mdb.models['JobTmp'].Material(name='Material-%s') \n" % x)
    text_file.write("mdb.models['JobTmp'].materials['Material-%s'].UserMaterial(mechanicalConstants=\n    (1.0, %s))\n" % (x,x))
    text_file.write("mdb.models['JobTmp'].materials['Material-%s'].Depvar(n=40)\n" % x)

text_file.close()
