import * as dotenv from 'dotenv';

const ENV = 'dev';
dotenv.config();

export const config = {
  env: ENV,
  host: process.env.SERVER_HOST,
  port: process.env.SERVER_PORT,
  db: {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    name: process.env.DB_NAME
  },
  secret: process.env.JWT_SECRET,
  tokenExpireIn: 86400
};

export default config;
