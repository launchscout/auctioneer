defmodule Auctioneer.BidView do
  use Auctioneer.Web, :view

  def render("index.json", %{bids: bids}) do
    %{data: render_many(bids, Auctioneer.BidView, "bid.json")}
  end

  def render("show.json", %{bid: bid}) do
    %{data: render_one(bid, Auctioneer.BidView, "bid.json")}
  end

  def render("bid.json", %{bid: bid}) do
    %{id: bid.id,
      amount: bid.amount,
      bidder_id: bid.bidder_id,
      auction_item_id: bid.auction_item_id}
  end
end
