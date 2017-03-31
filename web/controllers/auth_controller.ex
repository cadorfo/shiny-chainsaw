defmodule Web.AuthController do
  use Web.Web, :controller
  plug Ueberauth

  alias Web.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    users_params = %{
      token: auth.token,
      provider: params.provider,
      name: auth.info.name,
      username: auth.info.nickname,
      email: auth.info.email
    }
    changeset = User.changeset(%User{},users_params)
    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn,:index))
      {:error,_reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn,:index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
