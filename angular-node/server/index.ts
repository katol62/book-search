import config from './misc/config';
import app from './app';

app.listen(config.port, err => {
  if (err) {
    return console.error(err);
  }
  return console.log(`server is listening on ${config.port}`);
});
