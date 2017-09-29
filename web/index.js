window.onload = function() {
  const app = new Vue({
    el: '#app',
    data: {
      pools: [],
      numPools: 4,
      numTeams: 14,
      numRounds: 3,
      snake: true
    },
    methods: {
      createPools: function() {
        axios.get('http://localhost:3000/pools', {
          params: {
            numPools: this.numPools,
            numTeams: this.numTeams,
            numRounds: this.numRounds,
            snake: this.snake
          }
        }).then(response => { this.pools = response.data })
      }
    }
  });
}