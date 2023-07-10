defmodule Puls8Web.ServiceIntegrationLive.Index do
  use Puls8Web, :live_view
  alias Puls8.Monitoring

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.simple_form :let={f} for={@changeset} phx-submit="save" id="add-integration">
      <.input field={f[:name]} />
      <.input
        field={f[:type]}
        type="select"
        options={Ecto.Enum.values(Monitoring.Integration, :type)}
      />
    </.simple_form>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:team_slug, params["team_slug"])
     |> assign_changeset()
     |> assign_service(params)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"integration" => params}, socket) do
    service = socket.assigns.service

    case Monitoring.create_intergration(service, params) do
      {:ok, _integration} ->
        {:noreply,
         push_navigate(socket,
           to: ~p"/teams/#{socket.assigns.team_slug}/services/#{service}/integrations"
         )}

      {:error, changeset} ->
        {:noreply, assign_changeset(socket, changeset)}
    end
  end

  defp assign_service(socket, params) do
    team = socket.assigns.current_team
    assign(socket, :service, Monitoring.get_service_by_team!(params["service_scoped_id"], team))
  end

  defp assign_changeset(socket, changeset \\ Monitoring.change_integration()) do
    assign(socket, :changeset, changeset)
  end
end
