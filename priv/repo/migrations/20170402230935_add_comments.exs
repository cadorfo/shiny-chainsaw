defmodule Web.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users)
      add :topic_id, references(:topics)
      timestamps
    end
  end

  def changeset(struct, params \\%{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
