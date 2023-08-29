defmodule Puls8.Monitoring.AlertRoute.Query do
  import Ecto.Query, warn: false
  alias Puls8.Monitoring.AlertRoute

  def base, do: AlertRoute

  def by_labels(query \\ base(), labels) do
    q =
      query
      |> join(
        :inner_lateral,
        [alert_routes],
        fragment(
          "SELECT * FROM jsonb_to_recordset(to_jsonb(?)) as label(key text, value text)",
          alert_routes.labels
        ),
        as: :label,
        on: true
      )
      |> distinct(true)

    Enum.reduce(labels, q, fn %{"key" => key, "value" => value}, acc ->
      acc
      |> or_where(as(:label).key == ^key and as(:label).value == ^value)
    end)
  end
end
