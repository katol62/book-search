import React from "react";
import {useObserver} from "mobx-react-lite";

export const DetailsPage = () => {

    return useObserver ( () => (
        <div>
            <h1>Details</h1>
        </div>
    ))
};
