defmodule Main do
  def main do
    IO.puts("Cookies File: ")
    file = IO.gets("") |> String.trim()
    main2(file)
  end

  def main2(nil), do: raise ArgumentError, message: "Please, Input a file."
  def main2(file) when is_binary(file) do
    {:ok, file_content} = File.read(file)
    file_content =
      file_content
      |> String.replace("────────────────────────────────────────", "")
      |> String.split("\n")

    objects = []
    obj = %{}

    parsed_cookies = ""

    Enum.each(file_content, fn line ->
      if String.trim(line) == "" do
        return
      end

      if String.starts_with?(line, "Browser") do
        obj = %{}
        objects = [obj | objects]
      end

      parts = String.split(line, ": ", parts: 2)
      obj = Map.put(obj, hd(parts), hd(tl(parts)) <> (length(parts) > 2 && (": " <> hd(tl(tl(parts)))) || ""))
    end)

    Enum.each(objects, fn r ->
      parsed_cookies = parsed_cookies <> "#{Map.get(r, 'Host')}\tTRUE\t/\tFALSE\t2597573456\t#{Map.get(r, 'Name')}\t#{Map.get(r, 'Value')}\n"
    end)

    File.write("./cookies.txt", parsed_cookies)

    IO.puts("Parsed: #{File.cwd!()}/cookies.txt")
  end
end

Main.main()
