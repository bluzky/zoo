defmodule Zoo.Dictionary do
  @moduledoc """
  The Dictionary context.
  """

  import Ecto.Query, warn: false
  alias Zoo.Repo

  alias Zoo.Dictionary.Vocabolary

  @doc """
  Returns the list of vocabularies.

  ## Examples

      iex> list_vocabularies()
      [%Vocabolary{}, ...]

  """
  def list_vocabularies do
    Repo.all(Vocabolary)
  end

  @doc """
  Gets a single vocabolary.

  Raises `Ecto.NoResultsError` if the Vocabolary does not exist.

  ## Examples

      iex> get_vocabolary!(123)
      %Vocabolary{}

      iex> get_vocabolary!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vocabolary(term) do
    # search by both singular and plural form.
    # which found first is used
    terms = [term, Zoo.Dictionary.Inflector.singularize(term)] |> Enum.uniq()

    results =
      Repo.list(Vocabolary, %{term: terms})
      |> Enum.into(%{}, &{&1.term, &1})

    found =
      Enum.find_value(terms, fn term ->
        results[term]
      end)

    if found do
      {:ok, found}
    else
      {:error, :not_found}
    end
  end

  def search_vocabulary(term, limit \\ 5) do
    Vocabolary
    |> Filtery.apply(%{term: {:ilike, "#{term}%"}})
    |> order_by(asc: :char_count)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Creates a vocabolary.

  ## Examples

      iex> create_vocabolary(%{field: value})
      {:ok, %Vocabolary{}}

      iex> create_vocabolary(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vocabolary(attrs \\ %{}) do
    %Vocabolary{}
    |> Vocabolary.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vocabolary.

  ## Examples

      iex> update_vocabolary(vocabolary, %{field: new_value})
      {:ok, %Vocabolary{}}

      iex> update_vocabolary(vocabolary, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vocabolary(%Vocabolary{} = vocabolary, attrs) do
    vocabolary
    |> Vocabolary.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vocabolary.

  ## Examples

      iex> delete_vocabolary(vocabolary)
      {:ok, %Vocabolary{}}

      iex> delete_vocabolary(vocabolary)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vocabolary(%Vocabolary{} = vocabolary) do
    Repo.delete(vocabolary)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vocabolary changes.

  ## Examples

      iex> change_vocabolary(vocabolary)
      %Ecto.Changeset{data: %Vocabolary{}}

  """
  def change_vocabolary(%Vocabolary{} = vocabolary, attrs \\ %{}) do
    Vocabolary.changeset(vocabolary, attrs)
  end
end
