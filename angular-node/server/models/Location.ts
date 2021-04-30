import connection from '../misc/db';
import * as util from 'util';

export interface IState {
  id: number;
  name: string;
}

export interface IFoc {
  id: number;
  name: string;
  state: number;
}

export interface IRegion {
  id: number;
  name: string;
  foc: number;
}

export class Location {

  private db = connection;
  private asyncQuery;
  constructor() {
    this.asyncQuery = util.promisify(this.db.query).bind(this.db);
  }

  // async
  public async countries(): Promise<any> {
    const query = 'SELECT * FROM loc_states';
    try {
      const result = await this.asyncQuery(query);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async fo(id: number): Promise<any> {
    const query = 'SELECT * FROM loc_fos WHERE state = ?';
    try {
      const result = await this.asyncQuery(query, [id]);
      return result;
    } catch (e) {
      throw (e);
    }
  }

  public async region(id: number): Promise<any> {
    const query = 'SELECT * FROM loc_regions WHERE foc = ?';
    try {
      const result = await this.asyncQuery(query, [id]);
      return result;
    } catch (e) {
      throw (e);
    }
  }


}
