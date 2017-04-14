defmodule SocialPresence.Web.PageControllerTest do
  use SocialPresence.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 302) =~ "You are being <a href=\"/user/"
  end
end
