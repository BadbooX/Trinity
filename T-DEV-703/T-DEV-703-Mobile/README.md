# Project README

## Database

The database is a PostgreSQL database and is managed using Docker. The database is used to store the data for the project. The docker-compose file in this directory is used to start the database and can be found at the root of the project.

To know more about the database, please refer to the [database README](./database/README.md).

## API Instructions

This project uses Node.js and Fistify.js to create a RESTful API. The API is used to interact with the database and provide data to the frontend. The API is used to create, read, update, and delete data from the database.

To execute the API, you will need to have Node.js installed on your machine. You can find the installation instructions for Node.js [here](https://nodejs.org/en/download/).

### API environement variable 
api need this environement variables :
- `DATABASE_URL` : postgresql url of db  
- `JWT_SECRET`   : sign of jwt

## Prisma Instructions

This project uses Prisma to manage the database. Prisma is an ORM that allows you to interact with the database using a type-safe API. Prisma generates the database schema and provides a type-safe API to interact with the database.

An example schema & migration is already provided in the `./api/prisma` directory. A migration is a way to update the database schema.
To execute the migration, ensure your database container is up, create a `.env` file in the `./api` directory with the following content:

```bash
DATABASE_URL="postgresql://YOUR_USERNAME:YOUR_PASSWORD@localhost:5432/YOUR_DATABASE_NAME"
```

Then run the following command **at the root** of the project:

```bash
cd api
npx prisma migrate dev
```

To know how to launch the database container, please refer to the [database README](./database/README.md).
To know how to interact with the database using Prisma, please refer to the [Prisma documentation](https://www.prisma.io/docs/).

## Requirement

- node lts : v22.12.0
- postgres

### Dev requirement

- docker

how to dev

first time

```bash
cd api
npm i
npm run dev
```

other time

```bash
cd api
npm run dev
```

start db
