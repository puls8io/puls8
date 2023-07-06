defmodule Puls8Web.ServiceLive.Show do
  use Puls8Web, :live_view
  alias Puls8.Monitoring

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div data-role="service">
      <%= @service.name %>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    service =
      Monitoring.get_service_by_team!(params["service_scoped_id"], socket.assigns.current_team)

    {:ok, assign(socket, :service, service)}
  end
end
