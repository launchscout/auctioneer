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

  def handle_call({:new_bid, bid = %Bid{amount: amount}}, _from, bids) do
    {:reply, "wuttup", bids}
  end

  def new_bid do
    GenServer.call(:auction_server, {:new_bid, %Bid{}})
  end

end
