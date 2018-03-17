import os
import sys
import time
from datetime import datetime
import argparse
import re
import httplib2
import requests
from tqdm import tqdm

parser = argparse.ArgumentParser()

parser.add_argument("-s", "--season", help="numeric season", type=int)
parser.add_argument("-p", "--path", help="download path")

args = parser.parse_args()

if args.path:
	DOWNLOAD_PATH = os.path.expanduser(args.path)
else:
	DOWNLOAD_PATH = os.path.expanduser('~/Downloads')

this_year = datetime.now().year
dl_year = str((args.season or this_year))
dl_year_short = dl_year[-2:]

## CHECK YEAR AND ABORT IF INVALID
if not dl_year.isdigit():
	sys.exit(f"Invalid year {args.season}, please use digits")
elif int(dl_year) < 1900 or int(dl_year) > int(this_year):
	sys.exit(f"Invalid year {args.season}, must be between 1900 and this year ({this_year})")

## CHECK DOWNLOAD PATH AND ABORT IF INVALID
if not os.path.isdir(DOWNLOAD_PATH):
	sys.exit(f"Invalid path {DOWNLOAD_PATH}")


def get_download_path(file_basename):
	return ( DOWNLOAD_PATH + "/" + (time.strftime("%Y%m%d")+"_"+file_basename) ).replace("//", "/")

def check_url_exists(dl_url):
	r = httplib2.Http().request(dl_url, 'HEAD')
	return int(r[0]['status']) < 400

def download_data(url_dict, data_name):
	dl_path = get_download_path(data_name)
	pretty_name = re.sub(r"/[\-\_]/", " ", data_name)
	dl_url = ( url_dict['base'] + url_dict['data'][data_name] )

	if not check_url_exists(dl_url):
		print(f"#{dl_url} does not exist, perhaps you should specify different parameters")
		quit()

	print(f"Beginning file download of {pretty_name} data from {url_dict['base']}, saving to {dl_path}...")

	r = requests.get(dl_url, stream=True)
	with open(dl_path, "wb") as handle:
		for data in tqdm(r.iter_content()):
			handle.write(data)
	return dl_path


site_info = {
	'base' : "http://www.retrosheet.org",
	'data': {
		'events': f"/events/{dl_year}eve.zip",
		'events_decade' : f"/events/{dl_year}seve.zip",
		'events_postseason' : f"/events/{dl_year}post.zip"
		},
	'pages' : {}
	}

download_data(site_info, 'events')







