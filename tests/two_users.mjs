// const puppeteer = require('puppeteer');
import puppeteer from 'puppeteer';

async function perform(browser, site) {
  const page = await browser.newPage();
  await page.
}

(async () => {
  const b1 = await puppeteer.launch({ context: 'default', headless: false });
  const b2 = await puppeteer.launch({ context: 'joe', headless: false });
  const p1 = await b1.newPage();
  const p2 = await b2.newPage();

  await p1.goto(`https://localhost:5000/`);
  await p1.type('#town_slug', 'Swiebodzin');
  await p1.type('#player_name', 'Dziku');
  await p1.click('#create_town');
  await p1.waitForElement('#players');

  await p1.goto(`https://localhost:5000/towns/Swiebodzin`);
  await p1.type('#player_name', 'Przemo');
  await p1.click('#join_town');
  await p1.waitForElement('#players');

  await p1.click('#start_game');

  await p1.waitForElement('#votes');
  await p2.waitForElement('#votes');

  await p1.click('#votes.p2');
  await p2.click('#votes.p1');

  await p1.waitForElement('#votes.p2.voted');
  await p1.waitForElement('#votes.p2.voted');
  await p2.waitForElement('#votes.p1.voted');
  await p2.waitForElement('#votes.p1.voted');

  await Promise.all([
    create_town()
  ]);
    // b_a.type('#town_slug', 'Swiebodzin');
    // b_a.type('#player_name', 'Dziku');
    // b_a

  await Promise.all([b_a, b_b, b_c]);
})();
