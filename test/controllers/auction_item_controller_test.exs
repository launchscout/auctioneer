defmodule Auctioneer.AuctionItemControllerTest do
  use Auctioneer.ConnCase

  alias Auctioneer.AuctionItem
  @valid_attrs %{description: "some content", end_date: "2010-04-17 14:00:00", image_url: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, auction_item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    auction_item = Repo.insert! %AuctionItem{}
    conn = get conn, auction_item_path(conn, :show, auction_item)
    assert json_response(conn, 200)["data"] == %{"id" => auction_item.id,
      "title" => auction_item.title,
      "description" => auction_item.description,
      "image_url" => auction_item.image_url,
      "end_date" => auction_item.end_date}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, auction_item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, auction_item_path(conn, :create), auction_item: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AuctionItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, auction_item_path(conn, :create), auction_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    auction_item = Repo.insert! %AuctionItem{}
    conn = put conn, auction_item_path(conn, :update, auction_item), auction_item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AuctionItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    auction_item = Repo.insert! %AuctionItem{}
    conn = put conn, auction_item_path(conn, :update, auction_item), auction_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    auction_item = Repo.insert! %AuctionItem{}
    conn = delete conn, auction_item_path(conn, :delete, auction_item)
    assert response(conn, 204)
    refute Repo.get(AuctionItem, auction_item.id)
  end
end
