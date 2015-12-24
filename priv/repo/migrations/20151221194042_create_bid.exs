defmodule Auctioneer.Repo.Migrations.CreateBid do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :amount, :integer
      add :bidder_id, references(:bidders)
      add :auction_item_id, references(:auction_items)

      timestamps
    end
    create index(:bids, [:bidder_id])
    create index(:bids, [:auction_item_id])

  end
end
