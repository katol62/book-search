import React, {useEffect, useState} from "react";
import {useObserver} from "mobx-react-lite";
import {makeStyles} from "@material-ui/core/styles";
import {useStore} from "../helpers/useStore";
import Paper from "@material-ui/core/Paper";
import Button from "@material-ui/core/Button";
import {
    PagingState,
    IntegratedPaging,
    Column, Row
} from '@devexpress/dx-react-grid';
import {
    Grid,
    Table,
    TableHeaderRow,
    PagingPanel,
} from '@devexpress/dx-react-grid-material-ui';
import {Box} from "@material-ui/core";

const useStyles = makeStyles( theme => ({
    root: {
        display: 'flex',
        flexDirection: 'column'
    }
}));

const headCells: Column[] = [
    { name: 'first_name', title: 'First Name' },
    { name: 'last_name', title: 'Last Name' },
    { name: 'email', title: 'E-mail' },
    { name: 'role', title: 'Role' },
];

export const UsersPage = () => {

    const [columns] = useState(headCells);
    const { user, router } = useStore().root;
    const classes = useStyles();

    useEffect( () => {
        user.getUsers();
    }, [user]);

    const onRowSelect = (e, data) => {
        e.preventDefault();
        user.resetUpdated();
        router.history.push('users/' + data.id);
    };

    const handleNew = (e) => {
        e.preventDefault();
        user.resetUpdated();
        router.history.push('/users/new')
    };

    const TableRow: Row = ( {row, ...props} ) => (
        <Table.Row
            {...props}
            hover
            onClick={ (e) => onRowSelect(e, row) }
            style={{
                cursor: 'pointer'
            }}
        />
    );

    return useObserver ( () => (
        <div className={classes.root}>
            <h1>Users</h1>
            <Box component="span" mb={3}>
                <Button
                    variant="contained"
                    color="primary"
                    onClick={ (e) => handleNew(e) }
                >
                    New
                </Button>
            </Box>
            {
                user.users && user.users.length && (
                    <Paper>
                        <Grid
                            rows={user.users}
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
    ))
};
