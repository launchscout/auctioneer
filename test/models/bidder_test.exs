defmodule Auctioneer.BidderTest do
  use Auctioneer.ModelCase

  alias Auctioneer.Bidder

  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bidder.changeset(%Bidder{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bidder.changeset(%Bidder{}, @invalid_attrs)
    refute changeset.valid?
  end
end
