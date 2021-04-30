import React, {useEffect, useState} from 'react';
import {useDispatch, useSelector} from "react-redux";
import {userActions} from "../../actions/users.actions";
import {makeStyles} from "@material-ui/core";
import Paper from "@material-ui/core/Paper";
import {
    PagingState,
    IntegratedPaging,
} from '@devexpress/dx-react-grid';
import {
    Grid,
    Table,
    TableHeaderRow,
    PagingPanel,
} from '@devexpress/dx-react-grid-material-ui';
import Button from "@material-ui/core/Button";
import { push } from 'connected-react-router';

const headCells = [
    { name: 'first_name', title: 'First Name' },
    { name: 'last_name', title: 'Last Name' },
    { name: 'email', title: 'E-mail' },
    { name: 'role', title: 'Role' },
];


const useStyles = makeStyles( theme => ({
    root: {
        display: 'flex',
        flexDirection: 'column'
    }
}));

const Users = () => {

    const [columns] = useState(headCells);

    const users = useSelector(store => store.users);
    console.log(users);
    const dispatch = useDispatch();
    console.log(dispatch);
    useEffect( () => {
       dispatch(userActions.getUsers())
    }, [dispatch]);

    const classes = useStyles();

    const handleNew = event => {
        event.preventDefault();
        dispatch(push('/users/new'));
    };

    const onRowSelect = (e, data, dipatch) => {
        console.log(data);
        dispatch(push('/users/'+data.id));
    };

    const TableRow = ( {row, ...props} ) => (
        <Table.Row
            {...props}
            hover
            onClick={ (e) => onRowSelect(e, row) }
            style={{
                cursor: 'pointer'
            }}
        />
    );

    return (
        <div className={classes.root}>
            <h1>Users</h1>
            <Button
                variant="contained"
                color="primary"
                onClick={handleNew}
            >
                New
            </Button>
            {
                users && users.users && (
                    <Paper>
                        <Grid
                            rows={users.users}
                            columns={columns}
                        >
                            <PagingState
                                defaultCurrentPage={0}
                                pageSize={5}
                            />
                            <IntegratedPaging />
                            <Table rowComponent={TableRow} />
                            <TableHeaderRow />
                            <PagingPanel />
                        </Grid>
                    </Paper>
                )
            }
        </div>
    )

};

export default Users;
