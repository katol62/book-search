import { sessionConst } from '../constants/session.constants';

export const initialState = {
    isAuthenticated: false,
    user: null,
    token: null,
};

export const session = (state = initialState, action = {}) => {
    console.log(action.type);
    switch (action.type) {
        case sessionConst.LOGIN:
            return {
                ...state,
                isAuthenticated: true,
                token: action.payload.data.token
            };
        case sessionConst.ME:
            return {
                ...state,
                isAuthenticated: true,
                user: action.payload.data.user
            };
        case sessionConst.LOGOUT:
            return {
                ...state,
                isAuthenticated: false,
                token: null,
                user: null
            };
        default:
            return state;

    }
};
