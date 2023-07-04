defmodule Puls8Web.TeamLive.Show do
  use Puls8Web, :live_view

  alias Puls8.Accounts

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"team_slug" => slug}, _session, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:team, Accounts.get_team_by_slug_for_user!(slug, socket.assigns.current_user))}
  end

  defp page_title(:show), do: "Show Team"
end
