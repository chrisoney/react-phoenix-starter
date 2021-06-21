defmodule Chatter.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatter.Repo
  alias Chatter.Accounts.User
  alias Chatter.AuthToken
  alias Chatter.Accounts
  alias Comeonin.Bcrypt
  alias Chatter.Services.Authenticator

  schema "users" do
    has_many :auth_tokens, Chatter.AuthToken
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:username, downcase: true)
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  def sign_in(email, password) do
    case Bcrypt.check_pass(Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user)
       Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
        # %{ ok: auth_token.ok, user: user, auth_token: auth_token}
        # |> IO.inspect()
      err ->
        err
    end
  end
  
  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end
      error -> error
    end
  end
end
