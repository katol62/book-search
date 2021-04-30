import React from "react";
import {useStore} from "../helpers/useStore";

import {Redirect, Route, Switch} from 'react-router-dom';
import {LoginPage} from "../components/login";
import {Dashboard} from "./dashboard/dashboard";
import {CssBaseline} from "@material-ui/core";
import {pages, routes} from "../helpers/routes";
import {PageNotFound} from "../components/not-found";

export const Views = () => {

    const {session} = useStore().root;

    const renderRoot = () => {
        if (session.isAuthenticated) {
            return (
                <div>
                    <CssBaseline />

                    <Dashboard>
                        <Switch>
                            <Redirect exact from="/" to={routes.home.path}/>
                            {
                                pages.map(
                                    ({ route, exact, component }, index) =>
                                        <Route key={route.path} path={route.path} exact={exact} component={component} />
                                )
                            }
                            <Route component={PageNotFound} />
                        </Switch>
                    </Dashboard>
                </div>
            )
        } else {
            return (
                <LoginPage/>
            )
        }
    };

    return (
        <Switch>
            <Route path="/" render={renderRoot}/>
        </Switch>
    )
};
