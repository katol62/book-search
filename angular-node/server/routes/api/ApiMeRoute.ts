import * as express from 'express';
import {IUser, User} from '../../models/User';
import {IBaseResponse} from '../../interfaces/http-data';

export class ApiMeRoute {
  public router: express.Router = express.Router();
  private userModel: User = new User();

  constructor() {
    this.config();
  }

  private config(): void {
    this.router.post('/', async (req: express.Request, res: express.Response) =>{
      const decoded: IUser = req.body.decoded;
      if (decoded && decoded.id) {
        const filter: IUser = {id: decoded.id};
        try {
          const me = await this.userModel.find(filter);
          const user: IUser = me[0];
          return res.status(200).json({
            success: true,
            message: 'User is retrieved',
            data: {user}
          } as IBaseResponse);
        } catch (e) {
          return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
        }
      } else {
        return res.status(401).json({success: false, message: 'Not Authorized'} as IBaseResponse);
      }

    });
  }
}

export const meRoutes = new ApiMeRoute();
