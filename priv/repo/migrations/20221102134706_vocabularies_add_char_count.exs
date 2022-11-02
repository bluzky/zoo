defmodule Zoo.Repo.Migrations.VocabulariesAddCharCount do
  use Ecto.Migration

  def up do
    alter table(:vocabularies) do
      add :char_count, :integer
    end

    execute("update vocabularies set char_count = length(term)")
  end

  def down do
    alter table(:vocabularies) do
      remove :char_count
    end
  end
end
