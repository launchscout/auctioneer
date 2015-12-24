defmodule Auctioneer.BiddingTest do
  use Auctioneer.ConnCase

  alias Auctioneer.Bid

  import Auctioneer.Factory

  test "when a bid is not the max" do
    bid = create(:bid, auction_item_id: 1, amount: 2)
    new_bid_changeset = Bid.changeset(%Bid{}, %{auction_item_id: bid.auction_item_id, amount: 1})
    refute new_bid_changeset.valid?
  end

end
