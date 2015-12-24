defmodule Auctioneer.BidderControllerTest do
  use Auctioneer.ConnCase

  alias Auctioneer.Bidder
  import Auctioneer.Factory

  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, bidder_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    bidder = Repo.insert! %Bidder{}
    conn = get conn, bidder_path(conn, :show, bidder)
    assert json_response(conn, 200)["data"] == %{"id" => bidder.id,
      "name" => bidder.name,
      "email" => bidder.email}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, bidder_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, bidder_path(conn, :create), bidder: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Bidder, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, bidder_path(conn, :create), bidder: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    bidder = Repo.insert! %Bidder{}
    conn = put conn, bidder_path(conn, :update, bidder), bidder: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Bidder, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bidder = Repo.insert! %Bidder{}
    conn = put conn, bidder_path(conn, :update, bidder), bidder: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    bidder = Repo.insert! %Bidder{}
    conn = delete conn, bidder_path(conn, :delete, bidder)
    assert response(conn, 204)
    refute Repo.get(Bidder, bidder.id)
  end

end
