const stateToMafiaLabel = {
    new_town_form: "Create a new game or join existing one.",
    waiting_for_players: "Waiting for other players",
    day_voting: "Vote for a player you suspect to be from mafia.",
    day_results: "The town concil has decided.",
    night_voting: "The night is the time to act. Close your eyes and open them again when the rest of the city sleeps. Vote for a player to eliminate.",
    night_results: "The mafia does not sleep and in the shadows of night they killed another person.",
    game_ended: "The game has ended. Well played everyone.",
}

const stateToCivilLabel = {
  new_town_form: "Create a new game or join existing one.",
  waiting_for_players: "Waiting for other players",
  day_voting: "Vote for a player you suspect to be from mafia.",
  day_results: "The town concil has decided:",
  night_voting: "It's getting late. Close your eyes and wait for the morning signal.",
  night_results: "The mafia does not sleep and in the shadows of night they killed another person.",
  game_ended: "The game has ended. Well played everyone.",
}

Vue.component('info-header', {
    props: ['state', 'isMafia'],
    computed: {
        text() {
          if (this.isMafia) {
            return stateToCivilLabel[this.state];
          }
          else {
            return stateToMafiaLabel[this.state];
          }
        },
    },
    template: "<h2 class='info-header'>{{ text }}</h2>"
  })

export default null;
