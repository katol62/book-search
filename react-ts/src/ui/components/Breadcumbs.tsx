import React, {useEffect, useMemo, useState} from "react";
import {Link, useLocation} from 'react-router-dom';
import Breadcrumbs from '@material-ui/core/Breadcrumbs';
import Typography from '@material-ui/core/Typography';
import {routes} from "../../client/helpers/Routes";
import {makeStyles} from "@material-ui/core/styles";

class IPathObject {
    key: number = 0;
    path: string = '';
    title: string = '';
    active: boolean = false;
}

const useStyles = makeStyles( theme => ({
    root: {
        display: 'flex',
    },
    crumbs: {
        color: '#ffffff'
    }
}));


export const CustomBreadcrumbs = () => {
    const routesArray = useMemo(() => Object.values(routes), []);
    const location = useLocation();
    const [crumbs, setCrumbs] = useState<IPathObject[]>([]);
    const classes = useStyles();

    useEffect( ()=> {
        const paths = location.pathname.split('/')
            .map((p, i, arr) => {
                    const path = `${arr.slice(0, i + 1).join('/')}`;
                    const o = routesArray.find((o: any) => o.path === path);
                    const title = o ? o.title : (!isNaN(Number(arr[arr.length-1])) ? 'Edit' : arr[arr.length-1]);
                    let elm:IPathObject = new IPathObject();
                    if (i === 0) {
                        elm.key = i;
                        elm.path = '/';
                        elm.title = 'Home';
                        elm.active = (i === arr.length - 1);
                    }
                    else if (i === arr.length - 1) {
                        elm.key = i;
                        elm.path = path;
                        elm.title = title;
                        elm.active = (i === arr.length - 1);
                    } else {
                        elm.key = i;
                        elm.path = path;
                        elm.title = title;
                        elm.active = (i === arr.length - 1);
                    }
                    return elm;
                },
            );
        if (paths.length === 2 && paths[1].path === '/') {
            paths.shift();
        }
        setCrumbs(paths);
    }, [location, routesArray]);

    const renderCrumbs = () => {
        return (
            crumbs.map(({ key, path, title, active }, i) => (
                    <div key={key}>
                        { !active
                            ? <Link className={classes.crumbs} color="inherit" key={key} to={path} >{title}</Link>
                            : <Typography>{title}</Typography>
                        }
                    </div>
                )
            ))
    };

    return (
        <Breadcrumbs aria-label="breadcrumb" className={classes.crumbs}>
            {
                renderCrumbs()
            }
        </Breadcrumbs>
    );

};
