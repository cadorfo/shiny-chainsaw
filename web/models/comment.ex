defmodule Web.Comment do
  use Web.Web, :model

  schema "comments" do
    field :content, :string
    belongs_to :user, Web.User
    belongs_to :topic, Web.Topic
    timestamps
  end
end
