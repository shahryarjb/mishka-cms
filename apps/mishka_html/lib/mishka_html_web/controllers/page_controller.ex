defmodule MishkaHtmlWeb.PageController do
  use MishkaHtmlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
