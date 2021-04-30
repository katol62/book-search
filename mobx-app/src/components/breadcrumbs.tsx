import React, {useEffect, useMemo, useState} from "react";
import {Link, useLocation} from 'react-router-dom';
import {routes} from '../helpers/routes';
import Breadcrumbs from '@material-ui/core/Breadcrumbs';
import Typography from '@material-ui/core/Typography';
import {isNumeric} from 'rxjs/util/isNumeric';

class IPathObject {
    key: number = 0;
    path: string = '';
    title: string = '';
    active: boolean = false;
}

export const CustomBreadcrumbs = () => {
    const routesArray = useMemo(() => Object.values(routes), []);
    const location = useLocation();
    const [crumbs, setCrumbs] = useState<IPathObject[]>([]);

    useEffect( ()=> {
        // const paths = location.pathname.split('/')
        //     .map((p, i, arr) => {
        //             const path = `${arr.slice(0, i + 1).join('/')}`;
        //             const o = routesArray.find(o => o.path === path);
        //             const title = o ? o.title : (isNumeric(arr[arr.length-1]) ? 'Edit' : arr[arr.length-1]);
        //             if (i === 0) return {
        //                 key: i,
        //                 path: '/',
        //                 title: 'Home',
        //                 active: (i === arr.length - 1),
        //                 link: (i < arr.length - 1)
        //             };
        //
        //             if (i === arr.length - 1) return {
        //                 key: i,
        //                 path: path,
        //                 title: title,
        //                 active: (i === arr.length - 1),
        //                 link: null
        //             };
        //
        //             return {
        //                 key: i,
        //                 path: path,
        //                 title: title,
        //                 active: (i === arr.length - 1),
        //                 link: (i < arr.length - 1)
        //             }
        //         },
        //     );
        const paths = location.pathname.split('/')
            .map((p, i, arr) => {
                    const path = `${arr.slice(0, i + 1).join('/')}`;
                    const o = routesArray.find(o => o.path === path);
                    const title = o ? o.title : (isNumeric(arr[arr.length-1]) ? 'Edit' : arr[arr.length-1]);
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
        console.log(paths);
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
                            ? <Link color="inherit" key={key} to={path} >{title}</Link>
                            : <Typography>{title}</Typography>
                        }
                    </div>
                )
            ))
    };

    return (
        <Breadcrumbs aria-label="breadcrumb">
            {
                renderCrumbs()
            }
        </Breadcrumbs>
    );

};
