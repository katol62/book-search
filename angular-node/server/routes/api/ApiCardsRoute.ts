import * as express from 'express';
import {IBaseResponse, ICompanyResponse, IPaging} from '../../interfaces/http-data';
import {IUser} from '../../models/User';
import {Card} from '../../models/Card';

export class ApiCardsRoute {
  public router: express.Router = express.Router();
  private cardsModel: Card = new Card();

  constructor() {
    this.config();
  }

  private config(): void {
    this.router.post('/', (req: express.Request, res: express.Response) => {
      const resp: IBaseResponse = {success: false, message: 'Method not allowed'};
      return res.status(405).json({ success: false, message: 'Method not allowed!!!' } as IBaseResponse);
    });
    this.router.put('/', (req: express.Request, res: express.Response) => {
      const resp: IBaseResponse = {success: false, message: 'Method not allowed'};
      return res.status(405).json({ success: false, message: 'Method not allowed!!!'} as IBaseResponse);
    });
    this.router.get('/', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      try {
        const result = await this.cardsModel.search(req.query, user);
        return res.status(200).json({
          success: true,
          message: 'Cards successfully recieved',
          user,
          data: result
        });
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });
    this.router.get('/:cardid', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      let filter: any = {id: Number(req.params.cardid)};
      if (user.role !== 'super') {
        filter = {...filter, owner: user.id};
      }
      try {
        const result = await this.cardsModel.find(filter);
        if (!result.length) {
          return res.status(404).json({ success: false, message: 'Not found'} as IBaseResponse);
        }
        return res.status(200).json({
          success: true,
          message: 'Card successfully recieved',
          user,
          data: result[0]
        } as IBaseResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }

    });

  }

}

export const cardsRoutes = new ApiCardsRoute();
