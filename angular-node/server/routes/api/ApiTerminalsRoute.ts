import * as express from 'express';
import {ITerminal, Terminal} from '../../models/Terminal';
import {IUser, User} from '../../models/User';
import {IBaseResponse, ITerminalResponse, ITerminalUpdateResponse} from '../../interfaces/http-data';
import {MysqlError} from 'mysql';

export class ApiTerminalsRoute {
  public router: express.Router = express.Router();
  private terminalModel: Terminal = new Terminal();
  private userModel: User = new User();

  constructor() {
    this.config();
  }

  private config(): void {

    this.router.get('/:tid', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const tid: number = Number(req.params.tid);
      const terminalFilter: ITerminal = {id: tid};
      try {
        const terminals = await this.terminalModel.find(terminalFilter);
        if (!terminals.length) {
          return res.status(404).json({ success: false, message: 'Not found'} as IBaseResponse);
        }
        const terminal: ITerminal = terminals[0];
        return res.status(200).json({
          success: true,
          message: 'Terminal successfully retrieved',
          data: terminal
        } as ITerminalResponse);

      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.post('/create', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const tid: number = Number(req.params.tid);
      let terminal = req.body.terminal;
      try {
        const result = await this.terminalModel.create(terminal);
        if (!result.affectedRows) {
          return res.status(204).json({ success: false, message: 'No Content'} as IBaseResponse);
        }
        const update = await this.userModel.reference(user.id, terminal.company, result.insertId);
        terminal = {
          ...terminal,
          id: result.insertId
        };
        return res.status(200).json({
          success: true,
          message: 'Terminal created',
          data: terminal
        } as ITerminalUpdateResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.put('/:tid', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const tid: number = Number(req.params.tid);
      let terminal = req.body.terminal;
      try {
        const result = await this.terminalModel.update(terminal);
        if (!result.affectedRows) {
          return res.status(204).json({ success: false, message: 'No Content'} as IBaseResponse);
        }
        const update = await this.userModel.reference(user.id, terminal.company, result.insertId);
        terminal = {
          ...terminal,
          id: result.insertId
        };
        return res.status(200).json({
          success: true,
          message: 'Terminal updated',
          data: terminal
        } as ITerminalUpdateResponse);
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });

    this.router.delete('/:tid', async (req: express.Request, res: express.Response) => {
      const user: IUser = req.body.decoded;
      const tid: number = Number(req.params.tid);
      try {
        const deleteResult = await this.terminalModel.delete(tid);
        if (!deleteResult.affectedRows) {
          return res.status(204).json({ success: false, message: 'No content'});
        }
        return res.status(200).json({ success: true, message: 'Terminal deleted'});
      } catch (e) {
        return res.status(500).json({ success: false, message: e.message} as IBaseResponse);
      }
    });
  }
}

export const terminalRoutes = new ApiTerminalsRoute();
