
function init() {
  console.log('init');

  let app = new Vue({
    el: '#app',
    data: {
      appState: {
	state: {
	  id: 'new_town_form',
	}
      },

      townSlug: 'omg',
      playerName: 'jacek',

      get currentPlayer() {
	return this.appState.players[this.playerName];
      },
    },

    async mounted() {
      if (localStorage.playerName) {
	this.playerName = localStorage.playerName;
      }

      let pathParts = window.location.pathname.split('/');
      if (pathParts.length === 3 && pathParts[1] === 'towns') {
	this.townSlug = pathParts[2];
	await this.loadState();
      }
    },

    methods: {
      async loadState() {
	console.log('loadState');
	try {
	  let res = await fetch(`/api/towns/${this.townSlug}`);
	  let json = await res.json();

	  this.appState = json;
	} catch(e) {
	  console.error('error =', e);
	  window.history.pushState({}, null, '/');
	}
      },

      async createTown() {
	let requestBody = {
	  town: { slug: this.townSlug },
	  player: { name: this.playerName }
	};
	let requestJSON = JSON.stringify(requestBody);
	console.log("create town request = ", requestJSON);

	let res = await fetch('/api/towns', {
	  method: 'POST',
	  body: requestJSON,
	  headers: {
	    'Content-Type': 'application/json'
	  }
	});
	let json = await res.json();
	console.log("create town json = ", json);

	this.appState = json;
	window.history.pushState({}, null, `/towns/${this.appState.slug}`);
      },

      async joinTown() {
	let requestBody = {
	  player: { name: this.playerName }
	};
	let requestJSON = JSON.stringify(requestBody);
	console.log("join town request = ", requestJSON);

	let townSlug = this.appState.slug;
	let res = await fetch(`/api/towns/${townSlug}/players`, {
	  method: 'POST',
	  body: requestJSON,
	  headers: {
	    'Content-Type': 'application/json'
	  }
	});
	let json = await res.json();
	console.log("join town json = ", json);

	this.appState = json;
	window.history.pushState({}, null, `/towns/${this.appState.slug}`);
      },
    },

    watch: {
      playerName(name) {
	console.log('playerName watcher', name);
	localStorage.playerName = name;
      }
    }
  });
}

document.addEventListener('DOMContentLoaded', init);
