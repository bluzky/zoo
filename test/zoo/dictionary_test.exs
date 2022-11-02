defmodule Zoo.DictionaryTest do
  use Zoo.DataCase

  alias Zoo.Dictionary

  describe "vocabularies" do
    alias Zoo.Dictionary.Vocabolary

    import Zoo.DictionaryFixtures

    @invalid_attrs %{brief_meaning: nil, details: nil, phonetic: nil, term: nil, view_count: nil}

    test "list_vocabularies/0 returns all vocabularies" do
      vocabolary = vocabolary_fixture()
      assert Dictionary.list_vocabularies() == [vocabolary]
    end

    test "get_vocabolary!/1 returns the vocabolary with given id" do
      vocabolary = vocabolary_fixture()
      assert Dictionary.get_vocabolary!(vocabolary.id) == vocabolary
    end

    test "create_vocabolary/1 with valid data creates a vocabolary" do
      valid_attrs = %{brief_meaning: "some brief_meaning", details: %{}, phonetic: "some phonetic", term: "some term", view_count: 42}

      assert {:ok, %Vocabolary{} = vocabolary} = Dictionary.create_vocabolary(valid_attrs)
      assert vocabolary.brief_meaning == "some brief_meaning"
      assert vocabolary.details == %{}
      assert vocabolary.phonetic == "some phonetic"
      assert vocabolary.term == "some term"
      assert vocabolary.view_count == 42
    end

    test "create_vocabolary/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dictionary.create_vocabolary(@invalid_attrs)
    end

    test "update_vocabolary/2 with valid data updates the vocabolary" do
      vocabolary = vocabolary_fixture()
      update_attrs = %{brief_meaning: "some updated brief_meaning", details: %{}, phonetic: "some updated phonetic", term: "some updated term", view_count: 43}

      assert {:ok, %Vocabolary{} = vocabolary} = Dictionary.update_vocabolary(vocabolary, update_attrs)
      assert vocabolary.brief_meaning == "some updated brief_meaning"
      assert vocabolary.details == %{}
      assert vocabolary.phonetic == "some updated phonetic"
      assert vocabolary.term == "some updated term"
      assert vocabolary.view_count == 43
    end

    test "update_vocabolary/2 with invalid data returns error changeset" do
      vocabolary = vocabolary_fixture()
      assert {:error, %Ecto.Changeset{}} = Dictionary.update_vocabolary(vocabolary, @invalid_attrs)
      assert vocabolary == Dictionary.get_vocabolary!(vocabolary.id)
    end

    test "delete_vocabolary/1 deletes the vocabolary" do
      vocabolary = vocabolary_fixture()
      assert {:ok, %Vocabolary{}} = Dictionary.delete_vocabolary(vocabolary)
      assert_raise Ecto.NoResultsError, fn -> Dictionary.get_vocabolary!(vocabolary.id) end
    end

    test "change_vocabolary/1 returns a vocabolary changeset" do
      vocabolary = vocabolary_fixture()
      assert %Ecto.Changeset{} = Dictionary.change_vocabolary(vocabolary)
    end
  end
end
