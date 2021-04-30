import {Group, Home, Person, Restore} from "@material-ui/icons";
import {HomePage} from "../components/home";
import {UserPage} from "../components/user";
import {UsersPage} from "../components/users";
import {DetailsPage} from "../components/details";

export const routes = {
    home: { path: '/', title: 'Home', icon: Home},
    details: { path: '/details', title: 'Details', icon: Restore},
    users: { path: '/users', title: 'Users', icon: Group},
    userNew: { path: '/users/new', title: 'New user', icon: Person},
    userEdit: { path: '/users/:id', title: 'Edit user', icon: Person},
};

export const pages = [
    { route: routes.home, exact: true, component: HomePage },
    { route: routes.details, exact: true, component: DetailsPage },
    { route: routes.userNew, exact: true, component: UserPage },
    { route: routes.userEdit, exact: true, component: UserPage },
    { route: routes.users, exact: true, component: UsersPage }
];

