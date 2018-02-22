import time
import os
import sys
from selenium import webdriver
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
import glob

def get_filename(folder_before, folder_after):
	change = set(folder_after) - set(folder_before)
	if len(change) > 0:
		return next(iter(change))

def gen_uri(player_type='bat'):
	return "https://www.fangraphs.com/projections.aspx?pos=all&stats="+player_type+"&type=steamer&team=0&lg=all&players=0"

if len(sys.argv) > 1:
	download_path = os.path.expanduser(sys.argv[1])
else:
	download_path = os.path.expanduser('~/Desktop')

if not os.path.isdir((download_path)):
	sys.exit('Invalid path %s.'%(download_path))

print('File will be saved to %s'%(download_path))

profile = FirefoxProfile()

profile.set_preference("browser.helperApps.neverAsk.saveToDisk", 'text/csv')
profile.set_preference("browser.download.manager.showWhenStarting", False)
profile.set_preference("browser.download.dir", download_path)
profile.set_preference("browser.download.folderList", 2) ## download to last location set

driver = webdriver.Firefox(firefox_profile=profile)
partially_downloaded_files = len(glob.glob(download_path+'/*.part'))

for player_type in ['bat', 'pit']:
	folder_contents_before = os.listdir(download_path)
	driver.get( gen_uri( player_type ) )
	driver.find_element_by_link_text('Export Data').click()

	ts_file_name = (time.strftime("%Y%m%d")+"_"+player_type+"steamer_projections.csv") ## custom file name

	## for up to 30 seconds, check every 2 seconds if download finished
	t_end = time.time() + 30
	while len(glob.glob(download_path+'/*.part')) > partially_downloaded_files:
		if time.time() < t_end:
			time.sleep(2)

	dl_file_name = get_filename( folder_contents_before, os.listdir(download_path) ) ## downloaded file name
	download_file_path = os.path.expanduser((download_path+'/'+dl_file_name))

	if os.path.isfile(download_file_path):
		print('Success, file saved to %s'%(download_path))
		os.rename(download_file_path, ts_file_name )
		print('Renamed file %s to %s'%(download_path,ts_file_name))
	else:
		driver.quit()
		sys.exit('Error, unable to locate file at %s'%(download_path))

## leave browser open for 5 seconds then close
driver.quit()
print("Finished.")
