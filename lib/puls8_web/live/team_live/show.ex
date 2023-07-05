defmodule Puls8Web.TeamLive.Show do
  use Puls8Web, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"team_slug" => _slug}, _session, socket) do
    team = socket.assigns.current_team

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:team, team)}
  end

  defp page_title(:show), do: "Show Team"
end
