defmodule ChatterWeb.SessionController do
  use ChatterWeb, :controller
  alias Chatter.Accounts.User
  alias Chatter.AuthToken

  def create(conn, %{"email" => email, "password" => password}) do
    user = Chatter.Accounts.get_user_by_email!(email)
    case User.sign_in(email, password) do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> render("show.json", auth_token: auth_token, user: user)
      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end
  def delete(conn, _) do
    case User.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> render("show.json", auth_token: %{token: nil}, user: %{id: nil, username: nil, email: nil})
    end
  end
end