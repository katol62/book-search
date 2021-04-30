import * as express from 'express';
import {IUser, User} from '../../models/User';
import {IAdminResponse, IAdminsResponse, IAdminUpdateResponse, IBaseResponse} from '../../interfaces/http-data';
import * as bcrypt from 'bcrypt';

export class ApiAdminsRoute {
  public router: express.Router = express.Router();
  private userModel: User = new User();

  constructor() {
    this.config();
  }

  private config(): void {

    this.router.get('/', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      if (user) {
        const filter: IUser = {parent: user.id, role: 'admin'};
        try {
          const admins = await this.userModel.find(filter);
          return res.status(200).json({
            success: true,
            message: 'Admins list successfully recieved',
            user,
            data: admins
          } as IAdminsResponse);
        } catch (e) {
          return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
        }
      } else {
        return res.status(401).json({success: false, message: 'Not Authorized'} as IBaseResponse);
      }
    });

    this.router.get('/:id',  async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const filter: IUser = {id: Number(req.params.id)};
      try {
        const result = await this.userModel.find(filter);
        if (!result.length) {
          return res.status(404).json({ success: false, message: 'Not found'} as IBaseResponse);
        }
        const rAadmin = result[0];
        const admin: IUser = {id: rAadmin.id, name: rAadmin.name, last: rAadmin.last,
          phone: rAadmin.phone, email: rAadmin.email, publisher: rAadmin.publisher};
        return res.status(200).json({
          success: true,
          message: 'Admin successfully recieved',
          user,
          data: admin
        } as IAdminResponse);

      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.post('/create', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const admin: IUser = req.body.admin;
      try {
        const bcryptedPassword = await bcrypt.hash(admin.password, 5);
        admin.role = 'admin';
        const result = await this.userModel.create(admin, user.id, bcryptedPassword);
        if (result.affectedRows === 0) {
          return res.status(204).json({ success: false, message: 'No Content'});
        }
        const updateResponse: IAdminUpdateResponse = {
          success: true,
          message: 'Admin created',
          data: admin,
          id: admin.id};
        return res.status(200).json(updateResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.put('/:id', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const admin: IUser = req.body.admin;
      try {
        if (admin.password) {
          const bcryptedPassword = await bcrypt.hash(admin.password, 5);
          admin.password = bcryptedPassword;
        }
        const result = await this.userModel.update(admin);
        if (result.affectedRows === 0) {
          return res.status(204).json({ success: false, message: 'No Content'} as IBaseResponse);
        }
        const updateResponse: IAdminUpdateResponse = {
          success: true,
          message: 'Admin updated',
          data: admin,
          id: admin.id};
        return res.status(200).json(updateResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.delete('/:id', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const id: number = Number(req.params.id);
      try {
        const result = await this.userModel.delete(id);
        if (!result.affectedRows) {
          return res.status(204).json({ success: false, message: 'No content'} as IBaseResponse);
        }
        return res.status(200).json({ success: true, message: 'Admin deleted'} as IBaseResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });
  }
}

export const adminsRoutes = new ApiAdminsRoute();
