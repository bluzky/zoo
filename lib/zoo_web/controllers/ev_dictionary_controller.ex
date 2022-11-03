defmodule ZooWeb.EvDictionaryController do
  use ZooWeb, :controller

  action_fallback ZooWeb.FallbackController

  def get(_conn, %{"term" => term}) do
    term = String.trim(term || "")

    if String.length(term) > 0 do
      term
      |> String.downcase()
      |> Zoo.Dictionary.get_vocabolary()
      |> case do
        {:error, _} ->
          {:error, :not_found}

        {:ok, result} ->
          {:ok, Zoo.Helpers.StructHelper.to_map(result, except: [:id, :inserted_at, :updated_at])}
      end
    else
      {:error, :not_found}
    end
  end

  def search(_conn, %{"term" => term}) do
    suggestions =
      if String.length(term) > 2 do
        term
        |> String.downcase()
        |> String.trim()
        |> Zoo.Dictionary.search_vocabulary()
        |> Enum.map(fn item ->
          Map.take(item, [:term, :phonetic, :brief_meaning])
        end)
      else
        []
      end

    {:ok, suggestions}
  end
end
