# Installing Docker Compose on Linux

These steps should get you there:

1. `sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

2. `sudo chmod +x /usr/local/bin/docker-compose`

3. `sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`

4. to verify: `docker-compose --version`

---

# 🚀 **What is Docker Compose?**

**Docker Compose** is a tool that lets you **define and run multi-container Docker applications** using a **single YAML file** called `docker-compose.yml`.

Instead of running multiple `docker run` commands manually, you describe everything (services, networks, volumes) in one file and start all containers with:

```sh
docker compose up
```

---

# 🧩 **Why Docker Compose Exists**

If your app has multiple components (example: frontend + backend + database), manually managing containers becomes painful.

Example without Compose:

- `docker run` for backend
- `docker run` for frontend
- `docker run` for database
- Link them using `--network`
- Mount volumes manually
- Pass environment variables manually
- Stop them one by one

Compose solves all of this by letting you define everything declaratively.

---

# 🏗️ **docker-compose.yml Structure**

A typical file looks like this:

```yaml
version: '3.9'

services:
  app:
    build: .
    ports:
      - '3000:3000'
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
    depends_on:
      - db

  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: gibbs
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: mydb
    volumes:
      - dbdata:/var/lib/postgresql/data

volumes:
  dbdata:
```

---

# 🔍 **Key Concepts**

### **1. Services**

Each container is called a **service**
(example: `app`, `db`, `redis`)

### **2. Networks**

Compose automatically creates an **isolated network** where all services can talk using DNS names:

```sh
app -> db
db -> app
```

### **3. Volumes**

Data that should persist across container restarts:

```yml
volumes:
  dbdata:
```

### **4. Environment Variables**

You can hardcode or use `.env` file:

```yml
environment:
  POSTGRES_PASSWORD: ${DB_PASS}
```

---

# ⚡ Common Docker Compose Commands

### **Start all containers**

```sh
docker compose up
```

### **Start in background**

```sh
docker compose up -d
```

### **Stop containers**

```sh
docker compose down
```

### **Rebuild + start**

```sh
docker compose up --build
```

### **View logs**

```sh
docker compose logs -f
```

### **Run a command inside a service**

```sh
docker compose exec app sh
```

---

# 🎯 When to Use Docker Compose

Use it when your app has:

✔ Backend + frontend
✔ Backend + DB
✔ Multiple microservices
✔ Local development setup

Compose is PERFECT for **full-stack dev setups** (which you often build).

---

# 🧠 Simple Mental Model

Think of Docker Compose like this:

> “A single configuration file that explains to Docker how to run your entire application stack.”

One command starts everything, keeps them connected, and ensures consistent local environments.

---
