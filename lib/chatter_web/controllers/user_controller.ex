defmodule ChatterWeb.UserController do
  use ChatterWeb, :controller

  alias Chatter.Accounts
  alias Chatter.Accounts.User
  alias Chatter.AuthToken
  alias Chatter.Repo
  alias Chatter.Services.Authenticator

  # action_fallback ChatterWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      case User.sign_in(user.email, user.password) do
        {:ok, auth_token} ->
          conn
          |> put_status(:ok)
          |> put_view(ChatterWeb.SessionView)
          |> render("show.json", auth_token: auth_token, user: user)
        {:error, reason} ->
          conn
          |> send_resp(401, reason)
      end
      # IO.inspect(user.email)
      # IO.inspect(user.password)
      # conn
      # |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      # # |> render("show.json", user: user)
      # |> render(ChatterWeb.SessionView, "show.json", auth_token: %{token: ''}, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def current(conn, _params) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil ->
            conn
            |> put_view(ChatterWeb.SessionView)
            |> render("show.json", auth_token: %{token: nil}, user: %{id: nil, username: nil, email: nil})
          auth_token ->
            user = Accounts.get_user!(auth_token.user_id)
            conn
            |> put_status(:ok)
            |> put_view(ChatterWeb.SessionView)
            |> render("show.json", auth_token: auth_token, user: user)
        end
      error -> 
        conn
        |> put_view(ChatterWeb.SessionView)
        |> render("show.json", auth_token: %{token: nil}, user: %{id: nil, username: nil, email: nil})
    end
  end
end
