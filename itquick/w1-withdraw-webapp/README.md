# W1WithdrawWebapp

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 1.6.8.

## Docker build

If we just build it normally, it will use the production configuration (production) and environment.

* Build your image using the production configuration / environment (the default), e.g.:

```
docker build -t w1-withdraw-webapp:prod .
```

But we can build an image for each environment we have, by just passing the configuration name as an argument to the build process. The same as we would pass it to `ng build --configuration`. We just have to use Docker's `--build-arg` parameter.

* Build your image passing an empty string as the `configuration` build arg, so that Angular CLI doesn't use a configuration and runs with the default Angular development environment, e.g.:

```
docker build -t w1-withdraw-webapp:dev --build-arg configuration="" .
```

* Building for `uat` environment:

```
docker build -t w1-withdraw-webapp:uat --build-arg configuration="uat" .
```

* Building for `development` environment:

```
docker build -t w1-withdraw-webapp:development --build-arg configuration="development" .
```

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `-prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).
