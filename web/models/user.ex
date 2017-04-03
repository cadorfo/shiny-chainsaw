defmodule Web.User do
  use Web.Web, :model

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    field :name, :string
    field :username, :string
    has_many :topics, Web.Topic
    has_many :comments, Web.Comment
    timestamps
  end

  def changeset(struct, params \\%{}) do
    struct
    |> cast(params, [:email,:provider,:token,:name,:username])
    |> validate_required([:email,:provider])
  end
end
