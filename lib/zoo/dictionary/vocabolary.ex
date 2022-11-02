defmodule Zoo.Dictionary.Vocabolary do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zoo.Dictionary.Vocabolary.Section

  schema "vocabularies" do
    field(:brief_meaning, :string)
    embeds_many(:details, Section)
    field(:phonetic, :string)
    field(:term, :string)
    field(:view_count, :integer)
    field(:char_count, :integer)

    timestamps()
  end

  @doc false
  def changeset(vocabolary, attrs) do
    vocabolary
    |> cast(attrs, [:term, :phonetic, :brief_meaning])
    |> validate_required([:term, :brief_meaning])
    |> cast_embed(:details)
    |> unique_constraint([:term])
    |> put_char_count()
  end

  defp put_char_count(changeset) do
    case fetch_change(changeset, :term) do
      {:ok, term} -> put_change(changeset, :char_count, String.length(term))
      _ -> changeset
    end
  end
end

defmodule Zoo.Dictionary.Vocabolary.Section do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zoo.Dictionary.Vocabulary.Meaning
  alias Zoo.Dictionary.Vocabulary.WordClass

  embedded_schema do
    field(:name, :string)
    embeds_many(:meanings, Meaning)
    embeds_many(:word_classes, WordClass)
  end

  def changeset(model, attrs) do
    model
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_embed(:meanings)
    |> cast_embed(:word_classes)
  end
end

defmodule Zoo.Dictionary.Vocabulary.WordClass do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zoo.Dictionary.Vocabulary.Meaning

  embedded_schema do
    field(:name, :string)
    embeds_many(:meanings, Meaning)
  end

  def changeset(model, attrs) do
    model
    |> cast(attrs, [:name])
    |> cast_embed(:meanings)
  end
end

defmodule Zoo.Dictionary.Vocabulary.Meaning do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zoo.Dictionary.Vocabulary.Example

  embedded_schema do
    field(:translation, :string)
    embeds_many(:examples, Example)
  end

  def changeset(model, attrs) do
    model
    |> cast(attrs, [:translation])
    |> validate_required([:translation])
    |> cast_embed(:examples)
  end
end

defmodule Zoo.Dictionary.Vocabulary.Example do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:source, :string)
    field(:translation, :string)
  end

  def changeset(model, attrs) do
    model
    |> cast(attrs, [:source, :translation])
  end
end
