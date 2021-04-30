import React from "react";
import { Route, Switch, Redirect } from "react-router-dom";
import { useAuthDataContext } from "../components/auth-data-provider";
import { HomePage, UserDetailsPage, SignInPage } from "pages";

const PrivateRoute = ({ component, ...options }) => {
    const { user } = useAuthDataContext();
    const finalComponent = user ? component : SignInPage;

    return <Route {...options} component={finalComponent} />;
};

const Router = () => (
    <Switch>
        <Redirect from="/" to="/home"/>
        <PrivateRoute path="/home" component={HomePage} />
        <PrivateRoute path="/details" component={UserDetailsPage} />
    </Switch>
);
