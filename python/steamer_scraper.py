import time;
from selenium import webdriver;
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile;

profile = FirefoxProfile();
profile.set_preference("browser.helperApps.neverAsk.saveToDisk", 'text/csv');
driver = webdriver.Firefox(firefox_profile=profile);

driver.get("https://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=steamer&team=0&lg=all&players=0");
driver.find_element_by_link_text('Export Data').click();

## leave browser open for 10 seconds then close
time.sleep(10)
driver.quit();



