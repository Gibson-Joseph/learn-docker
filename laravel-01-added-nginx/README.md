# Creating a Laravel App via the Composer Utility Container.

## docker-compose.yaml

```yaml
services:
  server:
    image: nginx:stable-alpine
    ports:
      - '8000:80'
    volumes:
      - ./src:/var/www/html
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - php
      - mysql

  php:
    # PHP interpreter container
    build:
      context: ./dockerfiles
      dockerfile: php.dockerfile
    volumes:
      - ./src:/var/www/html:delegated

  mysql:
    image: mysql:5.7
    env_file:
      - ./env/mysql.env

  composer:
    build:
      context: ./dockerfiles
      dockerfile: composer.dockerfile
    volumes:
      - ./src:/var/www/html
  artisan:
    build:
      context: ./dockerfiles
      dockerfile: php.dockerfile
    volumes:
      - ./src:/var/www/html
    entrypoint: ['php', '/var/www/html/artisan']
  npm:
    image: node:14
    working_dir: /var/www/html
    entrypoint: ['npm']
    volumes:
      - ./src:/var/www/html
```

## composer.dockerfile

```dockerfile
FROM composer:2.5.7

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]
```

## php.dockerfile

```dockerfile
FROM php:8.2.4-fpm-alpine

WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql
```

---

```sh
docker compose run --rm composer create-project --prefer-dist laravel/laravel .
```

---

# If you face permission errors when adding a bind mount

Do this now in your project:

```sh
sudo chown -R $USER:$USER .
```

After this you can edti your project files

---

# To run our PHP application

```sh
docker compose up -d --build server php mysql
(or)
docker compose up -d --build server
```

# Again If you face any permission errors after `compose up`

Do this now in your project folder

```sh
sudo chmod -R o+w src/storage src/bootstrap/cache
``
```

# To run the migration

```sh
docker compose run --rm artisan migrate
```

## NOTE: After the migration application will works

---

# If the application is not working you have to run the migration

```yml
artisan:
  build:
    context: .
    dockerfile: dockerfiles/php.dockerfile
  entrypoint: ['php', '/var/www/html/artisan']
```

```sh
docker compose run --rm artisan migrate
```
