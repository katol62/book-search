import React from "react";
import {useObserver} from "mobx-react-lite";

export const PageNotFound = () => {

    return useObserver ( () => (
        <div>
            <h1>Page not found</h1>
        </div>
    ))
};
