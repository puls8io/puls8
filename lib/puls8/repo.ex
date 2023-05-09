defmodule Puls8.Repo do
  use Ecto.Repo,
    otp_app: :puls8,
    adapter: Ecto.Adapters.Postgres
end
