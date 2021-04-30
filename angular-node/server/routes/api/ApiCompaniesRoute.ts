import * as express from 'express';
import {checkJwt} from '../../middleware/AllMiddlewares';
import {IAdminResponse, IBaseResponse, ICompanyResponse, ICompanyUpdateResponse, ITerminalResponse} from '../../interfaces/http-data';
import {Company, ICompany, ICompanyExtended, ICompanyFilter} from '../../models/Company';
import {IUser, User} from '../../models/User';
import {ITerminal, Terminal} from '../../models/Terminal';
import {async} from 'rxjs/internal/scheduler/async';

export class ApiCompaniesRoute {

  public router: express.Router = express.Router();
  private companyModel: Company = new Company();
  private terminalModel: Terminal = new Terminal();
  private userModel: User = new User();

  constructor() {
    this.config();
  }

  private config(): void {
    this.router.post('/', (req: express.Request, res: express.Response) => {
      const resp: IBaseResponse = {success: false, message: 'Method not allowed'};
      return res.status(405).json({ success: false, message: 'Method not allowed!!!' });
    });

    this.router.get('/', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      let filter: any = {role: user.role, id: user.id};
      const ownerid = req.query && req.query.owner ? Number(req.query.owner) : null;
      if (ownerid) {
        filter = {...filter, owner: ownerid};
      }
      if (user) {
        try {
          const rescompanies = await this.companyModel.all(filter);
          const companies = [];
          const length = rescompanies.length;
          rescompanies.forEach(async (row, index) => {
            const resRow: ICompany = row;
            const terminalFilter: ITerminal = {company: resRow.id};
            const terminals = await this.terminalModel.find(terminalFilter);
            resRow.terminals = terminals;
            companies.push(resRow);
            if (companies.length === length) {
              return res.status(200).json({
                success: true,
                message: 'Company list successfully recieved',
                user,
                data: companies
              });
            }
          });
        } catch (e) {
          return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
        }
      } else {
        return res.status(404).json({success: false, message: 'Not Found'} as IBaseResponse);
      }
    });

    this.router.get('/:cid', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const filter: ICompanyExtended = {id: Number(req.params.cid)};
      try {
        const companies = await this.companyModel.findExtended(filter);
        if (!companies.length) {
          return res.status(404).json({ success: false, message: 'Not found'} as IBaseResponse);
        }
        const company: ICompany = companies[0];
        return res.status(200).json({
          success: true,
          message: 'Company successfully recieved',
          user,
          data: company
        } as ICompanyResponse);

      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.post('/create',  async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const company: ICompany = req.body.company;
      try {
        const result = await this.companyModel.create(company);
        if (!result.affectedRows) {
          return res.status(204).json({ success: false, message: 'No Content'});
        }
        const id = result.insertId;
        return res.status(200).json({
          success: true,
          message: 'Company successfully created',
          id
        } as ICompanyUpdateResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.put('/:cid', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const company: ICompany = req.body.company;
      try {
        const result = await this.companyModel.update(company);
        if (!result.affectedRows) {
          return res.status(204).json({ success: false, message: 'No Content'});
        }
        return res.status(200).json({
          success: true,
          message: 'Company successfully updated',
          id: company.id,
        } as ICompanyUpdateResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.delete('/:cid', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const id: number = Number(req.params.cid);
      try {
        const result = await this.companyModel.delete(id);
        if (!result.affectedRows) {
          return res.status(204).json({ success: false, message: 'No content'});
        }
        return res.status(200).json({ success: true, message: 'Company deleted'});

      } catch (e) {
        return res.status(500).json({ success: false, message: e.message});
      }
    });

  }
}

export const companiesRoutes = new ApiCompaniesRoute();
