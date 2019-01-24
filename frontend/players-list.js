
Vue.component('players-list', {
  props: ['players'],
  template: `
  <b-list-group id="players">
    <b-list-group-item v-for="player in players" v-bind:key=player.name>
      <slot v-bind:player=player>
        {{player.name}}
      </slot>
    </b-list-group-item>
  </b-list-group>
  `
})

 // v-bind:class="{ voted: hasVotedOn(player) }"
export default null;
