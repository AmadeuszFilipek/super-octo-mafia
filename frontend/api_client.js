class ApiClient {
  constructor({ pathPrefix }) {
    this.pathPrefix = pathPrefix;
  }

  async getTown({ townSlug }) {
    let res = await fetch(`${this.pathPrefix}/api/towns/${townSlug}`);
    return await res.json();
  }

  async createTown({ townSlug, playerName }) {
    return await this.post('/api/towns', {
      town: {
        slug: townSlug
      },
      player: {
        name: playerName
      }
    });
  }

  async deleteTown({ townSlug }) {
    let res = await fetch(`${this.pathPrefix}/api/towns/${townSlug}`, { method: 'DELETE' });
    return await res.json();
  }

  async joinTown({ playerName, townSlug }) {
    return await this.post(`/api/towns/${townSlug}/players`, {
      player: {
        name: playerName
      }
    });
  }

  async startGame({ townSlug }) {
    return await this.post(`/api/towns/${townSlug}/start`);
  }

  async createVote({
    townSlug,
    voteeName,
    voterName
  }) {
    return await this.post(`/api/towns/${townSlug}/votes`, {
      vote: {
        voteeName: voteeName,
        voterName: voterName
      }
    })
  }

  // helper method performing POST requests with jsonified data
  // returns parsed json response
  async post(url, data = null) {
    let res = await fetch(`${this.pathPrefix}${url}`, {
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
