import React from 'react';
import {useDispatch, useSelector} from "react-redux";
import {sessionActions} from "../../actions/session.actions";
import { push } from 'connected-react-router';
import {withRouter} from "react-router";

const Home = () => {

    const dispatch = useDispatch();
    const session = useSelector(state => state.session );

    const handleLogout = event => {
        event.preventDefault();
        dispatch(sessionActions.logout())
    };

    const gotoUsers = event => {
        event.preventDefault();
        dispatch(push('/users'));
    };

    return (
        <div className="home">
            <h1>Home</h1>
            { session.user && (
                <button onClick={handleLogout}>
                    Logout
                </button>
            )}
            <button onClick={gotoUsers}>
                Go to users
            </button>

        </div>
    );
};
export default withRouter(Home);
