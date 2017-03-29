defmodule Web.AuthController do
  use Web.Web, :controller
  plug Ueberauth

  alias Web.User

  def callback(%{assigns: %{ueberauth: auth}} = conn, params) do
    users_params = %{
      token: auth.token,
      provider: params.provider,
      name: auth.info.name,
      username: auth.info.nickname
      email: auth.info.email
    }
    changeset = User.changeset(%User{},users_params)
    
  end
end
