// const puppeteer = require('puppeteer');
import puppeteer from 'puppeteer';

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://google.com');
  await page.screenshot({path: 'google.png'});

  await browser.close();
})();
