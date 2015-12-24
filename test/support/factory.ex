defmodule Auctioneer.Factory do
  use ExMachina.Ecto, repo: Auctioneer.Repo

  alias Auctioneer.AuctionItem
  alias Auctioneer.Bid
  alias Auctioneer.Bidder

  def factory(:auction_item) do
    %AuctionItem{
      title: "An item",
      description: "Describes the item",
      end_date: Ecto.DateTime.cast!("2016-01-01 00:00:00"),
    }
  end

  def factory(:bid) do
    %Bid{
      auction_item: build(:auction_item),
      amount: 1
    }
  end
end
