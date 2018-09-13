
function init() {
  console.log('init');

  Vue.component('test-component', {
    data() {
      return { value: 23 };
    },
    template: '<input type="number" value={{ count }} />'
  });

  let app = new Vue({
    el: '#app',
    data: {
      state: {
	id: 'waiting_for_players',
	server_time: null
      }
    },

    created() {
      console.log('ready');

      this.loadState();

      setInterval(this.loadState.bind(this), 1000);
    },

    methods: {
      async loadState() {
	let res = await fetch('state');
	let json = await res.json();

	console.log("load state = ", json);

	this.state = json.state;
      },
    },
  });
}

document.addEventListener('DOMContentLoaded', init);
