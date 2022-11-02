defmodule Zoo.DictionaryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zoo.Dictionary` context.
  """

  @doc """
  Generate a vocabolary.
  """
  def vocabolary_fixture(attrs \\ %{}) do
    {:ok, vocabolary} =
      attrs
      |> Enum.into(%{
        brief_meaning: "some brief_meaning",
        details: %{},
        phonetic: "some phonetic",
        term: "some term",
        view_count: 42
      })
      |> Zoo.Dictionary.create_vocabolary()

    vocabolary
  end
end
