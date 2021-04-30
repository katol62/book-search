import connection from '../misc/db';
import * as util from 'util';
import {MysqlError} from 'mysql';

export interface ITerminal {
  id?: number;
  name?: string;
  company?: number;
  commission?: string;
  place?: string;
}

export class Terminal {
  private db = connection;
  private asyncQuery;

  constructor() {
    this.asyncQuery = util.promisify(this.db.query).bind(this.db);
  }

  public findOld(filter: ITerminal, next: CallableFunction) {
    const where = filter ? Object.keys(filter).map(key => (key + ' = ' + this.db.escape(filter[key]))) : [];
    const whereStr = where.length ? ' WHERE ' + where.join(' AND ') : '';
    const query = 'SELECT * from terminal' + whereStr;
    this.db.query(query, ( err: Error, rows: any ) => {
      if (err) {
        return next(err);
      }
      next(null, rows);
    });
  }

  // async

  public async find(filter: ITerminal): Promise<any> {
    const where = filter ? Object.keys(filter).map(key => (key + ' = ' + this.db.escape(filter[key]))) : [];
    const whereStr = where.length ? ' WHERE ' + where.join(' AND ') : '';
    const query = 'SELECT * from terminal' + whereStr;
    try {
      const result = await this.asyncQuery(query);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async create(body: ITerminal): Promise<any> {
    let query = 'INSERT INTO terminal (name, company, commission, place) SELECT ?, ?, ?, ? FROM DUAL WHERE NOT EXISTS (SELECT * FROM terminal WHERE name = ?) LIMIT 1';
    let params = [body.name, body.company, body.commission, body.place, body.name];
    if (!body.place || body.place === '') {
      query = 'INSERT INTO terminal (name, company, commission) SELECT ?, ?, ? FROM DUAL WHERE NOT EXISTS (SELECT * FROM terminal WHERE name=?) LIMIT 1';
      params = [body.name, body.company, body.commission, body.name];
    }
    try {
      const result = await this.asyncQuery(query, params);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async update(body: ITerminal): Promise<any> {
    let query = 'UPDATE terminal SET name = ?, company = ?, commission = ?, place = ? WHERE id = ?';
    let params = [body.name, body.company, body.commission, body.place, body.id];
    if (body.place === '') {
      query = 'UPDATE terminal SET name = ?, company = ?, commission = ? WHERE id = ?';
      params = [body.name, body.company, body.commission, body.id];
    }
    try {
      const result = await this.asyncQuery(query, params);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async delete(id: number): Promise<any> {
    const query = 'DELETE t.*, r.* FROM terminal t LEFT JOIN reference r ON r.terminal = t.id WHERE t.id = ?';
    try {
      const deleteResult = await this.asyncQuery(query, [id]);
      return deleteResult;
    } catch (e) {
      throw(e);
    }
  }


}
