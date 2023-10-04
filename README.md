# ElixirGraphQL

This repo uses Elixir, Phoenix, Absinthe and Ecto to expose GraphQL APIs.

## Code Architecture

Under the `/lib` folder, there are two main folders: `elixir_graphql` and `elixir_graphql_web`. The first one contains the business logic of the application and the second one contains the web interface.

The project is divided into contexts, which are:

- `ElixirGraphQL.Accounts`: responsible for managing users and authentication
- `ElixirGraphQL.Content`: responsible for managing ElixirGraphQL's content
- `ElixirGraphQL.UserProgress`: responsible for managing users' progress and activity history

## Local Setup

### Elixir

To run the project, you'll need to have Elixir installed. An easy way to install it is by using [asdf](https://asdf-vm.com/#/core-manage-asdf-vm). The file `.tool-versions` contains the version of Elixir used in this project and to install it you can run:

```bash
asdf install
```

### Dependencies

To install the dependencies, run:

```bash
mix deps.get
```

### Database

Before creating the database, start the Postgres server. Having Docker installed, you can run:

```bash
docker-compose up -d
```

Then, create the database and seed it:

```bash
mix ecto.setup
```

### Phoenix

To start the Phoenix server, run:

```bash
mix phx.server
```

The server runs at `localhost:4000` and you can access the GraphQL playground at `localhost:4000/graphiql`.


### Tests

To run the tests, run:

```bash
mix test
```
