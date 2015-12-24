defmodule Auctioneer.BidController do
  use Auctioneer.Web, :controller

  alias Auctioneer.Endpoint
  alias Auctioneer.Bid
  import Ecto.Query, only: [from: 2]

  plug :scrub_params, "bid" when action in [:create, :update]

  def index(conn, _params) do
    bids = Repo.all(Bid)
    render(conn, "index.json", bids: bids)
  end

  def create(conn, %{"bid" => bid_params}) do
    IO.puts Auctioneer.AuctionServer.new_bid
    changeset = Bid.changeset(%Bid{}, bid_params)

    case Repo.insert(changeset) do
      {:ok, bid} ->
        Endpoint.broadcast! "bids:max", "change", Auctioneer.BidView.render("show.json", %{bid: bid})
        conn
        |> put_status(:created)
        |> put_resp_header("location", bid_path(conn, :show, bid))
        |> render("show.json", bid: bid)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auctioneer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def max_bid(conn, _) do
    max_amount = Repo.one(from b in Bid, select: max(b.amount))
    max_bid = Repo.one(from b in Bid, where: b.amount == ^max_amount)
    render(conn, "show.json", bid: max_bid)
  end

  def show(conn, %{"id" => id}) do
    bid = Repo.get!(Bid, id)
    render(conn, "show.json", bid: bid)
  end

  def update(conn, %{"id" => id, "bid" => bid_params}) do
    bid = Repo.get!(Bid, id)
    changeset = Bid.changeset(bid, bid_params)

    case Repo.update(changeset) do
      {:ok, bid} ->
        render(conn, "show.json", bid: bid)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auctioneer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bid = Repo.get!(Bid, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bid)

    send_resp(conn, :no_content, "")
  end
end
