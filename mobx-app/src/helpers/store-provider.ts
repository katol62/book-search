import { createContext } from "react";
import RootStore from "../stores/root-store";
import {routingStore} from "./history-helper";

export const rootStore = new RootStore(routingStore);

export const StoreContext = createContext({
    // root: new RootStore(null)
    root: rootStore
});
export const StoreProvider = StoreContext.Provider;
