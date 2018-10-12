
class ApiClient {
  async getTown({ townSlug }) {
    let res = await fetch(`/api/towns/${townSlug}`);
    return await res.json();
  }

  async createTown({ townSlug, playerName }) {
    let requestBody = {
      town: { slug: townSlug },
      player: { name: playerName }
    };
    let res = await fetch('/api/towns', {
      method: 'POST',
      body: JSON.stringify(requestBody),
      headers: {
	'Content-Type': 'application/json'
      }
    });
    return await res.json();
  }

  async joinTown({ playerName, townSlug }) {
    let requestBody = {
      player: { name: playerName }
    };

    let res = await fetch(`/api/towns/${townSlug}/players`, {
      method: 'POST',
      body: JSON.stringify(requestBody),
      headers: {
	'Content-Type': 'application/json'
      }
    });
    return await res.json();
  }

  async startGame({ townSlug }) {
    let res = await fetch(`/api/towns/${townSlug}/start`, {
      method: 'POST',
      headers: {
	'Content-Type': 'application/json'
      }
    });
    return await res.json();
  }

  async createVote({ townSlug, voteeName, voterName }) {
    let requestBody = {
      vote: {
	voteeName: voteeName,
	voterName: voterName
      }
    };
    let res = await fetch(`/api/towns/${townSlug}/votes`, {
      method: 'POST',
      body: JSON.stringify(requestBody),
      headers: {
	'Content-Type': 'application/json'
      }
    });
    return await res.json();
  }
}

export default ApiClient;
