import {createStore, applyMiddleware, combineReducers} from 'redux';
import reducers from '../reducers';
import thunkMiddleware from 'redux-thunk';
import createSagaMiddleware from 'redux-saga';
import history from './history';
import { loadState, storage } from './storage';
import rootSaga from '../sagas';

import { routerMiddleware, connectRouter } from 'connected-react-router';

const rootReducer = combineReducers({
    router: connectRouter(history),
    ...reducers,
});

const sagaMiddleware = createSagaMiddleware();

const middlewares = [
    routerMiddleware(history),
    sagaMiddleware,
    thunkMiddleware];

const persistentState = loadState();

const store = createStore(
    connectRouter(history)(rootReducer),
    persistentState,
    applyMiddleware(
        ...middlewares
    )
);
storage(store);

// for (let saga in rootSaga) {
//     sagaMiddleware.run(rootSaga[saga]);
// }

sagaMiddleware.run(rootSaga, store.dispatch)

export default store
