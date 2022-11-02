defmodule Zoo.Repo.Migrations.CreateVocabularies do
  use Ecto.Migration

  def up do
    create table(:vocabularies) do
      add :term, :text
      add :phonetic, :text
      add :brief_meaning, :text
      add :details, :map
      add :view_count, :integer, default: 0

      timestamps(default: fragment("NOW()"))
    end

    create unique_index(:vocabularies, [:term])
    # execute "CREATE EXTENSION pg_trgm;"
    execute "CREATE INDEX term_trgm_index ON vocabularies USING gin (term gin_trgm_ops);"
  end

  def down do
    drop table(:vocabularies)
  end
end
