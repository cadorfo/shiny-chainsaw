defmodule Web.TopicController do
  use Web.Web, :controller

  alias Web.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{},%{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn,%{"topic" => topic}) do
     %{"title" => title} = topic
     changeset = Topic.changeset(%Topic{}, topic)
     case Repo.insert(changeset) do
       {:ok, post} ->
          conn
          |> put_flash(:info, "Topic created")
          |> redirect(to: topic_path(conn,:index))
       {:error, changeset} -> render conn, "new.html", changeset: changeset
     end
  end

  def edit(conn, %{"id"=> topic_id}) do
    topic = Repo.get(Topic,topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn,%{"topic" => topic, "id" => id}) do
     %{"title" => title} = topic
     topic_record = Repo.get(Topic,id)
     changeset = Topic.changeset(topic_record, topic)
     case Repo.update(changeset) do
       {:ok, post} ->
          conn
          |> put_flash(:info, "Topic edited")
          |> redirect(to: topic_path(conn,:index))
       {:error, changeset} -> render conn, "edit.html", changeset: changeset, topic: topic_record
     end
  end
end
