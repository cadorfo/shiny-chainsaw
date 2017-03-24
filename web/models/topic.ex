defmodule Web.Topic do
  use Web.Web, :model

  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\%{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title]) 
  end
end
