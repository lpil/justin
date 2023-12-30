import gleam/string
import gleam/io
import gleam/list

// TODO: document
pub fn snake_case(text: String) -> String {
  text
  |> split_words
  |> string.join("_")
  |> string.lowercase
}

// TODO: document
pub fn camel_case(text: String) -> String {
  text
  |> split_words
  |> list.index_map(fn(word, i) {
    case i {
      0 -> string.lowercase(word)
      _ -> string.capitalise(word)
    }
  })
  |> string.concat
}

// TODO: document
pub fn pascal_case(text: String) -> String {
  text
  |> split_words
  |> list.map(string.capitalise)
  |> string.concat
}

// TODO: document
pub fn kebab_case(text: String) -> String {
  text
  |> split_words
  |> string.join("-")
  |> string.lowercase
}

// TODO: document
pub fn sentence_case(text: String) -> String {
  text
  |> split_words
  |> string.join(" ")
  |> string.capitalise
}

fn split_words(text: String) -> List(String) {
  text
  |> string.to_graphemes
  |> split(False, "", [])
}

fn split(
  in: List(String),
  up: Bool,
  word: String,
  words: List(String),
) -> List(String) {
  case in {
    [] if word == "" -> list.reverse(words)
    [] -> list.reverse(add(words, word))

    ["\n", ..in]
    | ["\t", ..in]
    | ["!", ..in]
    | ["?", ..in]
    | ["#", ..in]
    | [".", ..in]
    | ["-", ..in]
    | ["_", ..in]
    | [" ", ..in] -> split(in, False, "", add(words, word))

    [g, ..in] -> {
      io.println(string.inspect(#(g, is_upper(g))))
      case is_upper(g) {
        // Lowercase, not a new word
        False -> split(in, False, word <> g, words)

        // Uppercase and inside an uppercase word, not a new word
        True if up -> split(in, up, word <> g, words)

        // Uppercase otherwise, a new word
        True -> split(in, True, g, add(words, word))
      }
    }
  }
}

fn add(words: List(String), word: String) -> List(String) {
  case word {
    "" -> words
    _ -> [word, ..words]
  }
}

fn is_upper(g: String) -> Bool {
  string.lowercase(g) != g
}
