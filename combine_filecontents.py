#!PYTHON
import os, re


#List all files matching the argument
folder_path = r"D:\work\devops\Windows-Validate"

# Regex to match filenames
regex = re.compile(r"^.*_scheduledtask\.csv$")

header_written = False

# Output file
output_file = r"D:\work\devops\scheduledtask_combined.csv"

with open(output_file, 'w', encoding='utf-8') as outfile:
	for filename in os.listdir(folder_path):
		if regex.match(filename):
			print('match found:', filename)
			file_path = os.path.join(folder_path, filename)
			with open(file_path, 'r', encoding='utf-8') as infile:
				lines = infile.readlines()
				if not lines:
					continue # skip empty files
				if not header_written:
					outfile.write(lines[0])
					header_written = True
				outfile.writelines(lines[1:])

print(f"All matching files have been combined into {output_file}")

