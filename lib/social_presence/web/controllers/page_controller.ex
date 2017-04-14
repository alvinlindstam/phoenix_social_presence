defmodule SocialPresence.Web.PageController do
  use SocialPresence.Web, :controller

  def index(conn, _params) do
    redirect conn, to: page_path(conn, :show, :rand.uniform(100))
  end

  def show(conn, %{"id" => user_id}) do
    user = %{id: String.to_integer(user_id)}
    render conn, "index.html", %{token: Phoenix.Token.sign(conn, "user", user.id), user: user}
  end
end
