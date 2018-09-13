
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

      // this.loadState();

      // setInterval(this.loadState.bind(this), 1000);
    },

    methods: {
      async loadState() {
	let res = await fetch('state');
	let json = await res.json();

	console.log("load state = ", json);

	this.appState = json;
      },

      async createNewTown() {
	let requestBody = {
	  town: { slug: this.townSlug },
	  player: { name: this.playerName }
	};
	let requestJSON = JSON.stringify(requestBody);

	console.log("create town request = ", requestJSON);

	let res = await fetch('/towns', {
	  method: 'POST',
	  body: requestJSON,
	  headers: {
	    'Content-Type': 'application/json'
	  }
	});
	let json = await res.json();
	console.log("json = ", json);

	this.appState = json;
	console.log("this.appState = ", this.appState);
      },
    },
  });
}

document.addEventListener('DOMContentLoaded', init);
