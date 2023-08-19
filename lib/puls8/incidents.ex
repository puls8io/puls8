defmodule Puls8.Incidents do
  @moduledoc """
  The Incident context.
  """

  import Ecto.Query, warn: false
  alias Puls8.Repo

  alias Puls8.Incidents.Alert

  @doc """
  Creates a alert.

  ## Examples

      iex> create_alert(team, %{field: value})
      {:ok, %Alert{}}

      iex> create_alert(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alert(team, attrs \\ %{}) do
    %Alert{}
    |> Alert.changeset(attrs)
    |> Alert.put_team(team)
    |> Repo.insert()
  end

  @doc """
  Updates a alert.

  ## Examples

      iex> update_alert(alert, %{field: new_value})
      {:ok, %Alert{}}

      iex> update_alert(alert, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alert(%Alert{} = alert, attrs) do
    alert
    |> Alert.changeset(attrs)
    |> Repo.update()
  end

  def get_alert!(id) do
    Repo.get!(Alert, id)
  end
end
