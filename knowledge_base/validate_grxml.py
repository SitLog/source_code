#!/usr/bin/env python
# -*- coding: utf-8
# ----------------------------------------------------------------------
# Validates a GRXML grammar file
# ----------------------------------------------------------------------
# Caleb Rasc/ caleb.rascon at gmail.com
# 2018/IIMAS/UNAM
# ----------------------------------------------------------------------
# validate_grxml.py is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
# -------------------------------------------------------------------------

import os
import optparse
import xml.etree.ElementTree as ET

# Command line options
usage="""%prog [options] grxml_file
    
    Validates a GRXML grammar file, recursively if need be.
    
    grxml_file: GRXML grammar file to validate.
"""
version="%prog 0.1"


p = optparse.OptionParser(usage=usage,version=version)
p.add_option("-v", "--verbose",
        action="store_true", dest="verbose",
        help="Verbose mode [Off]")
opts, args = p.parse_args()

verbose = opts.verbose
# Arguments 
if not len(args)==1:
    p.error('Wrong number of arguments.')

grxml_path = args[0]

filename, file_extension = os.path.splitext(grxml_path)

if file_extension != ".grxml":
    p.error('File is not a GRMXL file.')

grxml_basedir = os.path.dirname(grxml_path)


def check_grxml(this_grxml_path,this_tabs):
    global grxml_basedir
    global verbose
    
    error_found = False
    return_tabs = "   "
    
    filename, file_extension = os.path.splitext(this_grxml_path)
    
    if file_extension != ".grxml":
        print(this_tabs+return_tabs+">>>>>>>>> "+os.path.basename(this_grxml_path)+" is not a GRMXL file."+" <<<<<<<<<<")
        return
    
    print this_tabs+"--- Reading: "+this_grxml_path
    if os.path.isfile(this_grxml_path):
        tree = ET.parse(this_grxml_path)
        root = tree.getroot()

        rules=[]
        rulerefs_loc=[]
        rulerefs_ext=[]
        for child in root.iter():
            #print child.tag, child.attrib
            if child.tag == "{http://www.w3.org/2001/06/grammar}rule":
                rules.append(child.attrib['id'])
            if child.tag == "{http://www.w3.org/2001/06/grammar}ruleref":
                this_ruleref = child.attrib['uri']
                if "#" in this_ruleref:
                    rulerefs_loc.append(this_ruleref)
                elif "grxml" in this_ruleref:
                    rulerefs_ext.append(this_ruleref)
        
        if(len(rules) > 0 and verbose):
            print this_tabs+"  Rules found:"
            for r in rules:
                print this_tabs+"    "+r
        
        if(len(rulerefs_loc) > 0):
            if verbose:
                print "\n"+this_tabs+"  Checking local rules references:"
            for r in rulerefs_loc:
                if verbose:
                    print this_tabs+"   "+r
                found = False
                for child in root.findall(".//*[@id='"+r[1:]+"']"):
                    if verbose:
                        print this_tabs+return_tabs+" Found: "+child.tag,child.attrib
                    found = True
                if found == False:
                    print this_tabs+return_tabs+" >>>>>>>>> '"+r+"' not found in "+grxml_path+" <<<<<<<<<<"
                    error_found = True
        
        if(len(rulerefs_ext) > 0):
            if verbose:
                print "\n"+this_tabs+"  Checking external rules references:"
            for r in rulerefs_ext:
                if verbose:
                    print this_tabs+"   "+r
                error_found = check_grxml(grxml_basedir+"/"+r,this_tabs+return_tabs)
    else:
        print(this_tabs+return_tabs+" >>>>>>>>> "+os.path.basename(this_grxml_path)+" cannot be found."+" <<<<<<<<<<")
        error_found = True
    
    if error_found == False:
        print this_tabs+return_tabs+"No errors found in "+os.path.basename(this_grxml_path)
    
    return error_found

check_grxml(grxml_path,"")
print("DONE.")
