defmodule Puls8Web.TeamLive.Index do
  use Puls8Web, :live_view

  alias Puls8.Accounts
  alias Puls8.Accounts.Team

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    teams = Accounts.list_teams_for(socket.assigns.current_user)

    socket =
      assign(socket,
        first_team: List.first(teams),
        team_count: length(teams)
      )

    {:ok, stream(socket, :teams, teams)}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :index, _params) do
    if socket.assigns.team_count == 1 do
      push_navigate(socket, to: ~p"/teams/#{socket.assigns.first_team}")
    else
      socket
      |> assign(:page_title, "Listing Teams")
      |> assign(:team, nil)
    end
  end

  @impl Phoenix.LiveView
  def handle_info({Puls8Web.TeamLive.FormComponent, {:saved, team}}, socket) do
    {:noreply, stream_insert(socket, :teams, team)}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    team = Accounts.get_team!(id)
    {:ok, _} = Accounts.delete_team(team)

    {:noreply, stream_delete(socket, :teams, team)}
  end
end
