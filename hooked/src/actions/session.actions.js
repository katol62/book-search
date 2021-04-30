import { sessionConst } from "../constants/session.constants";
import { apiService } from "../services/api.service";

const { POST } = apiService();

export const login = (response) => {
    return {
        type: sessionConst.LOGIN,
        payload: response
    };
};

export const me = (response) => {
    return {
        type: sessionConst.ME,
        payload: response
    };
};

export const logout = () => {
    return {
        type: sessionConst.LOGOUT
    };
};

export const doMe = () => async(dispatch)  => {
    const result = await POST('/quasarapi/me');
    if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
        dispatch(logout())
    } else {
        dispatch(me(result));
    }
};

const doLogin = (email, password) => async dispatch => {
    const result = await POST('/quasarapi/login', {payload: {email: email, password: password}});
    if (result.hasOwnProperty('status') && result.status >= 400 && result.status < 600) {
        dispatch(logout())
    } else {
        dispatch(login(result));
    }
};

export const sessionActions = {
    login,
    logout,
    me,
    doLogin,
    doMe
};



