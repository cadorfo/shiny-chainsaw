defmodule Web.TopicController do
  use Web.Web, :controller
  alias Web.Topic

  plug Web.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def show(conn, %{"id" => topic_id} = params) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  def new(conn, params) do
    changeset = Topic.changeset(%Topic{},%{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn,%{"topic" => topic}) do
     %{"title" => title} = topic

    changeset = conn.assigns.user
     |> build_assoc(:topics)
     |> Topic.changeset(topic)

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

  def delete(conn, %{"id"=> id}) do
    topic = Repo.get(Topic,id)
    case Repo.delete(topic) do
      {:ok, _topic_deleted} -> {
        conn
        |> put_flash(:info, "#{topic.title} was deleted")
        |> redirect(to: topic_path(conn,:index))
      }
      {:error, _changeset} ->
        { conn
          |> put_flash(:error, "#{topic.title} wasn't deleted")
          |> redirect(to: topic_path(conn,:index)) }
    end
  end

  defp check_topic_owner(%{params: %{id: topic_id }, assigns: %{ user: user } } = conn, params) do
     if Repo.get(Topic,topic_id).user_id == user.id do
        conn
      else
        conn
        |> put_flash(:error, "You cannot edit that")
        |> redirect(to: topic_path(conn, :index))
        |> halt()
     end
  end
end
