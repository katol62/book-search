<template>
  <div class="fixed fixed-center bg-grey-1 text-white">
   <form v-on:submit.prevent="onSubmit()">
      <q-card square  class="flex-center text-center" style="width: 400px; padding:50px">
        <img src="/statics/app-logo-128x128.png" style='max-width:300px; padding-top:30px; padding-bottom:50px'>
        <q-separator />
        <div class="text-left" >
            <q-input id="email" type="text" v-model.trim="form.email" float-label="User Name" required autofocus/>
            <q-input id="password" type="password" v-model="form.password" float-label="Password" required/><br>
        </div>
        <q-card-actions>
          <q-btn type="submit" class="fit" color="primary">Login</q-btn>
        </q-card-actions>
      </q-card>
    </form>
  </div>
</template>

<style>
</style>

<script>
export default {
  data () {
    return {
      drawerState: true,
      rememberMe: true,
      form: {
        email: '',
        password: ''
      }
    }
  },
  methods: {
    onSubmit () {
      this.$store.dispatch('auth/login', this.form)
        .then(() => {
          // this.$router.push(this.$route.query.redirect || '/')
        })
        .catch(error => {
          console.log(error)
        })
    }
  }
}
</script>
