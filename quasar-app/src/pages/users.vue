<template>
  <div class="q-pa-md">
      <q-table
        title="Users"
        :data="data"
        :columns="columns"
        row-key="name"
      />
  </div>
</template>

<script>
import { mapState } from 'vuex'
export default {
  name: 'users',
  data () {
    return {
      columns: [
        { name: 'id', label: '#', field: 'id', align: 'left', style: 'width: 15px', sortable: true },
        { name: 'first_name', align: 'left', label: 'First Name', field: 'first_name', sortable: true },
        { name: 'last_name', align: 'left', label: 'Last Name', field: 'last_name', sortable: true },
        { name: 'email', align: 'left', label: 'Email', field: 'email', sortable: true },
        { name: 'role', align: 'left', label: 'Role', field: 'role', sortable: true }
      ],
      data: []
    }
  },
  computed: {
    ...mapState([
      'user/users'
    ]) },
  mounted () {
    this.$store.watch(
      state => state.user.users,
      (newValue, oldValue) => {
        this.data = newValue
      },
      deep => true
    )
    this.$store.dispatch('user/users')
  }
}
</script>

<style scoped>

</style>
