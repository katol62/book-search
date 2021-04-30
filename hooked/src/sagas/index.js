import { spawn } from 'redux-saga/effects';
import sessionSaga from './session';

export default function* rootSaga() {
    yield spawn(sessionSaga);
}

