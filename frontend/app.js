import ApiClient from '/api_client.js';

Vue.component('debug', {
  props: [`value`],
  template: `<pre>value={{value}}</pre>`
})

function init() {
  console.log('init');

  let app = new Vue({
    el: '#app',
    data: {
      appState: {
        version: 0,
        state: {
          id: 'new_town_form',
        }
      },
      playerName: null,
    },

    async mounted() {
      if (localStorage.playerName) {
        this.playerName = localStorage.playerName;
      }

      let pathParts = window.location.pathname.split('/');
      if (pathParts.length === 3 && pathParts[1] === 'towns') {
        this.appState.slug = pathParts[2];
        await this.loadState();
        this.startPolling();
      }
    },

    computed: {
      currentPlayer() {
        if (this.appState && this.appState.players) {
          return this.appState.players[this.playerName];
        }

        return false;
      },

      isHost() {
        if (this.currentPlayer) {
          return this.currentPlayer.is_host;
        }

        return false;
      },

      canShowStartButton() {
        return this.isHost && this.appState.is_ready_to_start;
      },

      canShowProgressButton() {
        return this.isHost && (this.appState.state.id === 'day_results' || this.appState.state.id === 'night_results'); 
      },

      api() {
        return new ApiClient({ pathPrefix: 'http://127.0.0.1:5000/' });
      },
    },

    methods: {
      setState(newState) {
        if (newState.version > this.appState.version) {
          // console.log("setting new state", newState);
          this.appState = newState;
          // console.log("this.appState = ", this.appState);
        }
      },

      hasVotedOn(votee) {
        return this.appState.votes[this.playerName] === votee.name;
      },

      canVoteOn(player) {
        if (this.appState.state.id === 'night_voting' && this.currentPlayer.character === 'civil') {
          return false;
        }
        if (!this.currentPlayer.is_alive || !player.is_alive) {
          return false;
        }
        return this.currentPlayer !== player;
      },

      startPolling() {
        setInterval(this.loadState.bind(this), 1000);
      },

      async loadState() {
        try {
          let json = await this.api.getTown({
            townSlug: this.appState.slug
          });

          this.setState(json);
        } catch (e) {
          console.error('error =', e);
          window.history.pushState({}, null, '/');
        }
      },

      async createTown() {
        let json = await this.api.createTown({
          townSlug: this.appState.slug,
          playerName: this.playerName
        });
        console.log("json = ", json);

        this.setState(json);
        window.history.pushState({}, null, `/towns/${this.appState.slug}`);
        this.startPolling();
      },

      async joinTown() {
        let json = await this.api.joinTown({
          playerName: this.playerName,
          townSlug: this.appState.slug
        });

        this.setState(json);
        window.history.pushState({}, null, `/towns/${this.appState.slug}`);
      },
      
      async startGame() {
        let json = await this.api.startGame({
          townSlug: this.appState.slug
        });

        this.setState(json);
      },

      async vote(votee) {
        let json = await this.api.createVote({
          townSlug: this.appState.slug,
          voteeName: votee.name,
          voterName: this.currentPlayer.name
        });

        this.setState(json);
      },

      async progressState() {
        let json = await this.api.progressState({
          townSlug: this.appState.slug
        });
      },
    },

    watch: {
      playerName(name) {
        localStorage.playerName = name;
      }
    }
  });
}

document.addEventListener('DOMContentLoaded', init);

export default app;
