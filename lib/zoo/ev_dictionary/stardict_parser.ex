defmodule Zoo.EvDictionary.StardictParser do
  defmodule Node do
    defstruct type: nil, text: nil, children: [], level: nil, ref: nil
  end

  def test do
    sample =
      "ablation\t@ablation /æb'leʃn/\\n*  danh từ\\n- (y học) sự cắt bỏ (một bộ phận trong cơ thể)\\n- (địa lý,địa chất) sự tải mòn (đá)\\n- (địa lý,địa chất) sự tiêu mòn (sông băng)\\n@Chuyên ngành kỹ thuật\\n-sự cắt bỏ\\n-sự khắc mòn\\n-sự mòn\\n-sự tải mòn\\n-sự tan mòn\\n-sự thải\\n@Lĩnh vực: điện lạnh\\n-sự bốc bay\\n@Lĩnh vực: y học\\n-sự bong tách\\n-sự cắt bỏ một mô, một phần của cơ thể hoặc vùng sinh trưởng bất thường\\n@Lĩnh vực: hóa học & vật liệu\\n-tải mòn\\n-tan mòn"

    parse(sample)
  end

  def parse("00-database" <> _) do
    nil
  end

  def parse(text) do
    case Regex.run(~r/^(.+?)\s+(@|\+|\*|\-)(.+)/u, text) do
      [_, term, separator, text] ->
        root = %Node{text: String.trim(term), type: :root}

        lines = String.split(separator <> text, "\\n", trim: true)
        {root, _} = do_parse(root, nil, lines)
        to_term(root)

      _ ->
        nil
    end
  end

  def do_parse(parent, recent, [<<mark::utf8, rest::binary>> | tail] = lines) do
    {type, level} = get_type(<<mark::utf8>>)
    node = %Node{type: type, text: String.trim(rest), children: [], level: level}

    if type == :error do
      # IO.inspect(hd(lines))
      raise "error"
    end

    cond do
      is_nil(recent) ->
        do_parse(parent, node, tail)

      level == recent.level ->
        parent = %{parent | children: [recent | parent.children]}
        do_parse(parent, node, tail)

      level > recent.level ->
        {recent, remaining} = do_parse(recent, node, tail)
        do_parse(parent, recent, remaining)

      level < recent.level ->
        children = [recent | parent.children]
        parent = %{parent | children: Enum.reverse(children)}
        {parent, lines}
    end
  end

  def do_parse(parent, recent, []) do
    children = [recent | parent.children]
    {%{parent | children: Enum.reverse(children)}, []}
  end

  defp get_type(mark) do
    case mark do
      "@" -> {:scope, 1}
      "*" -> {:word_class, 2}
      "-" -> {:translation, 3}
      "=" -> {:example, 4}
      "!" -> {:phrasal_verb, 2}
      "+" -> {:ref, 4}
      _ -> {:ref, 4}
    end
  end

  alias Zoo.EvDictionary.Term

  defp to_term(node) do
    Term.new({node.text, nil, Enum.map(node.children, &to_section/1)})
  end

  defp to_section(node) do
    word_classes = Enum.filter(node.children, &(&1.type == :word_class))
    meanings = Enum.filter(node.children, &(&1.type == :translation))

    {node.text, Enum.map(word_classes, &to_word_class/1), Enum.map(meanings, &to_meaning/1)}
  end

  defp to_word_class(node) do
    {node.text, Enum.map(node.children, &to_meaning/1)}
  end

  defp to_meaning(node) do
    {node.text, Enum.map(node.children, &to_example/1) |> Enum.reject(&is_nil/1)}
  end

  defp to_example(%{text: text}) do
    text
    |> String.trim()
    |> String.split("+", parts: 2, trim: true)
    |> case do
      [ref] ->
        {"__ref", ref}

      [text, translation] ->
        {text, translation}

      _ ->
        nil
    end
  end
end
