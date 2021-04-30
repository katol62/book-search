import React, {useEffect, useState} from "react";
import {makeStyles} from "@material-ui/core/styles";
import Snackbar from "@material-ui/core/Snackbar";
import ErrorIcon from '@material-ui/icons/Error';
import InfoIcon from '@material-ui/icons/Info';
import CheckCircleIcon from '@material-ui/icons/CheckCircle';
import WarningIcon from '@material-ui/icons/Warning';
import {useDispatch, useSelector} from "react-redux";
import {IStore} from "../../client/store/Store";
import NotificationActions from "../../client/actions/NotificationActions";
import green from '@material-ui/core/colors/green';
import red from '@material-ui/core/colors/red';
import amber from '@material-ui/core/colors/amber';
import clsx from 'clsx';
import MuiAlert, { AlertProps } from '@material-ui/lab/Alert';

const useStyles = makeStyles( theme => ({
    root: {
        display: 'flex',
    },
    success: {
        backgroundColor: green[600],
    },
    error: {
        backgroundColor: red[700],
    },
    info: {
        backgroundColor: green[600],
    },
    danger: {
        backgroundColor: red[700],
    },
    warning: {
        backgroundColor: amber[700],
    },
    icon: {
        fontSize: 20,
    },
    iconVariant: {
        opacity: 0.9,
        marginRight: theme.spacing(1),
    },
    message: {
        display: 'flex',
        alignItems: 'center',
    },
}));

const variantIcon = {
    success: CheckCircleIcon,
    warning: WarningIcon,
    error: ErrorIcon,
    info: InfoIcon,
    danger: ErrorIcon
};

export const Alert = (props: AlertProps) => {
    return <MuiAlert
        elevation={6} variant="filled" {...props}/>;
}

export const SnackbarComponent = () => {
    const {open, message, type} = useSelector((store: IStore) => store.notification);
    const dispatch = useDispatch();
    const actions = new NotificationActions();
    const classes = useStyles();

    const handleClose = () => {
        dispatch(actions.close());
    }

    return (
        <Snackbar
            anchorOrigin={{
                vertical: "top",
                horizontal: "right"
            }}
            open={open}
            autoHideDuration={4000}
            onClose={handleClose}
            aria-describedby="client-snackbar"
        >
            <MuiAlert
                elevation={6} variant="filled"
                onClose={handleClose} severity={type}>
                {message}
            </MuiAlert>
        </Snackbar>
    );
}
