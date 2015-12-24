defmodule Auctioneer.Repo.Migrations.CreateBidder do
  use Ecto.Migration

  def change do
    create table(:bidders) do
      add :name, :string
      add :email, :string

      timestamps
    end

  end
end
