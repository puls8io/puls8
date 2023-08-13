defmodule Puls8Web.ServiceAlertRouteLive.FormComponent do
  use Puls8Web, :live_component
  alias Puls8.Monitoring

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Create new alert rules.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        data-role="alert-route-form"
      >
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          options={Ecto.Enum.values(Monitoring.AlertRoute, :type)}
        />
        <.inputs_for :let={ef} field={@form[:labels]}>
          <input type="hidden" name="alert_route[labels_sort][]" value={ef.index} />
          <.input type="text" field={ef[:key]} placeholder="key" label="Key" />
          <.input type="text" field={ef[:value]} placeholder="value" label="Value" />

          <label>
            <input type="checkbox" name="alert_route[labels_drop][]" value={ef.index} class="hidden" />
            <.icon name="hero-x-mark" class="w-6 h-6 relative top-2" />
          </label>
        </.inputs_for>

        <label class="block cursor-pointer">
          <input type="checkbox" name="alert_route[labels_sort][]" class="hidden" /> add more
        </label>

        <input type="hidden" name="alert_route[labels_drop][]" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Alert Rule</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(%{alert_route: alert_route} = assigns, socket) do
    changeset = Monitoring.change_alert_route(alert_route, %{labels: [%{key: "", value: ""}]})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"alert_route" => params}, socket) do
    changeset =
      socket.assigns.alert_route
      |> Monitoring.change_alert_route(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("save", %{"alert_route" => params}, socket) do
    case Monitoring.create_alert_route(socket.assigns.service, params) do
      {:ok, alert_route} ->
        notify_parent({:saved, alert_route})

        {:noreply,
         socket
         |> put_flash(:info, "Alert route created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
