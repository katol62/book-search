export function SET_LOGGED_IN (state, status) {
  state.loggedIn = status
}
export function SET_ACCESS_TOKEN (state, token) {
  sessionStorage.setItem('token', token)
}
export function CLEAR_ACCESS_TOKEN (state) {
  sessionStorage.removeItem('token')
}
