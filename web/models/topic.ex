defmodule Web.Topic do
  use Web.Web, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, Web.User
    has_many :comments, Web.Comment
  end

  def changeset(struct, params \\%{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
