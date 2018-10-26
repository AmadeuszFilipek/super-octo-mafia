class ApiClient {
  async getTown({ townSlug }) {
    let res = await fetch(`/api/towns/${townSlug}`);
    return await res.json();
  }

  async createTown({ townSlug, playerName }) {
    return await this.post('/api/towns', {
      town: { slug: townSlug },
      player: { name: playerName }
    });
  }

  async joinTown({ playerName, townSlug }) {
    return await this.post(`/api/towns/${townSlug}/players`, {
      player: { name: playerName }
    });
  }

  async startGame({ townSlug }) {
    return await this.post(`/api/towns/${townSlug}/start`);
  }

  async createVote({ townSlug, voteeName, voterName }) {
    return await this.post(`/api/towns/${townSlug}/votes`, {
      vote: { voteeName, voterName }
    })
  }

  // helper method performing POST requests with jsonified data
  // returns parsed json response
  async post(url, data = null) {
    let res = await fetch(url, {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {
        'Content-Type': 'application/json'
      }
    });
    return await res.json();
  }
}

export default ApiClient;
