defmodule Web.TopicController do
  use Web.Web, :controller

  def new(conn, params) do
    IO.inspect conn
    IO.puts "  --- "
    IO.inspect conn
    render conn, "new.html"
  end
end
