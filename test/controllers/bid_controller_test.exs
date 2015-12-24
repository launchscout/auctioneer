defmodule Auctioneer.BidControllerTest do
  use Auctioneer.ConnCase

  import Auctioneer.Factory

  alias Auctioneer.Bid
  @valid_attrs %{amount: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, bid_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = get conn, bid_path(conn, :show, bid)
    assert json_response(conn, 200)["data"] == %{"id" => bid.id,
      "amount" => bid.amount,
      "bidder_id" => bid.bidder_id,
      "auction_item_id" => bid.auction_item_id}
  end

  test "max bids", %{conn: conn} do
    max_bid = create(:bid, amount: 20)
    other_bid = create(:bid, amount: 19)
    conn = get conn, max_bid_path(conn, :max_bid)
    assert json_response(conn, 200)["data"]["id"] == max_bid.id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, bid_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, bid_path(conn, :create), bid: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Bid, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, bid_path(conn, :create), bid: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = put conn, bid_path(conn, :update, bid), bid: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Bid, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = put conn, bid_path(conn, :update, bid), bid: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = delete conn, bid_path(conn, :delete, bid)
    assert response(conn, 204)
    refute Repo.get(Bid, bid.id)
  end
end
