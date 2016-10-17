#######################################################
# TMY3 converter
#
# Alberto de la Calle                        2016-10-14
#######################################################
from __future__ import division
import argparse
import csv
import os

def convertData(fn,delay):

#    fn='example_TMY3.csv'
#    delay=0
    with open(fn, 'rb') as csvfile:
        rea = csv.reader(csvfile, delimiter=',')
        next(rea, None) # Skip header
        next(rea, None) # Skip header
        next(rea, None) # Skip header
        i = 0
        lines= list()
        for row in rea:
            try:
                lines.append("%.0f, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s\n" % (delay+i*3600, row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11],row[12],row[13]))
                previousRow = row
            except ValueError:
                pass
            i = i + 1
    name, ext = os.path.splitext(fn)        
    filOut = open('%s.motab'%name, 'w')
    filOut.write("#1\n")
    filOut.write("double data(%s,11)\n"% len(lines))
    filOut.writelines(lines)
    filOut.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('file', help='TMY3 file path')
    parser.add_argument('-d', type=int, dest='delay', default=0, help='Start time value in seconds (default: 0)')
    args = parser.parse_args()
    fn = args.file
    delay = args.delay
    convertData(fn,delay)
