defmodule SocialPresence.Web.PageController do
  use SocialPresence.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
