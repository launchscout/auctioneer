defmodule Auctioneer.BidderView do
  use Auctioneer.Web, :view

  def render("index.json", %{bidders: bidders}) do
    %{data: render_many(bidders, Auctioneer.BidderView, "bidder.json")}
  end

  def render("show.json", %{bidder: bidder}) do
    %{data: render_one(bidder, Auctioneer.BidderView, "bidder.json")}
  end

  def render("bidder.json", %{bidder: bidder}) do
    %{id: bidder.id,
      name: bidder.name,
      email: bidder.email}
  end
end
