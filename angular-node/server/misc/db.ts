import * as mysql from 'mysql';
import config from './config';

export const connection = mysql.createPool({
  host: config.db.host,
  user: config.db.user,
  password: config.db.password,
  database: config.db.name,
  multipleStatements: true
});

export default connection;
