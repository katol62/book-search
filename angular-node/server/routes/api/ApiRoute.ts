import * as express from 'express';
import * as unless from 'express-unless';
import {authRoutes} from './ApiAuthRoute';
import {checkJwt, hasRole} from '../../middleware/AllMiddlewares';
import {companiesRoutes} from './ApiCompaniesRoute';
import {adminsRoutes} from './ApiAdminsRoute';
import {locationRoutes} from './ApiLocationRoute';
import {terminalRoutes} from './ApiTerminalsRoute';
import {cardsRoutes} from './ApiCardsRoute';
import {meRoutes} from './ApiMeRoute';

export class ApiRoute {

  public app: express.Application;
  public router: express.Router = express.Router();

  constructor() {
    this.app = express();
    this.config();
  }

  private config(): void {
    this.router.get('/', (req: express.Request, res: express.Response) => {
        return res.status(405).json({ success: false, message: 'Not allowed!' });
      }
    );
    this.router.post('/', (req: express.Request, res: express.Response) => {
        return res.status(405).json({ success: false, message: 'Not allowed' });
      }
    );
    this.router.put('/', (req: express.Request, res: express.Response) => {
        return res.status(405).json({ success: false, message: 'Not allowed' });
      }
    );
    this.router.use('/auth', authRoutes.router);
    this.router.use('/companies', checkJwt, hasRole(['super', 'admin']), companiesRoutes.router);
    this.router.use('/admins', checkJwt, hasRole(['super']), adminsRoutes.router);
    this.router.use('/location', checkJwt, locationRoutes.router);
    this.router.use('/terminals', checkJwt, hasRole(['super', 'admin']), terminalRoutes.router);
    this.router.use('/cards', checkJwt, hasRole(['super', 'admin']), cardsRoutes.router);
    this.router.use('/me', checkJwt, meRoutes.router);
  }
}

export const apiRoutes = new ApiRoute();
