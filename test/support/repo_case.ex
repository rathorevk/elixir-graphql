defmodule ElixirGraphQL.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ElixirGraphQL.Repo

      import Ecto
      import Ecto.Query
      import Ecto.Changeset
      import ElixirGraphQL.RepoCase
    end
  end

  setup tags do
    setup_sandbox(tags)

    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(ElixirGraphQL.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

  ## Examples

      iex> Accounts.create_user(%{password: "short"})
      {:error, changeset}

      iex> errors_on(changeset)
      %{password: ["password is too short"]}
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
