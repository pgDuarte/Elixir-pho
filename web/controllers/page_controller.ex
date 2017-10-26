defmodule FredIt.PageController do
  use FredIt.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
