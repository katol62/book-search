import throttle from 'lodash/throttle';
import { commonConst } from "../constants";

export const loadState = () => {
    try {
        const serialized = sessionStorage.getItem(commonConst.STORE);
        if (serialized === null) {
            return undefined;
        }
        return JSON.parse(serialized);
    } catch (e) {
        return undefined;
    }
};

const saveState = (state) => {
    try {
        const serialized = JSON.stringify(state);
        sessionStorage.setItem(commonConst.STORE, serialized);
    } catch (e) {}
};

export const storage = store => {
  store.subscribe(
      throttle( () => {
          saveState({
              session: store.getState().session
          });
      })
  )
};
