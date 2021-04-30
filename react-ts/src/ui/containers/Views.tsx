import React, {useEffect, useState} from 'react';
import {Route, Switch} from 'react-router-dom';
import {CssBaseline} from "@material-ui/core";
import {useSelector} from "react-redux";
import {IStore} from "../../client/store/Store";
import {pages} from "../../client/helpers/Routes";
import {PageNotFound} from "../pages/Not-Found";
import {Dashboard} from "./dashboard/Dashboard";
import {LoginPage} from "../pages/Login";
import {SnackbarComponent} from "../components/Snackbar";

export const Views = () => {
    const {user} = useSelector((store: IStore) => store.auth);
    const [authenticated, setAuthenticated] = useState(false);

    useEffect( () => {
        if (user) {
            setAuthenticated(true);
        } else {
            setAuthenticated(false);
        }
    }, [user])

    const renderRoot = () => {
        if (authenticated) {
            return (
                <div>
                    <CssBaseline />

                    <Dashboard>
                        <Switch>
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
                <div>
                    <LoginPage/>
                </div>
            )
        }
    };

    return (
        <div>
            <Switch>
                <Route path="/" render={renderRoot}/>
            </Switch>
            <SnackbarComponent />
        </div>
    )
};
