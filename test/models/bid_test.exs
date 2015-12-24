defmodule Auctioneer.BidTest do
  use Auctioneer.ModelCase

  alias Auctioneer.Bid
  alias Auctioneer.AuctionItem

  @valid_attrs %{amount: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bid.changeset(%Bid{}, @valid_attrs)
    IO.inspect changeset
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bid.changeset(%Bid{}, @invalid_attrs)
    refute changeset.valid?
  end

end
