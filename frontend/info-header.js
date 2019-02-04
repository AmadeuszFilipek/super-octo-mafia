const stateLabel = {
  new_town_form: {
    civil: {
      alive: "Create a new game or join existing one.",
      dead: "Create a new game or join existing one.",
    },
    mafia: {
      alive: "Create a new game or join existing one.",
      dead: "Create a new game or join existing one.",
    }
  },

  waiting_for_players: {
    civil: {
      alive: "Waiting for other players",
      dead: "Waiting for other players",
    },
    mafia: {
      alive: "Waiting for other players",
      dead: "Waiting for other players",
    }
  },
  day_voting: {
    civil: {
      alive: "Vote for a player you suspect to be from mafia.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    },
    mafia: {
      alive: "Vote for a player you wish to eliminate.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    }
  },
  day_results: {
    civil: {
      alive: "The town concil has decided.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    },
    mafia: {
      alive: "The town concil has decided.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    }
  },
  night_voting: {
    civil: {
      alive: "It's getting late. Close your eyes and wait for the morning signal.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    },
    mafia: {
      alive: "The night is the time to act. Close your eyes and open them again when the rest of the city sleeps. Vote for a player to eliminate.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    }
  },
  night_results: {
    civil: {
      alive: "The mafia does not sleep and in the shadows of night they killed another person.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    },
    mafia: {
      alive: "You have eliminated a player.",
      dead: "You are dead. Now you see everything but cannot say anything.",
    }
  },
  game_ended: {
    civil: {
      alive: "The game has ended. Well played everyone.",
      dead: "The game has ended. Well played everyone.",
    },
    mafia: {
      alive: "The game has ended. Well played everyone.",
      dead: "The game has ended. Well played everyone.",
    }
  },
}

Vue.component('info-header', {
    props: ['state', 'isAlive', 'isMafia'],
    computed: {
        text() {

          let character_type = this.isMafia ? "mafia" : "civil";
          let live_state = this.isAlive ? "alive" : "dead";

          return stateLabel[this.state][character_type][live_state];
        }
    },
    template: "<h2 class='info-header'>{{ text }}</h2>"
  })

export default null;
