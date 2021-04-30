import {Group, Home, Restore, Person} from "@material-ui/icons";

export default {
    home: { path: '/', title: 'Home', icon: Home},
    details: { path: '/details', title: 'Details', icon: Restore},
    users: { path: '/users', title: 'Users', icon: Group},
    userNew: { path: '/users/new', title: 'New user', icon: Person},
    userEdit: { path: '/users/:id', title: 'Edit user', icon: Person},
}

