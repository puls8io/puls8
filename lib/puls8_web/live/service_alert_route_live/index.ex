defmodule Puls8Web.ServiceAlertRouteLive.Index do
  use Puls8Web, :live_view
  alias Puls8.Monitoring

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.link
      patch={~p"/teams/#{@team}/services/#{@service}/alert-routes/new"}
      data-role="new-alert-route-link"
    >
      <.button>New Route</.button>
    </.link>

    <div data-role="alert-routes">
      <.table id="alert-routes" rows={@streams.alert_routes}>
        <:col :let={{_id, alert_route}} label="Type"><%= alert_route.type %></:col>
        <:col :let={{_id, alert_route}} label="Labels">
          <div :for={label <- alert_route.labels} data-role="label">
            <%= "#{label.key}=#{label.value}" %>
          </div>
        </:col>
        <:action :let={{id, alert_route}}>
          <.link
            phx-click={JS.push("delete", value: %{id: alert_route.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </div>
    <.modal
      :if={@live_action in [:new]}
      id="alert-route-modal"
      show
      on_cancel={JS.patch(~p"/teams/#{@team}/services/#{@service}/alert-routes")}
    >
      <.live_component
        module={Puls8Web.ServiceAlertRouteLive.FormComponent}
        id={:new}
        title={@page_title}
        action={@live_action}
        alert_route={@alert_route}
        service={@service}
        patch={~p"/teams/#{@team}/services/#{@service}/alert-routes"}
      />
    </.modal>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    team = socket.assigns.current_team

    service = Monitoring.get_service_by_team!(params["service_scoped_id"], team)

    alert_routes = Monitoring.list_alert_routes()

    {:ok,
     socket
     |> assign(:team, team)
     |> assign(:service, service)
     |> stream(:alert_routes, alert_routes)}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Routes")
    |> assign(:alert_route, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Route")
    |> assign(:alert_route, %Monitoring.AlertRoute{})
  end

  @impl Phoenix.LiveView
  def handle_info({Puls8Web.ServiceAlertRouteLive.FormComponent, {:saved, alert_route}}, socket) do
    {:noreply, stream_insert(socket, :alert_routes, alert_route)}
  end
end
