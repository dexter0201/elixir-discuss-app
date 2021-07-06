defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Accounts.User

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    # Condition statement
    cond do
      user = user_id && Discuss.Accounts.get_user!(user_id) ->
        assign(conn, :user, user)
        # conn.assigns.user => user struct
      true ->
        assign(conn, :user, nil)
    end
  end
end