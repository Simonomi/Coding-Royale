import easygui, os
from tqdm import tqdm

# Takes in full file path of a .java file and returns the output from compiling and running it as a string
def compile_java(java_file):
	splitPath = java_file.split('\\')
	splitPath.pop(len(splitPath) - 1)
	filePath = ""
	for i in splitPath:
		filePath += i + "\\"
	os.chdir(filePath)
	filePart = java_file.split('\\')[len(splitPath)].split('.')[0]
	output = os.popen('javac "' + java_file + '" && java "' + filePart + '" && del ' + filePart + '.class').read()
	return output

# Selection for the original files
print("Select original files")
originals = easygui.fileopenbox("Select original files", "Challenge pack creator", '\*.java', None, True)
originals.sort()

# Selection for the changed files
print("Select changed files")
changed = easygui.fileopenbox("Select changed files", "Challenge pack creator", '\*.java', None, True)
changed.sort()

# Checks to make sure the same number of files are selected for both types
if len(originals) != len(changed):
	print("Please choose the same number of files for both originals and changed")


# Loops through each set of files and adds the necessary data to the output variable
output = ""
i = 0
# while i < len(originals):
for j in tqdm(range(len(originals))):
	# Checks to make sure the files match and throws an error otherwise
	if changed[i].split('\\')[len(changed[i].split('\\')) - 1] != originals[i].split('\\')[len(changed[i].split('\\')) - 1]:
		print("Make sure to give the corresponding files the exact same name")
		input("Press enter to continue...")
		exit()
	
	# Prevents a trailing or leading whitespace
	if i != 0:
		output += "\n"
	
	# Reads the changed file and writes it to the output variable
	file = open(changed[i], "r")
	output += changed[i].split("\\")[len(changed[i].split("\\")) - 1].split(".")[0] + "*name*" + file.read().replace("\n", "*newline*") + "\n"
	file.close()
	
	# Compiles the original file and adds it to the output variable
	output += compile_java(originals[i]).replace("\n", "*newline*")
	i += 1

# Gets save location
print("Choose save location")
outputFile = easygui.filesavebox("Save challenge pack", "Challenge pack creator", "\challenge.chp")

# Writes output variable to selected output file
file = open(outputFile, "w+")
file.write(output)
file.close()
