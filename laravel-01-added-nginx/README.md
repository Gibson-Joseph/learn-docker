# Creating a Laravel App via the Composer Utility Container.

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
