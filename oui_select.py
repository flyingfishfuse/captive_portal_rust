# returns a MAC address for wither a specific vendor, law enforcment impersonation
# or whatever. Yes the feds have vendor specific OUI registrations, look at the file.


import os
import re

#This is for selecting vendor
#vendorregex1    = re.compile('.*[0-9a-fA-F]{2}[.-][0-9a-fA-F]{2}[.-][0-9a-fA-F]{2}' , re.I)
vendorregex1    = re.compile('.*?[0-9a-fA-F]{2}[.-][0-9a-fA-F]{2}[.-][0-9a-fA-F]{2}' , re.I)
actualmacaddress= re.compile('([0-9A-F]{2}[.:]){5}([0-9A-F]{2})', re.I )
actualmacoctets = re.compile('.*?[0-9a-fA-F]{2}[.-][0-9a-fA-F]{2}[.-][0-9a-fA-F]{2}', re.I )
macfile         = 'ouilist.cleaned'
returnnumber    = 1
counter         = 1
countstop       = 100
ouilistarray    = []

# for making the Database
hexline_regex = re.compile('.*(\(hex\)).*' , re.I)
macfile = '/home/moop/code/portal/lists/oui.txt'
outfile = open('/home/moop/code/portal/ouilist.cleaned', 'w')
ouiarray1       = []
string     = ''

def makeouidb():
  with open(macfile , "r") as f:
    filelines = f.readlines()
    for eachline in filelines:
    #looks for "hex" in the ouiDB line make sure its not the vendor name
      oui = hexline_regex.search(eachline)
      if oui != None :
        string = oui.group(0)
        ouiarray1.append(string.replace('(hex)' , ''))
    for eachline in ouiarray1:
      outfile.write(eachline + '\n')
    outfile.close()
  f.close()


#cleaning up the stuff below
def readouidb():
    try:
        with open(macfile , "r") as f:
            filelines = f.readlines()
            for eachline in filelines:
                oui = regex1.search(eachline)
                if oui != None :
                    string = oui.group(0)
                    ouiarray1.append(string.replace('(hex)' , emptystring))
            for eachline in ouiarray1:
                if counter < countstop :
                    returnnumber = counter + 1
                    ouilistarray.append(eachline)
    except:
        print("Error reading DB")

#full select lets you select full mac otherwise you gotta regex a vendor match
def getmacaddress(fullselect):
    #make three random hex values and cat an OUI onto it
    if fullselect == False:
        for each in range(3):
            randintval          = random.randomint(0,256)
            # the [2:] strips two chars off the front for the below line
            hexval              = hex(randintval)[2:]
            currentmacarray.append(hexval)
        readouidb(vendor = None , rand = True)
        macaddress = vendormac.join(currentmacarray)
    elif fullselect == True:
        print('Input your desired last three octets , COLON separated, WITHA A TRAILING COLON, any case')
        newmac = input('MAC Address: >')
        if actualmacoctets.search(newmac) == None:
            print('invalid input : ' + newmac)
            print('mac should look like de:ad:be:')
        elif actualmacaddress.search(newmac) == True:
            macaddress = newmac