import time;
import os;
import sys;
from selenium import webdriver;
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile;

if len(sys.argv) > 1:
	download_path = sys.argv[1];
else:
	download_path = '~/Desktop';

if not os.path.isdir((os.path.expanduser('~/Desktop'))):
	sys.exit('Invalid path %s.'%(download_path));

print('File will be saved to %s'%(download_path));

download_file_path = os.path.expanduser((download_path+'/Fangraphs Leaderboard.csv'));
ts_file_name = (time.strftime("%Y%m%d")+"_steamer_projections.csv"); ## custom file name
profile = FirefoxProfile();

profile.set_preference("browser.helperApps.neverAsk.saveToDisk", 'text/csv');
profile.set_preference("browser.download.manager.showWhenStarting", False);
profile.set_preference("browser.download.dir", download_path);
profile.set_preference("browser.download.folderList", 2); ## download to last location set

driver = webdriver.Firefox(firefox_profile=profile);

uri = "https://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=steamer&team=0&lg=all&players=0";

driver.get(uri);
driver.find_element_by_link_text('Export Data').click();

## leave browser open for 5 seconds then close
time.sleep(5);
driver.quit();
print('Success, file saved to %s'%(download_path));

if os.path.isfile(download_file_path):
	os.rename(download_file_path, ts_file_name );
	print('Renamed file %s to %s'%(download_path,ts_file_name));
else:
	sys.exit('Error, unable to locate file at %s'%(download_path));



