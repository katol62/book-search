import connection from '../misc/db';
import * as util from 'util';
import {IPaging} from '../interfaces/http-data';
import {IUser} from './User';

export interface ICard {
  id: number;
  qr_code?: string;
  nfs_code?: string;
  m_code?: string;
  card_nb?: number;
  type?: 'adult' | 'child' | 'group' | 'other';
  status?: 'published' | 'sold' | 'activated' | 'overdue' | 'blocked';
  lifetime?: number;
  servicetime?: number;
  transh?: number;
  company_id?: number;
  pass?: number;
  owner?: number;
  test?: boolean;
  update_date?: Date;
  updated_by?: number;
  date_pass?: Date;
  date_pass_update?: Date;
  date_discount?: Date;
  pass_count?: number;
  pass_total?: number;
  prim?: string;
}

export class Card {
  private db = connection;
  private asyncQuery;
  constructor() {
    this.asyncQuery = util.promisify(this.db.query).bind(this.db);
  }

  public async search(requery: any, user: IUser): Promise<any> {
    const searchFields = ['id', 'card_nb', 'nfs_code', 'qr_code', 'm_code', 'prim'];
    const where = [];
    if (requery.filter) {
      searchFields.forEach(field => {
        where.push(field + ' LIKE "%' + requery.filter + '%"');
      });
    }
    const whereOwner = user.role !== 'super' ? 'owner=' + user.id : '';
    const whereStrAll = where.length ? where.join(' OR ') + ' AND ' + whereOwner : (whereOwner.length ? whereOwner : '');
    const whereStr = whereStrAll.length ? ' WHERE ' + whereStrAll : '';
    const pagingStr = requery.limit && requery.offset ? ' LIMIT ' + requery.limit + ' OFFSET ' + requery.offset : '' ;
    const sortStr = requery.sort && requery.direction ? (' ORDER BY ' + requery.sort + ' ' + requery.direction) : '';
    const queryAll = 'SELECT count(*) as total from cards' + whereStr;
    const query = 'SELECT * from cards' + whereStr + sortStr + pagingStr;
    try {
      const data = await this.asyncQuery(query);
      const total = await this.asyncQuery(queryAll);
      return {data, total: total[0].total};
    } catch (e) {
      throw e;
    }
  }

  public async find(filter: any): Promise<any> {
    const where = filter ? Object.keys(filter).map(key => (key + ' = ' + this.db.escape(filter[key]))) : [];
    const whereStr = where.length ? ' WHERE ' + where.join(' AND ') : '';
    const query = 'SELECT * from cards' + whereStr;
    try {
      const result = await this.asyncQuery(query);
      return result;
    } catch (e) {
      throw e;
    }
  }

}
