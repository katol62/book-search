<template>
  <div class="fixed fixed-center bg-grey-1 text-white">
  <form v-on:submit.prevent="onSubmit()">
    <q-card square  class="flex-center text-center" style="width: 400px; padding:50px">
      <img src="/statics/quasar-logo.png" style='max-width:300px; padding-top:30px; padding-bottom:50px'>
      <q-separator />
      <div class="text-left" >
        <q-input id='username' type='text' v-model.trim="form.username" label="User Name" required autofocus/>
        <q-input id="password" type="password" v-model="form.password" label="Password" required/><br>
      </div>
      <q-card-actions>
        <q-btn type="submit" class="fit" color="primary">Login</q-btn>
      </q-card-actions>
    </q-card>
  </form>
  </div>
</template>

<script>
debugger
export default {
  name: 'Login',
  data () {
    return {
      rememberMe: true,
      form: {
        username: '',
        password: ''
      }
    }
  },

  methods: {
    onSubmit () {
      this.$auth.login({
        fetchUser: false,
        data: this.form,
        rememberMe: this.rememberMe
      })
        .then(response => {
        }, (res) => {
          console.log('Res: ', res)
        })
    }
  },

  created () {
    this.$root.$emit('pageData', { title: 'Login', showBack: true })
  }
}
</script>

<style scoped>

</style>
