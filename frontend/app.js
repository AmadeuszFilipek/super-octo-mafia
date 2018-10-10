
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

      townSlug: null,
      playerName: null,
    },

    async mounted() {
      if (localStorage.playerName) {
	this.playerName = localStorage.playerName;
      }

      let pathParts = window.location.pathname.split('/');
      if (pathParts.length === 3 && pathParts[1] === 'towns') {
	this.townSlug = pathParts[2];
	await this.loadState();
	setInterval(this.loadState.bind(this), 200);
      }
    },

    computed: {
      currentPlayer() {
	if (this.appState && this.appState.players) {
	  return this.appState.players[this.playerName];
	}

	return false;
      },
    },

    methods: {
      setState(newState) {
	// if (newState && newState.version && newState.version > this.appState.version) {
	  this.appState = newState;
	// }
      },

      async loadState() {
	console.log('loadState');
	try {
	  let res = await fetch(`/api/towns/${this.townSlug}`);
	  let json = await res.json();

	  this.setState(json);
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

	this.setState(json);
	window.history.pushState({}, null, `/towns/${this.appState.slug}`);
	setInterval(this.loadState.bind(this), 1000);
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

	this.setState(json);
	window.history.pushState({}, null, `/towns/${this.appState.slug}`);
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
