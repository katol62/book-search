import { take, put, select, delay } from 'redux-saga/effects';
import {doMe, logout} from "../actions/session.actions";
import { sessionConst } from '../constants/session.constants';
import { push } from 'connected-react-router';

export default function* () {
    const authToken = yield select(state => state.session.token);
    if (authToken) {
        yield delay(10);
        yield put(doMe());
    } else {
        yield delay(10);
        yield put(logout());
        yield put(push('/'));
    }

    while (true) {

        yield take(sessionConst.LOGIN);
        yield put(doMe());

        yield take(sessionConst.ME);
        yield put(push('/'));

        yield take(sessionConst.LOGOUT);
        yield put(push('/'));

    }
}
