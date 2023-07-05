defmodule Puls8Web.ServiceLive.Index do
  use Puls8Web, :live_view
  alias Puls8.Monitoring

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.simple_form :let={f} for={@changeset} phx-submit="save" id="add-service">
      <.input field={f[:name]} />
    </.simple_form>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    team = socket.assigns.current_team

    changeset = Monitoring.change_service()

    {:ok,
     socket
     |> assign(:team, team)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"service" => params}, socket) do
    team = socket.assigns.team

    case Monitoring.create_service(socket.assigns.team, params) do
      {:ok, service} ->
        {:noreply, push_navigate(socket, to: ~p"/teams/#{team}/services/#{service}")}

      {:error, changeset} ->
        throw(changeset)
        {:noreply, socket}
    end
  end
end
