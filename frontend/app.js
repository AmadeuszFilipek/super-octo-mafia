
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
    },

    created() {
      console.log('ready');
      let pathParts = window.location.pathname.split('/');

      if (pathParts.length === 3 && pathParts[1] === 'towns') {
	this.townSlug = pathParts[2];
	this.loadState();
      }

      // setInterval(this.loadState.bind(this), 1000);
    },

    methods: {
      async loadState() {
	try {
	  let res = await fetch(`/api/towns/${this.townSlug}`);
	  let json = await res.json();

	  this.appState = json;
	} catch(e) {
	  console.error('error =', e);
	  window.history.pushState({}, null, '/');
	}
      },

      async createNewTown() {
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
	console.log("json = ", json);

	this.appState = json;
	window.history.pushState({}, null, `/towns/${this.appState.slug}`);
      },
    },
  });
}

document.addEventListener('DOMContentLoaded', init);
