import connection from '../misc/db';
import * as util from 'util';
import {MysqlError} from 'mysql';

export interface IUser {
  id?: number;
  name?: string;
  last?: string;
  phone?: string;
  email?: string;
  password?: string;
  parent?: number;
  role?: 'super' | 'admin' | 'cashier' | 'customer' | 'partner';
  publisher?: '0' | '1';
}


export class User {
  private db = connection;
  private asyncQuery: any;

  constructor() {
    this.asyncQuery = util.promisify(this.db.query).bind(this.db);
  }

  public async find( filter: IUser): Promise<any> {
    const where = filter ? Object.keys(filter).map(key => (key + ' = ' + this.db.escape(filter[key]))) : [];
    const whereStr = where.length ? ' WHERE ' + where.join(' AND ') : '';
    const query = 'SELECT * from users' + whereStr;
    try {
      const result = await this.asyncQuery(query);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async create( user: IUser, parentId: number, cryptPwd: string): Promise<any> {
    const query = 'INSERT INTO users (name, last, phone, email, password, role, parent, publisher) SELECT ?, ?, ?, ?, ?, ?, ?, ? FROM DUAL WHERE NOT EXISTS (SELECT * FROM users WHERE email=?) LIMIT 1';
    const params = [
      user.name,
      user.last,
      user.phone,
      user.email,
      cryptPwd,
      user.role,
      parentId,
      user.publisher,
      user.email];
    try {
      const result = await this.asyncQuery(query, params);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async update( user: IUser): Promise<any> {
    console.log(user);
    const id = user.id;
    const name = user.name;
    const last = user.last;
    const phone = user.phone;
    const email = user.email;
    const password = user.password ? user.password : null;
    let query = 'UPDATE users SET name = ?, last = ?, email = ?, phone = ?, password = ? WHERE id = ?';
    let params = [name, last, email, phone, password, id];
    if (password == null) {
      query = 'UPDATE users SET name = ?, last = ?, email = ?, phone = ? WHERE id = ?';
      params = [name, last, email, phone, id];
    }
    try {
      const result = await this.asyncQuery(query, params);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async delete(id: number): Promise<any> {
    let query = 'DELETE с.*, t.*, r.* FROM company с LEFT JOIN terminal t ON t.company = с.id LEFT JOIN reference r ON r.company = с.id WHERE с.owner = ?';
    let params = [id];
    try {
      const result = await this.asyncQuery(query, params);
      query = 'DELETE FROM users where id = ? OR parent = ?';
      params = [id, id];
      const resultDelete = this.db.query(query, params);
      return resultDelete;
    } catch (e) {
      throw (e);
    }
  }

  public async reference(uid: number, cid: number, tid: number): Promise<any> {
    const query = 'INSERT INTO reference (user, company, terminal) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE terminal=?';
    const tidval = tid ? tid : null;
    try {
      const result = await this.db.query(query, [uid, cid, tidval, tidval]);
      return result;
    } catch (e) {
      throw (e);
    }
  }

}
