defmodule Auctioneer.BidderController do
  use Auctioneer.Web, :controller

  alias Auctioneer.Bidder

  plug :scrub_params, "bidder" when action in [:create, :update]

  def index(conn, _params) do
    bidders = Repo.all(Bidder)
    render(conn, "index.json", bidders: bidders)
  end

  def create(conn, %{"bidder" => bidder_params}) do
    changeset = Bidder.changeset(%Bidder{}, bidder_params)

    case Repo.insert(changeset) do
      {:ok, bidder} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", bidder_path(conn, :show, bidder))
        |> render("show.json", bidder: bidder)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auctioneer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bidder = Repo.get!(Bidder, id)
    render(conn, "show.json", bidder: bidder)
  end

  def update(conn, %{"id" => id, "bidder" => bidder_params}) do
    bidder = Repo.get!(Bidder, id)
    changeset = Bidder.changeset(bidder, bidder_params)

    case Repo.update(changeset) do
      {:ok, bidder} ->
        render(conn, "show.json", bidder: bidder)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auctioneer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bidder = Repo.get!(Bidder, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bidder)

    send_resp(conn, :no_content, "")
  end
end
