#!/usr/bin/env python
# -*- coding: utf-8
# --------------------------------------------------------
# Convert the Knowledge Base information into GRXML format
# --------------------------------------------------------
# Caleb Rascon
# 2015/IIMAS/UNAM
# --------------------------------------------------------
# Requires: python-regex to be installed

import re
import regex
import sys
import os
import glob
import shutil
import argparse

class Tree(object):
    def __init__(self):
        self.name = None
        self.children = {}
        self.instances = {}

class_list_dict = [] #main list
class_tree = Tree() #main tree
grammar_dict = {} #grammar dictionary
grammar_dict_spr = {} #grammar dictionary

parser = argparse.ArgumentParser(description='Convert the Knowledge Base information into GRXML format.')
parser.add_argument('--kb', metavar='kb_file',
                   default='golem_KB_original.txt',
                   help='Knowledge-base file.')
parser.add_argument('--parse', metavar='parse_file',
                   default='parser_KB.txt',
                   help='Parser file.')

args = parser.parse_args()
kb_file = args.kb
parse_file = args.parse

############ FUNCTIONS ############
def clean_string(raw_string):
	clean_str = raw_string.replace("\n","")
	clean_str = clean_str.replace("\t","")
	clean_str = clean_str.replace("\r","")
	#clean_str = clean_str.replace(" ","")
	return clean_str

def bracket_list_items(raw_string):
	argument_template = "\\[((?>[^\\[\\]]+|(?R))*)\\]"
	rest_arguments = regex.findall(argument_template, raw_string)
	return rest_arguments

def get_class_list (raw_string):
	class_template = "\(((?:[^\(\)]|(?R))*)\)"
	classes = regex.findall(class_template, raw_string)
	return classes

def get_class_arguments(raw_string):
	class_name_end_i = raw_string.find(",")
	class_name = raw_string[0:class_name_end_i].rstrip(" '").lstrip(" '")
	#print class_name
	
	class_father_end_i = raw_string.find(",",class_name_end_i+1)
	class_father = raw_string[class_name_end_i+1:class_father_end_i].rstrip(" '").lstrip(" '")
	#print class_father
	
	rest_arguments = bracket_list_items(raw_string[class_father_end_i+1:])
	#print rest_arguments
	
	return {'name': class_name, 'father': class_father, 'properties': rest_arguments[0], 'relations': rest_arguments[1], 'instances': rest_arguments[2]}

def get_instance_arguments(raw_string):
	instance_name_end_i = raw_string.find(",")
	instance_name_start_i = raw_string.find("=>")
	instance_name = raw_string[instance_name_start_i+2:instance_name_end_i].rstrip(" '").lstrip(" '")
	#print instance_name
	
	rest_arguments = bracket_list_items(raw_string[instance_name_end_i+1:])
	#print rest_arguments
	
	return {'name': instance_name, 'properties': rest_arguments[0], 'relations': rest_arguments[1]}

def print_branch(branch, level):
	for i in range(level-1):
		sys.stdout.write("\t"),
	print " |-> " + branch.name
	for c,k in branch.children.iteritems():
		print_branch(k,level+1)

def print_tree():
	global class_tree
	
	print class_tree.name
	for c,k in class_tree.children.iteritems():
		print_branch(k,1)

def build_branch(branch_name):
	children_list = find_class('father',branch_name)
	
	branch = Tree()
	branch.name = branch_name
	
	if(len(children_list) > 0):
		#it is a branch
		for b in children_list:
			child = build_branch(b['name'])
			branch_dict = find_class('name',b['name'])
			leafs_dict = bracket_list_items(branch_dict[0]['instances'])
			child.instances = leafs_dict
			branch.children.update({b['name']:child})
	else:
		#it is one before the leafs
		branch_dict = find_class('name',branch_name)
		leafs_dict = bracket_list_items(branch_dict[0]['instances'])
		for b in leafs_dict:
			child = Tree()
			child.name = b
			branch.children.update({b:child})
	return branch

def build_tree():
	global class_list_dict
	global class_tree
	
	main_branches_list = find_class('father','top')
	
	class_tree.name = 'top'
	for b in main_branches_list:
		branch = build_branch(b['name']);
		class_tree.children.update({b['name']:branch})

def find_class(key,value):
	global class_list_dict
	cl_list = []
	for c in class_list_dict:
		if c[key] == value:
			cl_list.append(c)
	return cl_list

def find_name_in_branch(branch,name):
	if(branch.name == name):
		return True
	if(len(branch.children) > 0):
		for c,k in branch.children.iteritems():
			if find_name_in_branch(k,name):
				return True
		return False
	else:
		return False

def find_branch(branch,name):
	if(branch.name == name):
		return branch
	
	if(len(branch.children) > 0):
		for c,k in branch.children.iteritems():
			ret_branch = find_branch(k,name)
			if ret_branch != None:
				return ret_branch
		return None
	else:
		return None

def write_entity_grxml_file(branch,is_leaf):
	grxml_file_location = './grammars/'+branch.name+'.grxml'
	grxml_file = open(grxml_file_location,'w')
	
	# Writing header
	grxml_file.write('<?xml version="1.0" encoding="utf-8"?>\n')
	branch_name_fix = branch.name.replace(" ","_")

	grxml_file.write('<grammar version="1.0" xml:lang="en-US" mode="voice" root="'+branch_name_fix+'" xmlns="http://www.w3.org/2001/06/grammar" tag-format="semantics/1.0">\n')
	grxml_file.write('  <rule id="'+branch_name_fix+'">\n')
	grxml_file.write('    <one-of>\n')

	# Writing list
	for c,k in branch.children.iteritems():
		if(is_leaf == 1):
			instance_arguments = get_instance_arguments(c);
			grxml_file.write('      <item> '+instance_arguments['name']+' </item>\n')
		elif(is_leaf == 2):
			grxml_file.write('      <item> '+c+' </item>\n')
		else:
			grxml_file.write('      <item> <ruleref uri="'+c+'.grxml"/> </item>\n')
	
	# Writing footer
	grxml_file.write('   </one-of>\n')
	grxml_file.write('  </rule>\n')
	grxml_file.write('</grammar>\n')
	
	# Closing file
	grxml_file.close()

def write_entity_branch(branch):
	next_children = {}
	for c,k in branch.children.iteritems():
		next_children = k.children
	
	if(len(next_children) > 0):
		#is branch
		sys.stdout.write(" writing the '"+branch.name+".grxml' file (branches) \n\t")
		write_entity_grxml_file(branch,0)
		for c,k in branch.children.iteritems():
			write_entity_branch(k)
	else:
		#is one before leafs
		sys.stdout.write(" writing the '"+branch.name+".grxml' file (leafs) \n\t")
		write_entity_grxml_file(branch,1)
		
#def write_grammar_branch(branch):

def get_function_name_and_args(raw_string):
	fn_match = re.match("(?P<function>[\w]+)\((?P<arg>(?P<args>[\w\W]+(,\s?)?)+)\)", raw_string)
	if(fn_match is None):
		return None
	else:
		fn_dict = fn_match.groupdict()
		return fn_dict

def get_list_of_functions(raw_string):
	fn_match = re.match("(?P<function>[\w]+)\((?P<arg>(?P<args>[\w\W]+(,\s?)?)+)\)", raw_string)
	if(fn_match is None):
		return None
	else:
		fn_dict = fn_match.groupdict()
		return fn_dict

def extract_rule_descriptor(raw_string):
	print raw_string
	id_field_end_i = raw_string.find(",")
	
	rest_arguments = bracket_list_items(raw_string[id_field_end_i+1:])
	print rest_arguments
	rest_arguments_start_i = rest_arguments[0].find("=>")+2
	rule_descriptor = rest_arguments[0][rest_arguments_start_i:].rstrip(" ").lstrip(" ")
	
	rule_name = ''
	rule_value = ''
	rule_symbol = 0
	
	rule_function_end_i = rule_descriptor.find(":-")
	if(rule_function_end_i == -1):
		#simple rule descriptor
		rule_descriptor_dict = get_function_name_and_args(rule_descriptor)	
		rule_name = rule_descriptor_dict['function']
		rule_symbol = 0
		
		rule_value = bracket_list_items(rule_descriptor_dict['args'])[0]
		rule_value = rule_value[0:rule_value.find('|')]
		rule_value = rule_value.replace(","," ")
	else:
		rule_symbol = 1
		
		rule_name_end_i = 0
		if(rule_descriptor[0] == '('):
			rule_name_end_i = rule_descriptor[1:].find('(')
			rule_name = rule_descriptor[1:rule_name_end_i+1]
		else:
			rule_name_end_i = rule_descriptor.find('(')
			rule_name = rule_descriptor[0:rule_name_end_i]
	
		rule_value = rule_descriptor[rule_function_end_i+2:-1]
		
		arguments_to_take_out = get_class_list (rule_value)
		for ar in arguments_to_take_out:
			rule_value = rule_value.replace('('+ar+')',"")

			
	return {'name': rule_name, 'value': rule_value, 'symbol': rule_symbol}

def extract_rule_full(rule_descriptor_raw,gr_dict):
	global grammar_dict
	global grammar_dict_spr
	rule_descriptor = extract_rule_descriptor(rule_descriptor_raw)
	
	if(gr_dict == "gpsr"):
		if(rule_descriptor['name'] not in grammar_dict):
			grammar_dict[rule_descriptor['name']] = []
		
		if(rule_descriptor['symbol'] == 0):
			grammar_dict[rule_descriptor['name']].append(rule_descriptor['value'])
		else:
			this_value = ""
			symbol_list = rule_descriptor['value'].split(',')
			for s in symbol_list:
				s = s.replace(" ","")
				if(find_name_in_branch(entity_branch,s)):
					this_value = this_value + '<ruleref uri="'+s+'.grxml"/> '
				else:
					category_start_i = s.find("_category")
					if category_start_i != -1:
						this_value = this_value + '<ruleref uri="'+s+'.grxml"/> '
						#need to write a category grxml literal file
						tmp_branch = find_branch(entity_branch,s[0:category_start_i])
						category_branch = Tree()
						category_branch.name = s
						category_branch.children = tmp_branch.children.copy()
						sys.stdout.write(" writing the '"+s+".grxml' file (categories) \n\t")
						write_entity_grxml_file(category_branch,2)
					else:
						this_value = this_value + '<ruleref uri="#'+s+'"/> '
			grammar_dict[rule_descriptor['name']].append(this_value)
	elif(gr_dict == "spr"):
		if(rule_descriptor['name'] not in grammar_dict_spr):
			grammar_dict_spr[rule_descriptor['name']] = []
		
		if(rule_descriptor['symbol'] == 0):
			grammar_dict_spr[rule_descriptor['name']].append(rule_descriptor['value'])
		else:
			this_value = ""
			symbol_list = rule_descriptor['value'].split(',')
			for s in symbol_list:
				s = s.replace(" ","")
				if(find_name_in_branch(entity_branch,s)):
					this_value = this_value + '<ruleref uri="'+s+'.grxml"/> '
				else:
					category_start_i = s.find("_category")
					if category_start_i != -1:
						this_value = this_value + '<ruleref uri="'+s+'.grxml"/> '
						#need to write a category grxml literal file
						tmp_branch = find_branch(entity_branch,s[0:category_start_i])
						category_branch = Tree()
						category_branch.name = s
						category_branch.children = tmp_branch.children.copy()
						sys.stdout.write(" writing the '"+s+".grxml' file (categories) \n\t")
						write_entity_grxml_file(category_branch,2)
					else:
						this_value = this_value + '<ruleref uri="#'+s+'"/> '
			grammar_dict_spr[rule_descriptor['name']].append(this_value)


def create_dict_branch(children,gr_dict):
	for gr_base_name,gr_base in children.iteritems():
		extract_rule_full(gr_base_name,gr_dict)

def created_dict_recursive_branch(gr,gr_dict):
	for inst in gr.instances:
		extract_rule_full(inst,gr_dict)
	for gr_base_name,gr_base in gr.children.iteritems():
		if len(gr_base.children) > 0:
			created_dict_recursive_branch(gr_base,gr_dict)
############ MAIN INSTRUCTIONS ############

### Reading the start of knowledge base
sys.stdout.write("Reading '" + kb_file + "'... ")
f_kb = open(kb_file,'r')
sys.stdout.write("done.\n")

### Reading the grammar part of knowledge base
sys.stdout.write("Reading '" + parse_file + "'... ")
f_grammar = open(parse_file,'r')
sys.stdout.write("done.\n")

sys.stdout.write("Cleaning raw input (white spaces, end of lines, etc.)... ")
kb_raw = clean_string(f_kb.read())
grammar_raw = clean_string(f_grammar.read())
sys.stdout.write("done.\n")

### Obtaining lists of all the classes
sys.stdout.write("Creating two lists of classes, one from each cleaned input file... ")
class_list = get_class_list(kb_raw)
class_list2 = get_class_list(grammar_raw)
sys.stdout.write("done.\n")

### Removing top node from second list and appending lists
sys.stdout.write("Creating one list of classes from both lists... ")
for c in class_list2:
	if c[:3] == 'top':
		class_list2.remove(c)
		break
class_list.extend(class_list2)
del class_list2
sys.stdout.write("done.\n")

### Creating a dictionary from list
sys.stdout.write("Creating a class dictionary from the unified list for easier manipulation... ")
for c in class_list:
	class_list_dict.append(get_class_arguments(c))
sys.stdout.write("done.\n")

### Building Tree
sys.stdout.write("Building the knowledge base tree from the class dictionary... ")
#print class_list_dict
build_tree()
#print_tree()
sys.stdout.write("done.\n")

### Create "grammars" directory
if not os.path.exists("./grammars"):
    sys.stdout.write("Creating the 'grammars' directory... ")
    os.makedirs("./grammars")
    sys.stdout.write("done.\n")
else:
    sys.stdout.write("Cleaning up 'grammars' directory... ")
    tmpf = glob.glob('./grammars/*')
    for f in tmpf:
        os.remove(f)
    sys.stdout.write("done.\n")

### Copying mandatory pre-existing grammars
if os.path.exists("./grammars_mandatory"):
    sys.stdout.write("Copying pre-existing grammars from 'grammars_mandatory' directory...\n")
    tmpf = glob.glob('./grammars_mandatory/*.grxml')
    for f in tmpf:
        sys.stdout.write("\t copying '"+ f +"'\n")
        shutil.copy(f,'./grammars/')
    sys.stdout.write("\tdone.\n")
else:
    sys.stdout.write("No 'grammars_mandatory' directory found; skipping copying pre-existing grammars.\n")
    
### Writing grxml files for entity branch
sys.stdout.write("Writing the grxml files from the 'entity' branch in the tree...\n\t")
entity_branch = class_tree.children['entity']
print '###### ENTITY BRANCH START ######'
print_branch(entity_branch,1)
print '###### ENTITY BRANCH END ######'
write_entity_branch(entity_branch)
sys.stdout.write("... done.\n")

### Writing grxml files for grammar branch
sys.stdout.write("Preparing to write the 'gpsr2015.grxml' file from the 'grammar' branch in the tree... \n")
grammar_branch = class_tree.children['grammar']
print '###### GRAMMMAR BRANCH START ######'
print_branch(grammar_branch,1)
print '###### GRAMMMAR BRANCH END ######'

# Creating grammar dictionary
sys.stdout.write("\t creating the grammar dictionary for easier manipulation... \n\t")
for gr_name,gr in grammar_branch.children.iteritems():
	if (gr_name == 'command'):
		created_dict_recursive_branch (gr,"gpsr")
	elif (gr_name == 'command_spr'):
		created_dict_recursive_branch (gr,"spr")
	else:
		create_dict_branch(gr.children,"gpsr")
		create_dict_branch(gr.children,"spr")
sys.stdout.write("... done.\n")

# Starting to write grxml gpsr2015 file
sys.stdout.write("Writing the 'gpsr2015.grxml' file from the 'grammar' branch in the tree... \n\t")
grxml_file_location = './grammars/gpsr2015.grxml'
grxml_file = open(grxml_file_location,'w')
	
# Writing header
grxml_file.write('<?xml version="1.0" encoding="utf-8"?>\n')
grxml_file.write('<grammar version="1.0" xml:lang="en-US" mode="voice" root="gpsr2015" xmlns="http://www.w3.org/2001/06/grammar" tag-format="semantics/1.0">\n')

# For each key in the grammar dictionary, creating a rule list
for rule_name,rule_list in grammar_dict.iteritems():
	sys.stdout.write(" writing the '"+rule_name+"' section \n\t")
	# Writing rule
	if(rule_name == "command"): #the "command" ruleset is the primary one
		grxml_file.write('  <rule id="gpsr2015">\n')
	else:
		grxml_file.write('  <rule id="'+rule_name+'">\n')
	
	# Writing rule list
	grxml_file.write('    <one-of>\n')
	for r in rule_list:
		grxml_file.write('      <item> '+r+' </item>\n')
	grxml_file.write('   </one-of>\n')

	# Writing rule end
	grxml_file.write('  </rule>\n\n')

# Writing footer
grxml_file.write('</grammar>\n')

# Closing file
grxml_file.close()

# Starting to write grxml gpsr2015 file
sys.stdout.write("Writing the 'spr.grxml' file from the 'grammar' branch in the tree... \n\t")
grxml_file_location = './grammars/spr.grxml'
grxml_file = open(grxml_file_location,'w')
	
# Writing header
grxml_file.write('<?xml version="1.0" encoding="utf-8"?>\n')
grxml_file.write('<grammar version="1.0" xml:lang="en-US" mode="voice" root="spr" xmlns="http://www.w3.org/2001/06/grammar" tag-format="semantics/1.0">\n')

# For each key in the grammar dictionary, creating a rule list
for rule_name,rule_list in grammar_dict_spr.iteritems():
	sys.stdout.write(" writing the '"+rule_name+"' section \n\t")
	# Writing rule
	if(rule_name == "command_spr"): #the "command" ruleset is the primary one
		grxml_file.write('  <rule id="spr">\n')
	else:
		grxml_file.write('  <rule id="'+rule_name+'">\n')
	
	# Writing rule list
	grxml_file.write('    <one-of>\n')
	for r in rule_list:
		grxml_file.write('      <item> '+r+' </item>\n')
	grxml_file.write('   </one-of>\n')

	# Writing rule end
	grxml_file.write('  </rule>\n\n')

# Writing footer
grxml_file.write('</grammar>\n')

# Closing file
grxml_file.close()

sys.stdout.write("... done.\n")

