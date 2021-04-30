<template>
  <q-layout view="hHh lpR fFf">

    <q-header reveal elevated class="bg-primary text-white">
      <q-toolbar>
        <q-btn unelevated
          v-if="pageData.showBack"
          v-go-back=" '/' "
          color="primary"
          icon="keyboard_arrow_left"
        />
        <q-toolbar-title class="text-center">
          {{ pageData.title }}
        </q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <router-view/>
    </q-page-container>

  </q-layout>
</template>

<script>
import { openURL } from 'quasar'
import { mapMutations } from 'vuex'

export default {
  name: 'PageLayout',
  data () {
    return {
      pageData: { title: '', showBack: false }
    }
  },
  methods: {
    ...mapMutations('auth', [
      'LOGIN_OK'
    ]),
    openURL,
    getPageData: function (pageData) {
      this.pageData = pageData
    },
    onDestroy: () => {
      window.console.log('layout destroyed')
    }
  },
  created () {
    this.$root.$on('pageData', this.getPageData)
  },
  beforeDestroy () {
    // Don't forget to turn the listener off before your component is destroyed
    this.$root.$off('pageData', this.onDestroy)
  }

}
</script>

<style>
</style>
