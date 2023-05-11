defmodule Puls8Web.TeamLive.FormComponent do
  use Puls8Web, :live_component

  alias Puls8.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage team records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="team-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Team</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{team: team} = assigns, socket) do
    changeset = Accounts.change_team(team)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"team" => team_params}, socket) do
    team_params =
      if socket.assigns.action == :new and socket.assigns.name != team_params["name"] do
        Map.put(team_params, "slug", Slug.slugify(team_params["name"]))
      else
        team_params
      end

    changeset =
      socket.assigns.team
      |> Accounts.change_team(team_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"team" => team_params}, socket) do
    save_team(socket, socket.assigns.action, team_params)
  end

  defp save_team(socket, :edit, team_params) do
    case Accounts.update_team(socket.assigns.team, team_params) do
      {:ok, team} ->
        notify_parent({:saved, team})

        {:noreply,
         socket
         |> put_flash(:info, "Team updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_team(socket, :new, team_params) do
    case Accounts.create_team(team_params) do
      {:ok, team} ->
        notify_parent({:saved, team})

        {:noreply,
         socket
         |> put_flash(:info, "Team created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
    |> assign(:name, Ecto.Changeset.get_change(changeset, :name))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
