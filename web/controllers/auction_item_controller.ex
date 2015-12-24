defmodule Auctioneer.AuctionItemController do
  use Auctioneer.Web, :controller

  alias Auctioneer.AuctionItem

  plug :scrub_params, "auction_item" when action in [:create, :update]

  def index(conn, _params) do
    auction_items = Repo.all(AuctionItem)
    render(conn, "index.json", auction_items: auction_items)
  end

  def create(conn, %{"auction_item" => auction_item_params}) do
    changeset = AuctionItem.changeset(%AuctionItem{}, auction_item_params)

    case Repo.insert(changeset) do
      {:ok, auction_item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", auction_item_path(conn, :show, auction_item))
        |> render("show.json", auction_item: auction_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auctioneer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    auction_item = Repo.get!(AuctionItem, id)
    render(conn, "show.json", auction_item: auction_item)
  end

  def update(conn, %{"id" => id, "auction_item" => auction_item_params}) do
    auction_item = Repo.get!(AuctionItem, id)
    changeset = AuctionItem.changeset(auction_item, auction_item_params)

    case Repo.update(changeset) do
      {:ok, auction_item} ->
        render(conn, "show.json", auction_item: auction_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auctioneer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    auction_item = Repo.get!(AuctionItem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(auction_item)

    send_resp(conn, :no_content, "")
  end
end
