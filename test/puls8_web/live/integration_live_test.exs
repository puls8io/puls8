defmodule Puls8Web.IntegrationLiveTest do
  use Puls8Web.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "Index" do
    setup [:register_and_log_in_user]

    test "redirects to  integration page after it's created", %{
      conn: conn,
      team: team
    } do
      {:ok, view, _html} = live(conn, ~p"/teams/#{team}/integrations/new")

      view
      |> form("#add-integration", %{integration: %{name: "My Int", type: :grafana}})
      |> render_submit()

      {path, _flash} = assert_redirect(view)
      assert path == ~p"/teams/#{team}/integrations"
    end
  end
end
