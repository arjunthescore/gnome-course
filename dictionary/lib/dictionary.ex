defmodule Dictionary do
  alias Dictionary.Impl.WordList

  @opaque t :: WordList.t()

  @spec start() :: t
  defdelegate start, to: WordList, as: :word_list

  @spec random_word() :: String.t 
  defdelegate random_word(), to: WordList
end
