defmodule Zoo.EvDictionary.Term do
  alias Zoo.EvDictionary.Term.Section

  defstruct term: nil, pronunciation: nil, sections: []

  def new({term, pronunciation, sections}) do
    %__MODULE__{
      term: term,
      pronunciation: pronunciation,
      sections: Enum.map(sections, &Section.new/1)
    }
  end

  def flatten(term) do
    {term.term, term.pronunciation, Section.flatten(term.sections)}
  end
end

defmodule Zoo.EvDictionary.Term.Section do
  alias Zoo.EvDictionary.Term.Meaning
  alias Zoo.EvDictionary.Term.WordClass
  defstruct name: nil, meanings: [], word_classes: []

  def new({name, word_classes, meanings}) do
    %__MODULE__{
      name: name,
      meanings: Enum.map(meanings, &Meaning.new/1),
      word_classes: Enum.map(word_classes, &WordClass.new/1)
    }
  end

  def flatten(sections) when is_list(sections) do
    Enum.map(sections, &flatten/1)
  end

  def flatten(section) do
    {section.name, WordClass.flatten(section.word_classes), Meaning.flatten(section.meanings)}
  end
end

defmodule Zoo.EvDictionary.Term.WordClass do
  alias Zoo.EvDictionary.Term.Meaning
  defstruct name: nil, meanings: []

  def new({name, meanings}) do
    %__MODULE__{
      name: name,
      meanings: Enum.map(meanings, &Meaning.new/1)
    }
  end

  def flatten(items) when is_list(items) do
    Enum.map(items, &flatten/1)
  end

  def flatten(item) do
    {item.name, Meaning.flatten(item.meanings)}
  end
end

defmodule Zoo.EvDictionary.Term.Meaning do
  alias Zoo.EvDictionary.Term.Example
  defstruct translation: nil, examples: []

  def new({translation, examples}) do
    %__MODULE__{translation: translation, examples: Enum.map(examples, &Example.new/1)}
  end

  def flatten(items) when is_list(items) do
    Enum.map(items, &flatten/1)
  end

  def flatten(item) do
    {item.translation, Example.flatten(item.examples)}
  end
end

defmodule Zoo.EvDictionary.Term.Example do
  defstruct source: nil, translation: nil

  def new({text, translation}) do
    %__MODULE__{source: text, translation: translation}
  end

  def flatten(items) when is_list(items) do
    Enum.map(items, &flatten/1)
  end

  def flatten(item) do
    {item.source, item.translation}
  end
end
