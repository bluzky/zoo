defmodule ZooWeb.PageController do
  use ZooWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
