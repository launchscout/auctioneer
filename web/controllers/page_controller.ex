defmodule Auctioneer.PageController do
  use Auctioneer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
