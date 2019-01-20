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
            <button v-on:click=copyTestingCode class="btn-sm btn"> copy town url </button>
            <input id="town-url" v-bind:value="url"/>
            </div>`
})

export default null;
