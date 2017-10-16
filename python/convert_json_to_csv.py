import json
import sys
import csv
import ntpath
import os

json_file_path = sys.argv[1]

# puts output CSV in same folder as input JSON file

csv_file_path = (os.path.dirname(json_file_path) + "/"+ os.path.splitext(ntpath.basename(json_file_path))[0] + ".csv")

with open(json_file_path) as json_data:
  json_parsed = json.load(json_data)

# open a file for writing

csv_data_file = open(csv_file_path, 'w')

# create the csv writer object

csv_writer = csv.writer(csv_data_file)

count = 0

# import pdb; pdb.set_trace()

## Parse each member of array of JSON data

for r in json_parsed:
  if count == 0:

    # header is the JSON keys
    header = r.keys()

    csv_writer.writerow(header)

  count += 1

  csv_writer.writerow(r.values())

csv_data_file.close()