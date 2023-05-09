defmodule Puls8Web.ErrorJSONTest do
  use Puls8Web.ConnCase, async: true

  test "renders 404" do
    assert Puls8Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Puls8Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
