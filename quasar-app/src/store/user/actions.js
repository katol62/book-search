import axios from 'axios'
import { Notify, Loading } from 'quasar'

axios.defaults.headers.common['Content-Type'] = 'application/json'

export const users = function ({ commit }) {
  Loading.show()
  axios
    .get('/api/users')
    .then(response => {
      Loading.hide()
      if (response.status === 200) {
        commit('UPDATE_USERS', response.data.users)
        commit('SET_USER', response.data.user)
      } else {
        Notify.create({
          type: 'warning',
          color: 'warning',
          timeout: 1000,
          message: 'Error loading users! Status: ' + response.status + ' . Details: ' + response.data.msg
        })
      }
    })
    .catch((error) => {
      console.log(error)
      Loading.hide()
      let message = error.response ? 'Status: ' + error.response.status + '. ' + error.response.data.msg : 'Server error!'
      Notify.create({
        type: 'error',
        color: 'red',
        timeout: 1000,
        message: message
      })
    })
}
