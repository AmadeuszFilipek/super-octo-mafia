const puppeteer = require('puppeteer')

async function createPlayer({number, isHeadless=true}) {
  const browser = await puppeteer.launch({
    context: 'context-' + number,
    headless: isHeadless,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  return await browser.newPage()
}

(async () => {
  const host = await createPlayer({ number: 0, isHeadless: false });
  const p1 = await createPlayer({ number: 1 });
  const p2 = await createPlayer({ number: 2 });
  const p3 = await createPlayer({ number: 3 });
  const p4 = await createPlayer({ number: 4 });
  const p5 = await createPlayer({ number: 5 });
  const p6 = await createPlayer({ number: 6 });
  const p7 = await createPlayer({ number: 7 });
  const p8 = await createPlayer({ number: 8 });

  // Host creates new town
  await host.goto(`http://localhost:5000/`);
  await host.type('#town-slug', 'Swiebodzin');
  await host.type('#player-name', 'Host');
  await host.click('#create-town');

  // Rest players joins to the town
  await p1.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p1.type('#player-name', 'Player1');
  await p1.waitForSelector('#join-town')
  await p1.click('#join-town');

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

  await p6.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p6.type('#player-name', 'Player6');
  await p6.waitForSelector('#join-town')
  await p6.click('#join-town');

  await p7.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p7.type('#player-name', 'Player7');
  await p7.waitForSelector('#join-town')
  await p7.click('#join-town');

  await p8.goto(`http://localhost:5000/towns/Swiebodzin`);
  await p8.type('#player-name', 'Player8');
  await p8.waitForSelector('#join-town')
  await p8.click('#join-town');

  await host.waitForSelector('#start-game');
  await host.click('#start-game');
})();

