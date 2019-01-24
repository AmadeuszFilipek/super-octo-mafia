
Vue.component('players-list', {
  props: ['players', 'currentPlayer'],
  methods: {
    isCurrentPlayer(player) {
      return this.currentPlayer === player;
    }
  },
  computed: {
    sortedPlayers() {
      return Object.values(this.players).sort((p1, p2) => {
        if (this.isCurrentPlayer(p1)) return -1;

        return 1;
      });
    }
  },
  template: `
  <b-list-group id="players">
    <b-list-group-item
      v-for="player in sortedPlayers"
      v-bind:class="{ current: isCurrentPlayer(player) }"
      v-bind:key=player.name>

      <slot v-bind:player=player>
        {{player.name}}
      </slot>
    </b-list-group-item>
  </b-list-group>
  `
})

 // v-bind:class="{ voted: hasVotedOn(player) }"
export default null;
