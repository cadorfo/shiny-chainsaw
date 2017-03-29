defmodule Web.User do
  use Web.Web, :model

  schema "user" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :name, :string
    field :username, :string
  end

  def changeset(struct, params \\%{}) do
    struct
    |> cast(params, [:email,:provider,:token,:name,:username])
    |> validate_required([:email,:provider])
  end
end
