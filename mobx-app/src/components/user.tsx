import React, {useEffect, useState} from "react";
import {observer, useObserver} from "mobx-react-lite";
import {Button, Grid, makeStyles, TextField, Typography} from "@material-ui/core";
import {useForm} from "react-hook-form";
import {useParams} from "react-router";
import {useStore} from "../helpers/useStore";
import {autorun} from "mobx";

const useStyles = makeStyles( theme => ({
    root: {
        flexGrow: 1,
    }
}));

type FormData = {
    id: string,
    first_name: string,
    last_name: string,
    email: string,
    password: string
}

const defaultData = {
    id: '',
    first_name: '',
    last_name: '',
    email: '',
    password: ''
};

export const UserPage = observer(() => {

    const classes = useStyles();
    const { register, formState } = useForm<FormData>();

    const { user } = useStore().root;

    const [values, setValues] = useState(defaultData);
    const { id } = useParams();

    useEffect( () => {
        if (id) {
            user.getUser(id);
        }
    }, [user, id]);

    useEffect(() => autorun(() => {
        if (user.user != null) {
            setValues(user.user);
            user.resetUser();
        }
    }));

    const onSubmit = e => {
        e.preventDefault();
        if (id) {
            user.updateUser(values);
        } else {
            user.createUser(values);
        }
    };

    const handleChange = (e) => {
        e.preventDefault();
        const name = e.target.name;
        const value = e.target.value;
        let copy = {...values};
        copy[name] = value;
        setValues(copy);
    };

    return useObserver ( () => (
        <div className={classes.root}>
            <h1>User</h1>
            <form onSubmit={e => onSubmit(e)}>
                <Grid container
                      spacing={3}
                      direction="column"
                      justify="center"
                      alignItems="center"
                      alignContent="center"
                >
                    <Grid item>
                        <Typography variant="h6">{id ? 'Edit' : 'New'}</Typography>
                    </Grid>
                    <Grid item>
                        <TextField
                            name="first_name"
                            label="First name"
                            type="text"
                            innerRef={register}
                            value={values.first_name || ''}
                            required
                            onChange={handleChange}
                        />
                    </Grid>
                    <Grid item>
                        <TextField
                            name="last_name"
                            label="Last name"
                            type="text"
                            value={values.last_name || ''}
                            innerRef={register}
                            required
                            onChange={handleChange}
                        />
                    </Grid>
                    <Grid item>
                        <TextField
                            name="email"
                            label="Email address"
                            type="email"
                            innerRef={register}
                            value={values.email || ''}
                            required
                            onChange={handleChange}
                        />
                    </Grid>
                    {
                        !id && (
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
                        )
                    }
                    <Grid item>
                        <Button variant="contained"
                                color="primary"
                                type="submit"
                                disabled={formState.isSubmitting}>
                            {id ? 'Update' : 'Create'}
                        </Button>
                    </Grid>
                    {
                        user.isUpdated && (
                            <Grid item>
                                <Typography variant="body2">{id ? 'User updated' : 'User created'}</Typography>
                            </Grid>
                        )
                    }
                </Grid>
            </form>
        </div>
    ))
});
