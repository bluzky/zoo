defmodule ZooWeb.VocabolaryControllerTest do
  use ZooWeb.ConnCase

  import Zoo.DictionaryFixtures

  alias Zoo.Dictionary.Vocabolary

  @create_attrs %{
    brief_meaning: "some brief_meaning",
    details: %{},
    phonetic: "some phonetic",
    term: "some term",
    view_count: 42
  }
  @update_attrs %{
    brief_meaning: "some updated brief_meaning",
    details: %{},
    phonetic: "some updated phonetic",
    term: "some updated term",
    view_count: 43
  }
  @invalid_attrs %{brief_meaning: nil, details: nil, phonetic: nil, term: nil, view_count: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vocabularies", %{conn: conn} do
      conn = get(conn, Routes.vocabolary_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create vocabolary" do
    test "renders vocabolary when data is valid", %{conn: conn} do
      conn = post(conn, Routes.vocabolary_path(conn, :create), vocabolary: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.vocabolary_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "brief_meaning" => "some brief_meaning",
               "details" => %{},
               "phonetic" => "some phonetic",
               "term" => "some term",
               "view_count" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.vocabolary_path(conn, :create), vocabolary: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vocabolary" do
    setup [:create_vocabolary]

    test "renders vocabolary when data is valid", %{conn: conn, vocabolary: %Vocabolary{id: id} = vocabolary} do
      conn = put(conn, Routes.vocabolary_path(conn, :update, vocabolary), vocabolary: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.vocabolary_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "brief_meaning" => "some updated brief_meaning",
               "details" => %{},
               "phonetic" => "some updated phonetic",
               "term" => "some updated term",
               "view_count" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, vocabolary: vocabolary} do
      conn = put(conn, Routes.vocabolary_path(conn, :update, vocabolary), vocabolary: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vocabolary" do
    setup [:create_vocabolary]

    test "deletes chosen vocabolary", %{conn: conn, vocabolary: vocabolary} do
      conn = delete(conn, Routes.vocabolary_path(conn, :delete, vocabolary))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.vocabolary_path(conn, :show, vocabolary))
      end
    end
  end

  defp create_vocabolary(_) do
    vocabolary = vocabolary_fixture()
    %{vocabolary: vocabolary}
  end
end
