defmodule Puls8Web.ServiceLive.Show do
  use Puls8Web, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    TODO
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # TODO: load the right team
    {:ok, socket}
  end
end
