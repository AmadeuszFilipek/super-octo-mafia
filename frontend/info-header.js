const stateToLabel = {
    new_town_form: "Create a new game or join existing one.",
    waiting_for_players: "Waiting for other players",
    day_voting: "Vote for a player you suspect to be from mafia.",
    day_results: "The town concil has decided:",
    night_voting: "Vote for a player to eliminate. Mafia does not pity.",
    night_results: "The mafia does not sleep and they eliminated:",
    game_ended: "The game has ended. Well played everyone.",
}

Vue.component('info-header', {
    props: ['state'],
    computed: {
        text() {
            return stateToLabel[this.state];
        },
    },
    template: "<h2 class='info-header'>{{ text }}</h2>"
  })

export default null;
