defmodule Auctioneer.AuctionItemView do
  use Auctioneer.Web, :view

  def render("index.json", %{auction_items: auction_items}) do
    %{data: render_many(auction_items, Auctioneer.AuctionItemView, "auction_item.json")}
  end

  def render("show.json", %{auction_item: auction_item}) do
    %{data: render_one(auction_item, Auctioneer.AuctionItemView, "auction_item.json")}
  end

  def render("auction_item.json", %{auction_item: auction_item}) do
    %{id: auction_item.id,
      title: auction_item.title,
      description: auction_item.description,
      image_url: auction_item.image_url,
      end_date: auction_item.end_date}
  end
end
