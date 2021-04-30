import React, {useEffect} from 'react';
import { useDispatch } from 'react-redux'
import { sessionActions } from "../../actions/session.actions";
import {Button, TextField, Grid, Typography, makeStyles, Paper} from "@material-ui/core";
import useForm from "react-hook-form";

const useStyles = makeStyles( theme => ({
    root: {
        flexGrow: 1,
    },
    paper: {
        padding: theme.spacing(2),
        margin: '10% auto',
        maxWidth: 500,
    },
}));

export const Login = () => {

    const dispatch = useDispatch();

    const { register, handleSubmit, setValue, formState } = useForm();
    useEffect(() => {
        register({ name: "email" }); // custom register react-select
        register({ name: "password" }); // custom register antd input
    }, [register]);

    const onSubmit = data => {
        dispatch(sessionActions.doLogin(data.email, data.password))
    };

    const handleChange = (e) => {
        setValue(e.target.name, e.target.value);
    };

    const classes = useStyles();

    return (
        <div className={classes.root}>
            <Paper className={classes.paper}>
                <form onSubmit={handleSubmit(onSubmit)}>
                    <Grid container
                          spacing={3}
                          direction="column"
                          justify="center"
                          alignItems="center"
                          alignContent="center"
                    >
                        <Grid item>
                            <Typography variant="h6">Login</Typography>
                        </Grid>
                        <Grid item>
                            <TextField
                                name="email"
                                label="Email address"
                                type="email"
                                innerRef={register}
                                required
                                onChange={handleChange}
                            />
                        </Grid>
                        <Grid item>
                            <TextField
                                name="password"
                                label="Password"
                                type="password"
                                innerRef={register}
                                required
                                onChange={handleChange}
                            />
                        </Grid>
                        <Grid item>
                            <Button variant="contained"
                                    color="primary"
                                    type="submit"
                                    disabled={formState.isSubmitting}>
                                Login
                            </Button>
                        </Grid>
                    </Grid>
                </form>
            </Paper>
        </div>
    );
};

export default Login;
