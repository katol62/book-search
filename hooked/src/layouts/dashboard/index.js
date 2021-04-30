import React, {useState} from 'react';
import routes from "../../helpers/routes";
import {NavLink} from 'react-router-dom';

import clsx from 'clsx';

import Drawer from '@material-ui/core/Drawer';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import ExitToApp from '@material-ui/icons/ExitToApp';
import ChevronLeftIcon from '@material-ui/icons/ChevronLeft';
import ChevronRightIcon from '@material-ui/icons/ChevronRight';
import Divider from '@material-ui/core/Divider';
import List from '@material-ui/core/List';

import {AppBar, Toolbar, IconButton } from "@material-ui/core";
import MenuIcon from '@material-ui/icons/Menu';
import {sessionActions} from "../../actions/session.actions";
import {useDispatch, useSelector} from "react-redux";
import {makeStyles, useTheme} from "@material-ui/core/styles";
import CustomBreadcrumbs from "../../components/breadcrumbs";
// import CustomBreadcrumbs from "../../components/breadcrumbs";

const drawerWidth = 240;

const useStyles = makeStyles(theme => ({
    root: {
        display: 'flex',
    },
    appBar: {
        zIndex: theme.zIndex.drawer + 1,
        transition: theme.transitions.create(['width', 'margin'], {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.leavingScreen,
        }),
    },
    appBarShift: {
        marginLeft: drawerWidth,
        width: `calc(100% - ${drawerWidth}px)`,
        transition: theme.transitions.create(['width', 'margin'], {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.enteringScreen,
        }),
    },
    menuButton: {
        marginRight: 36,
    },
    hide: {
        display: 'none',
    },
    drawer: {
        width: drawerWidth,
        flexShrink: 0,
        whiteSpace: 'nowrap',
    },
    drawerOpen: {
        width: drawerWidth,
        transition: theme.transitions.create('width', {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.enteringScreen,
        }),
    },
    drawerClose: {
        transition: theme.transitions.create('width', {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.leavingScreen,
        }),
        overflowX: 'hidden',
        width: theme.spacing(7) + 1,
        [theme.breakpoints.up('sm')]: {
            width: theme.spacing(9) + 1,
        },
    },
    toolbar: {
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: theme.spacing(0, 1),
        ...theme.mixins.toolbar,
    },
    stopper: {
        flex: '0 0 0px',
        width: 0,
        overflow: 'hidden',
    },
    content: {
        flexGrow: 1,
        padding: theme.spacing(3),
    },
}));

const getMenuItems = () => {
    return [
        { path: '/', title: routes.home.title, icon: routes.home.icon },
        { path: routes.users.path, title: routes.users.title, icon: routes.users.icon },
        { path: routes.details.path, title: routes.details.title, icon: routes.details.icon }
    ];
};

const DashboardLayout = (props) => {

    const logout = event => {
        event.preventDefault();
        dispatch(sessionActions.logout())
    };

    const handleDrawerOpen = () => {
        setOpen(true);
    };

    const handleDrawerClose = () => {
        setOpen(false);
    };

    const dispatch = useDispatch();
    const menuItems = useSelector( () => getMenuItems());
    console.log(menuItems);
    const [open, setOpen] = useState(false);
    const classes = useStyles();
    const theme = useTheme();

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
                    <CustomBreadcrumbs/>
                    <span className={classes.stopper}></span>
                    <IconButton
                        color="inherit"
                        className={classes.menuButton}
                        onClick={logout}
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

export default DashboardLayout
