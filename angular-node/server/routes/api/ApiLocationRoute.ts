import * as express from 'express';
import {IBaseResponse, ILocationResponse} from '../../interfaces/http-data';
import {Location} from '../../models/Location';

export class ApiLocationRoute {
  public router: express.Router = express.Router();
  private locationModel: Location = new Location();

  constructor() {
    this.config();
  }

  private config(): void {
    this.router.post('/', (req: express.Request, res: express.Response) => {
      const resp: IBaseResponse = {success: false, message: 'Method not allowed'};
      return res.status(405).json({ success: false, message: 'Method not allowed!!!' });
    });
    this.router.get('/', (req: express.Request, res: express.Response) => {
      const resp: IBaseResponse = {success: false, message: 'Method not allowed'};
      return res.status(405).json({ success: false, message: 'Method not allowed!!!' });
    });

    this.router.get('/countries', async (req: express.Request, res: express.Response) => {
      try {
        const countries = await this.locationModel.countries();
        const result: ILocationResponse = {
          type: 'country',
          success: true,
          items: countries
        };
        return res.status(200).json(result);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.get('/foc/:id',  async (req: express.Request, res: express.Response) => {
      const id = Number(req.params.id);
      try {
        const foc = await this.locationModel.fo(id);
        const result: ILocationResponse = {
          type: 'foc',
          success: true,
          items: foc
        };
        return res.status(200).json(result);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.get('/region/:id',  async (req: express.Request, res: express.Response) => {
      const id = Number(req.params.id);
      try {
        const regions = await this.locationModel.region(id);
        const result: ILocationResponse = {
          type: 'region',
          success: true,
          items: regions
        };
        return res.status(200).json(result);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });
 }
}

export const locationRoutes = new ApiLocationRoute();
