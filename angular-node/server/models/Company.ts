import connection from '../misc/db';
import * as util from 'util';
import {ITerminal} from './Terminal';
import {IUser} from './User';
import {MysqlError} from 'mysql';

export interface ICompany {
  id: number;
  name?: string;
  fullname?: string;
  inn?: string;
  kpp?: string;
  ogrn?: string;
  juradress?: string;
  adress?: string;
  bankdetails?: string;
  nds?: string;
  dogovor?: string;
  dogovordate?: Date;
  country?: number;
  foc?: number;
  region?: number;
  owner?: number;
  terminals?: ITerminal[];
}

export interface ICompanyExtended extends ICompany{
  countryname?: string;
  focname?: string;
  regionname?: string;
}

export interface ICompanyFilter extends ICompany{
  cowner?: IUser;
}

export class Company {
  private db = connection;
  private asyncQuery;
  constructor() {
    this.asyncQuery = util.promisify(this.db.query).bind(this.db);
  }

  public async all(filter: any): Promise<any> {
    let query = 'select distinct c.* from company c left join reference r on r.company = c.id';
    let params = [];
    if (filter.owner) {
      query += ' WHERE r.user = ?';
      params = [filter.owner];
    } else {
      if (filter.role && (filter.role === 'admin' || filter.role === 'cashier')) {
        query += ' WHERE r.user = ?';
        params = [filter.id];
      }
    }
    query += ' order by c.id';
    try {
      const result = await this.asyncQuery(query, params);
      return result;
    } catch (e) {
      throw e;
    }
  }

  public async find(filter: ICompany): Promise<any> {
    const where = filter ? Object.keys(filter).map(key => (key + ' = ' + this.db.escape(filter[key]))) : [];
    const whereStr = where.length ? ' WHERE ' + where.join(' AND ') : '';
    const query = 'SELECT * from company' + whereStr;
    try {
      const result = await this.asyncQuery(query);
      return result;
    } catch (e) {
      throw e;
    }
  }

  public async create(body: ICompany): Promise<any> {
    const params = [
      body.name,
      body.fullname,
      body.inn,
      body.kpp,
      body.ogrn,
      body.juradress,
      body.adress,
      body.bankdetails,
      body.nds,
      body.dogovor,
      body.dogovordate,
      body.owner,
      body.country,
      body.foc,
      body.region,
      body.name,
      body.region];
    const query = 'INSERT INTO company (name, fullname, inn, kpp, ogrn, juradress, adress, bankdetails, nds, dogovor, dogovordate, owner, country, foc, region) SELECT ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? FROM DUAL WHERE NOT EXISTS (SELECT * FROM company WHERE name=? AND region = ?) LIMIT 1';
    try {
      const result = await this.asyncQuery(query, params);
      return result;
    } catch (e) {
      throw e;
    }
  }

  public async update(body: ICompany): Promise<any> {
    const query = 'UPDATE company SET name=?, fullname=?, inn=?, kpp=?, ogrn=?, juradress=?, adress=?, bankdetails=?, nds=?, dogovor=?, dogovordate=?, country = ?, foc = ?, region = ?, owner = ? WHERE id = ?';
    const params = [body.name, body.fullname, body.inn, body.kpp, body.ogrn, body.juradress, body.adress, body.bankdetails, body.nds, body.dogovor, body.dogovordate, body.country, body.foc, body.region, body.owner, body.id];
    try {
      const result = await this.asyncQuery(query, params);
      return result;
    } catch (e) {
      throw e;
    }
  }

  public async delete(id: number): Promise<any> {
    const query = 'DELETE с.*, t.*, r.* FROM company с LEFT JOIN terminal t ON t.company = с.id LEFT JOIN reference r ON r.company = с.id WHERE с.id = ?';
    try {
      const result = await this.asyncQuery(query, [id]);
      return result;
    } catch (e) {
      throw e;
    }
  }

  public async findExtended(filter: ICompanyFilter): Promise<any> {
    let query = 'select c.*, state.name as countryname, foc.name as focname, region.name as regionname from company c join loc_states state on c.country = state.id join loc_fos foc on c.foc = foc.id join loc_regions region on c.region = region.id';
    const where = Object.keys(filter).map(key => (key !== 'cowner' ? ('c.' + key + ' = ' + this.db.escape(filter[key])) : ''));
    if (filter.cowner && filter.cowner.role === 'admin') {
      where.push('c.owner=' + filter.cowner.id);
    }
    const whereStr = where.length ? ' WHERE ' + where.join(' AND ') : '';
    query += whereStr;
    try {
      const result = await this.asyncQuery(query);
      return result;
    } catch (e) {
      throw e;
    }
  }



}
