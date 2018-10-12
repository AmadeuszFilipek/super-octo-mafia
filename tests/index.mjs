// const puppeteer = require('puppeteer');
import puppeteer from 'puppeteer';

async function perform(browser, site) {
  const page = await browser.newPage();
  await page.goto(`https://${site}.com`);
  await page.screenshot({path: `tmp/${site}.png`});
}

(async () => {
  const b_a = await puppeteer.launch({ context: 'default', headless: false });
  const b_b = await puppeteer.launch({ context: 'default', headless: false });
  const b_c = await puppeteer.launch({ context: 'default', headless: false });

  await perform(b_a, 'google');
  await perform(b_b, 'github');
  await perform(b_c, 'bing');

  await b_a.close();
  await b_b.close();
  await b_c.close();
})();
