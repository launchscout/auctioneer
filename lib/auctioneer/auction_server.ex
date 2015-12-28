defmodule Auctioneer.AuctionServer do
  use GenServer

  alias Auctioneer.Repo
  alias Auctioneer.Bid

  def start_link(opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], opts)
  end

  def init([]) do
    bids = Repo.all(Bid)
    {:ok, bids}
  end

  def handle_call({:new_bid, bid_params}, _from, bids) do
    changeset = Bid.changeset(%Bid{}, bid_params)
    case Repo.insert(changeset) do
      {:ok, bid} ->
        Auctioneer.Endpoint.broadcast! "bids:max", "change", Auctioneer.BidView.render("show.json", %{bid: bid})
        {:reply, bid, [bid | bids]}
      {:error, changeset} ->
        {:reply, {:error, changeset}, bids}
    end
  end

  def new_bid(bid_params) do
    GenServer.call(:auction_server, {:new_bid, bid_params})
  end

end
