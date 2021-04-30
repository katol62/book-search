import React from "react";
import {useObserver} from "mobx-react-lite";

export const HomePage = () => {

    return useObserver ( () => (
        <div>
            <h1>Home</h1>
        </div>
    ))
};
