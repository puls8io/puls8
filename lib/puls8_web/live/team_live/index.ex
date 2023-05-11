defmodule Puls8Web.TeamLive.Index do
  use Puls8Web, :live_view

  alias Puls8.Accounts
  alias Puls8.Accounts.Team

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    teams = Accounts.list_teams()

    if length(teams) == 1 do
      team = List.first(teams)
      {:ok, push_navigate(socket, to: ~p"/teams/#{team}")}
    else
      {:ok, stream(socket, :teams, teams)}
    end
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
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
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
