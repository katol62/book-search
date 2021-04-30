<template>
    <div class="container-fluid pl-0 pr-0">
        <b-sidebar id="main-sidebar" title="Sidebar" shadow>
            <div class="px-3 py-2">
                <b-nav vertical class="w-25">
                    <b-nav-item v-for="(item, index) in sideNavItems">
                        <router-link
                                :to="item.path">
                            {{item.title}}
                        </router-link>
                    </b-nav-item>
                </b-nav>
            </div>
        </b-sidebar>
        <b-nav>
            <b-button v-b-toggle href="#main-sidebar" @click.prevent>Toggle</b-button>
        </b-nav>

        <div>
            <router-view />
        </div>
    </div>
</template>

<script lang="ts">
    import { Component, Prop, Vue } from 'vue-property-decorator';

    @Component
    export default class Dashboard extends Vue {

      public sideNavItems = [
        {title: 'Home', path: '/'},
        {title: 'Users', path: '/users'}
      ];

    }

</script>

<style scoped>

</style>
