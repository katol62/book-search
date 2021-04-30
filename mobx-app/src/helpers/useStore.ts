import {useContext} from "react";
import {StoreContext} from "./store-provider";

export const useStore = () => useContext(StoreContext);
