import * as express from 'express';
import * as path from 'path';
import * as logger from 'morgan';
import * as helmet from 'helmet';
import * as cors from 'cors';
import * as bodyParser from 'body-parser';
import * as methodOverride from 'method-override';
import config from './misc/config';
import { apiRoutes } from './routes/api/ApiRoute';

class App {
  public app: express.Application;
  public router: express.Router = express.Router();

  constructor() {
    this.app = express();
    this.config();
  }

  private config(): void {
    // support application/json
    this.app.use(bodyParser.json());
    // support application/x-www-form-urlencoded post data
    this.app.use(bodyParser.urlencoded({ extended: false }));
    this.app.use(bodyParser.json());
    this.app.use(methodOverride());
    this.app.use(cors());
    this.app.use(helmet());
    if (config.env === 'dev') {
      // this.app.use(logger('dev'));
    }
    this.configureRoutes();
  }
  private configureRoutes(): void {
    this.router.get('/', (req: express.Request, res: express.Response) => {
        return res.status(405).json({ success: false, message: 'Not allowed' });
      }
    );
    this.router.post('/', (req: express.Request, res: express.Response) => {
        return res.status(405).json({ success: false, message: 'Not allowed' });
      }
    );
    this.configStaticRoutes();
    this.app.use('/api', apiRoutes.router);
  }
  private configStaticRoutes() {
    const distDir = '../dist/client';
    this.app.use(express.static(path.join(__dirname, distDir)));
    this.app.use(/^((?!(api)).)*/, (req, res) => {
      res.sendFile(path.join(__dirname, distDir + '/index.html'));
    });
  }
}

export default new App().app;
