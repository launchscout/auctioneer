defmodule Auctioneer.AuctionItemTest do
  use Auctioneer.ModelCase

  alias Auctioneer.AuctionItem
  alias Auctioneer.Factory

  @valid_attrs %{description: "some content", end_date: "2010-04-17 14:00:00", image_url: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AuctionItem.changeset(%AuctionItem{}, @valid_attrs)
    assert changeset.valid?
  end

end
