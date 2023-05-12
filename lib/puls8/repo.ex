defmodule Puls8.Repo do
  use Ecto.Repo,
    otp_app: :puls8,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Obtain exclusive transaction level advisory lock
  """
  def pg_advisory_xact_lock!(id) do
    __MODULE__.query!("select pg_advisory_xact_lock(hashtext($1))", [id])
  end
end
