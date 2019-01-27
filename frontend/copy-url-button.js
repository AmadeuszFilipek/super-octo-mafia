Vue.component('copy-url-button', {
  computed: {
    url() {
      return window.location.href;
    }
  },
  methods: {
    copyTestingCode() {
      let testingCodeToCopy = document.querySelector('#town-url');
      testingCodeToCopy.select();

      try {
        var successful = document.execCommand('copy');
      } catch (err) {
      }

      window.getSelection().removeAllRanges();
    },
  },
  template: `<div>
            <b-button v-on:click=copyTestingCode class="btn-sm btn"> copy town url </b-button>
            <b-input id="town-url" type='text' v-bind:value="url">
            </b-input>
            </div>`
})

export default null;
