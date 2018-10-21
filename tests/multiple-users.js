const puppeteer = require('puppeteer')
const fetch = require('node-fetch')

global.fetch = fetch;

async function createPlayer({number, isHeadless=true}) {
  const browser = await puppeteer.launch({
    context: 'context-' + number,
    headless: isHeadless,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  return await browser.newPage()
}

(async () => {
  const p1 = await createPlayer({ number:1, isHeadless: false });
  const p2 = await createPlayer({ number:2 });
  const p3 = await createPlayer({ number:3 });
  const p4 = await createPlayer({ number:4 });
  const p5 = await createPlayer({ number:5 });

  // Player1 creates new town
  await p1.goto(`http://localhost:5000/`);
  await p1.type('#town-slug', 'Swiebodzin');
  await p1.type('#player-name', 'Player1');
  await p1.click('#create-town');

  // Rest players joins to the town
  await p2.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p2.type('#player-name', 'Player2');
  await p2.waitForSelector('#join-town')
  await p2.click('#join-town');

  await p3.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p3.type('#player-name', 'Player3');
  await p3.waitForSelector('#join-town')
  await p3.click('#join-town');

  await p4.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p4.type('#player-name', 'Player4');
  await p4.waitForSelector('#join-town')
  await p4.click('#join-town');

  await p5.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p5.type('#player-name', 'Player5');
  await p5.waitForSelector('#join-town')
  await p5.click('#join-town');

  // await p1.waitForSelector('#start-game');
  // await p1.click('#start-game');
})();
