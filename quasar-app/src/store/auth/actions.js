import axios from 'axios'

export const login = function ({ commit }, form) {
  console.log(this.$router)
  axios
    .post('/api/login', form)
    .then(response => {
      if (response.data.token) {
        // setAxiosHeaders(response.data.token)
        commit('SET_ACCESS_TOKEN', response.data.token)
        commit('SET_LOGGED_IN', true)
        this.$router.push(this.$route && this.$route.query && this.$route.query.redirect ? this.$route.query.redirect : '/')
      }
    })
}

export const logout = function ({ commit }) {
  commit('CLEAR_ACCESS_TOKEN')
  commit('SET_LOGGED_IN', false)
  this.$router.push({ path: '/login' })
}

export const refreshToken = ({ commit }, router) => {
  return new Promise((resolve, reject) => {
    axios.post('/api/refresh-token')
      .then(function (response) {
        resolve(response)
      })
      .catch(function (error) {
        console.log(error)
        reject(error)
      })
  }, error => console.log(error))
}
