defmodule Auctioneer.Router do
  use Auctioneer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Auctioneer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Auctioneer do
    pipe_through :api
    resources "/auction_items", AuctionItemController, except: [:new, :edit]
    resources "/bidders", BidderController, except: [:new, :edit]
    get "/bids/max", BidController, :max_bid, as: :max_bid
    resources "/bids", BidController, except: [:new, :edit]
  end
end
