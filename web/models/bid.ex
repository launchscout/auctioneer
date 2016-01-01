defmodule Auctioneer.Bid do
  use Auctioneer.Web, :model

  alias Auctioneer.Repo
  alias Auctioneer.Bid

  import Ecto.Query, only: [from: 2]

  schema "bids" do
    field :amount, :integer
    belongs_to :bidder, Auctioneer.Bidder
    belongs_to :auction_item, Auctioneer.AuctionItem

    timestamps
  end

  @required_fields ~w(amount)
  @optional_fields ~w(bidder_id auction_item_id)

  def highest_bid_amount do
    Repo.one(from bid in Bid, select: max(bid.amount) ) || 0
  end

  def validate_highest_bid(:amount, amount) do
    if amount > highest_bid_amount do
      []
    else
      [amount: "is no good"]
    end
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_change(:amount, &validate_highest_bid/2)
  end

end
