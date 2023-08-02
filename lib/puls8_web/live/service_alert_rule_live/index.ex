defmodule Puls8Web.ServiceAlertRuleLive.Index do
  use Puls8Web, :live_view
  alias Puls8.Monitoring

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div :for={rule <- @rules} data-role="alert-rule">
      type: <%= rule.type %> labels:
      <span :for={label <- rule.labels} data-role="label"><%= "#{label.key}=#{label.value}" %></span>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # team = socket.assigns.current_team

    rules = Monitoring.list_alert_routes()

    {:ok,
     socket
     # |> assign(:team, team)
     |> assign(:rules, rules)}
  end
end
