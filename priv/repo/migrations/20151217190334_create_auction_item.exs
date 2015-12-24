defmodule Auctioneer.Repo.Migrations.CreateAuctionItem do
  use Ecto.Migration

  def change do
    create table(:auction_items) do
      add :title, :string
      add :description, :text
      add :image_url, :string
      add :end_date, :datetime

      timestamps
    end

  end
end
