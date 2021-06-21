defmodule Chatter.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatter.AuthToken
  alias Chatter.Accounts.User

  schema "auth_tokens" do
    belongs_to :user, User
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end
end
