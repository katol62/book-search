import React, { useMemo }  from 'react';
import { useSelector } from "react-redux";
import {Route, Switch} from 'react-router-dom';
import Login from "../login";
import Home from "../home";
import Details from "../details";
import Users from "../users";
import routes from "../../helpers/routes";
import PageNotFound from "../pagenotfound";
import User from "../users/new";

import { CssBaseline } from "@material-ui/core";
import DashboardLayout from "../../layouts/dashboard";
import {ThemeProvider} from "@material-ui/styles";
import theme from "../../helpers/theme";

export const createRoutes = () => {
    const pages = [
        { route: routes.details, exact: true, component: Details },
        { route: routes.home, exact: true, component: Home },
        { route: routes.userNew, exact: true, component: User },
        { route: routes.userEdit, exact: true, component: User },
        { route: routes.users, exact: true, component: Users }
    ];
    return pages;
};

const Views = () => {

    const session = useSelector(store => store.session);
    const navroutes = useMemo( () => createRoutes(), []);
    const renderRoot = () => {
        if (session.isAuthenticated) {
            return (
                <ThemeProvider theme={theme}>
                    <CssBaseline/>
                    <DashboardLayout>
                        <Switch>
                            {/*<Redirect exact from="/" to={routes.home.path}/>*/}
                            {
                                navroutes.map(
                                    ({ route, exact, component }, index) =>
                                        <Route key={route.path} path={route.path} exact={exact} component={component} />
                                )
                            }
                            <Route component={PageNotFound} />
                        </Switch>
                    </DashboardLayout>
                </ThemeProvider>
            )
        } else {
            return (
                <ThemeProvider theme={theme}>
                    <Login/>
                </ThemeProvider>
            )
        }
    };

    return (
        // renderRoot()
        <Switch>
            <Route path="/" render={renderRoot}/>
        </Switch>
    );
};

export default Views
