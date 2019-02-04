
Vue.component('players-list', {
  props: ['players', 'currentPlayer', 'votee'],
  methods: {
    isCurrentPlayer(player) {
      return this.currentPlayer === player;
    },
    isAVotee(player) {
      return this.votee === player.name;
    },
    character_icon_for(player) {

      if (this.currentPlayer === player) {
        return `/${this.currentPlayer.character}.png`;
      }
      else if (this.currentPlayerKnows(player)) {
        return `/${player.character}.png`;
      }
      else {
        return `/unknown.png`;
      }
    },
    alive_icon_for(player) {
      let alive_status = player.is_alive ? "alive" : "dead"
      return `/${alive_status}.png`;
    },
    currentPlayerKnows(player) {
      if (!this.currentPlayer) {
        return false;
      }
      return !player.is_alive ||
        this.currentPlayer.character === "mafia" ||
        this.currentPlayer.is_alive === false;
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
      v-bind:class="{
        current: isCurrentPlayer(player),
        voted: isAVotee(player)
      }"
      v-bind:key=player.name
    >
      <img v-bind:src="character_icon_for(player)"/>
      <img v-bind:src="alive_icon_for(player)"/>
      {{player.name}}
      <slot v-bind:player=player>
      </slot>

    </b-list-group-item>
  </b-list-group>
  `
})

export default null;
