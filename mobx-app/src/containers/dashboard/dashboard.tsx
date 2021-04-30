import React, {useState} from "react";
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import Drawer from '@material-ui/core/Drawer';

import {NavLink} from 'react-router-dom';
import {AppBar, Toolbar, IconButton } from "@material-ui/core";
import MenuIcon from '@material-ui/icons/Menu';
import ExitToApp from '@material-ui/icons/ExitToApp';
import ChevronLeftIcon from '@material-ui/icons/ChevronLeft';
import ChevronRightIcon from '@material-ui/icons/ChevronRight';
import Divider from '@material-ui/core/Divider';

import clsx from 'clsx';

import {routes} from "../../helpers/routes";
import {dashboardStyles} from "./dashboard-styles";
import {CustomBreadcrumbs} from "../../components/breadcrumbs";
import {useTheme} from "@material-ui/core/styles";
import {useStore} from "../../helpers/useStore";

const menuItems = [
    { path: routes.home.path, title: routes.home.title, icon: routes.home.icon },
    { path: routes.users.path, title: routes.users.title, icon: routes.users.icon },
    { path: routes.details.path, title: routes.details.title, icon: routes.details.icon }
];


export const Dashboard = (props: any) => {

    const {session} = useStore().root;

    const classes = dashboardStyles();
    const theme = useTheme();

    const logout = event => {
        event.preventDefault();
        session.logout();
    };

    const handleDrawerOpen = () => {
        setOpen(true);
    };

    const handleDrawerClose = () => {
        setOpen(false);
    };

    const [open, setOpen] = useState(false);

    const menuContent = (
        <div>
            <List>
                {
                    menuItems.map(({ title, path, icon: Icon }, i) => (
                        <ListItem button key={i}
                                  component={NavLink} to={path}
                                  onClick={handleDrawerClose}
                        >
                            <ListItemIcon>
                                <Icon />
                            </ListItemIcon>
                            <ListItemText primary={title} />
                        </ListItem>
                    ))
                }
            </List>
        </div>
    );

    return (
        <div className={classes.root}>
            <AppBar
                position="fixed"
                className={clsx(classes.appBar, {
                    [classes.appBarShift]: open,
                })}
            >
                <Toolbar className={classes.toolbar}>
                    <IconButton
                        color="inherit"
                        aria-label="open drawer"
                        onClick={handleDrawerOpen}
                        edge="start"
                        className={clsx(classes.menuButton, {
                            [classes.hide]: open,
                        })}
                    >
                        <MenuIcon />
                    </IconButton>
                    <CustomBreadcrumbs />
                    <span className={classes.stopper}></span>
                    <IconButton
                        color="inherit"
                        className={classes.menuButton}
                        onClick={ (e) => logout(e) }
                    >
                        <ExitToApp />
                    </IconButton>
                </Toolbar>
            </AppBar>

            <Drawer
                variant="permanent"
                className={clsx(classes.drawer, {
                    [classes.drawerOpen]: open,
                    [classes.drawerClose]: !open,
                })}
                classes={{
                    paper: clsx({
                        [classes.drawerOpen]: open,
                        [classes.drawerClose]: !open,
                    }),
                }}
                open={open}
            >
                <div className={classes.toolbar}>
                    <IconButton onClick={handleDrawerClose}>
                        {theme.direction === 'rtl' ? <ChevronRightIcon /> : <ChevronLeftIcon />}
                    </IconButton>
                </div>
                <Divider />
                {menuContent}
            </Drawer>
            <main className={classes.content}>
                <div className={classes.toolbar} />
                {props.children}
            </main>
        </div>
    );


};
