defmodule DiscussWeb.PageController do
  use DiscussWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def test_signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
