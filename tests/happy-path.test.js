const puppeteer = require('puppeteer')

async function createPlayer({id, isHeadless=true}) {
  return await puppeteer.launch({
    context: 'context-' + id,
    headless: isHeadless,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
}

async function joinTown({ townUrl, playerName, browser }) {
  const page = await browser.newPage();
  await page.goto(townUrl);
  await page.type('#player-name', playerName);
  await page.waitForSelector('#join-town');
  await page.click('#join-town');
}

describe('Happy path', () => {
  test('It successfully goes through all application steps', async () => {
    const townUrl = 'http://localhost:5000/towns/Swiebodzin';
    const hostBrowser = await createPlayer({ id: 'host', isHeadless: false });
    const hostPage = await hostBrowser.newPage();
    const browsers = await Promise.all(
      [1, 2, 3, 4, 5, 6, 7, 8].map(id => createPlayer({ id }))
    );

    // Host creates new town
    await hostPage.goto('http://localhost:5000/');
    await hostPage.type('#town-slug', 'Swiebodzin');
    await hostPage.type('#player-name', 'Host');
    await hostPage.click('#create-town');

    // Rest players joins to the town
    [0, 1, 2, 3, 4, 5, 6, 7].forEach(id => joinTown({ townUrl, playerName: `player-${id}`, browser: browsers[id] }));

    await hostPage.waitForSelector('#start-game');
    await hostPage.click('#start-game');

    await hostPage.waitForSelector('#day-voting .voting-btn');
    await hostPage.click('.voting-btn');

    await hostPage.waitForSelector('#game-ended');

    const gameEndText = await hostPage.$eval('#game-ended', el => el.innerText);

    await expect(gameEndText).toEqual('Game is Ended!');

    hostBrowser.close();
    browsers.forEach(browser => browser.close())
  }, 20000);
});
