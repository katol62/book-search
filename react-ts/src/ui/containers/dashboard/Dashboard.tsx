import React from "react";
import {AppBar, List, ListItem, ListItemIcon, ListItemText, IconButton, useTheme, Toolbar, Drawer} from "@material-ui/core";
import {dashboardStyles} from "./DashboardStyles";
import AuthService from "../../../client/services/AuthService";
import {useState} from "react";
import {NavLink} from "react-router-dom";
import MenuIcon from '@material-ui/icons/Menu';
import ExitToApp from '@material-ui/icons/ExitToApp';
import ChevronLeftIcon from '@material-ui/icons/ChevronLeft';
import ChevronRightIcon from '@material-ui/icons/ChevronRight';
import Divider from '@material-ui/core/Divider';

import clsx from 'clsx';

import {routes} from "../../../client/helpers/Routes";
import {CustomBreadcrumbs} from "../../components/Breadcumbs";

export const Dashboard = (props: any) => {

    const [open, setOpen] = useState(false);
    const classes = dashboardStyles();
    const theme = useTheme();

    const menuItems = Object.values(routes).filter(value => (value.path !== '/users/new' && value.path !== '/users/:id'))
    const authService = AuthService.instance;

    const logout = (event: any) => {
        event.preventDefault();
        authService.logout();
    };

    const handleDrawerOpen = () => {
        setOpen(true);
    };

    const handleDrawerClose = () => {
        setOpen(false);
    };

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
                    <div className={classes.toolbarLeft}>
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
                    </div>
                    <IconButton
                        color="inherit"
                        className={classes.menuRightButton}
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
