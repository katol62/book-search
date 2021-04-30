import {Button, TextField, Grid, Typography, makeStyles, Paper} from "@material-ui/core";
import React, {useEffect} from "react";
import {useForm} from "react-hook-form";
import AuthService from "../../client/services/AuthService";

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

export const LoginPage = () => {
    const classes = useStyles();
    const { register, handleSubmit, setValue, formState } = useForm();

    useEffect(() => {
        register({ name: "email" }); // custom register react-select
        register({ name: "password" }); // custom register antd input
    }, [register]);

    const authService = AuthService.instance;
    const onSubmit = (data: any) => {
        authService.login(data.email, data.password)
    };

    const handleChange = (e: any) => {
        setValue(e.target.name, e.target.value);
    };

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
    )
};
