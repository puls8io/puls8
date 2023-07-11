defmodule Puls8Web.IntegrationLive.Index do
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
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_changeset()}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"integration" => params}, socket) do
    team = socket.assigns.current_team

    case Monitoring.create_intergration(team, params) do
      {:ok, _integration} ->
        {:noreply,
         push_navigate(socket,
           to: ~p"/teams/#{team}/integrations"
         )}

      {:error, changeset} ->
        {:noreply, assign_changeset(socket, changeset)}
    end
  end

  defp assign_changeset(socket, changeset \\ Monitoring.change_integration()) do
    assign(socket, :changeset, changeset)
  end
end
