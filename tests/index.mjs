// const puppeteer = require('puppeteer');
import puppeteer from 'puppeteer';

async function perform(browser, site) {
  const page = await browser.newPage();
  await page.goto(`https://${site}.com`);
  await page.screenshot({path: `${site}.png`});
}

(async () => {
  const b_a = await puppeteer.launch();
  const b_b = await puppeteer.launch();

  await perform(b_a, 'google');
  await perform(b_b, 'github');

  await b_a.close();
  await b_b.close();
})();
