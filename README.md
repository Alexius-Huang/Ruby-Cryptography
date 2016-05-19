# Ruby Cipher Implementation

## Vigenère Cypher

You can use the statement `Cipher::Vigenere.new(KEY)` to generate a key :

```ruby
  key = Cipher::Vigenere.new("ENIGMA")
  # => #<Cipher::Vigenere:0x00... @key="ENIGMA" >
```

You can encrypt any kind of message by `Cipher::Vigenere#encrypt` :

```ruby
  key.encrypt "INVASIONOFNORMANDY"
  # => "MADGEISAWLZOVZITPY"
```

And you can also decrypt message by `Cipher::Vigenere#decrypt` :

```ruby
  key.decrypt "MADGEISAWLZOVZITPY"
  # => "INVASIONOFNORMANDY"
```

You can generate new key randomly by 'Cipher::Vigenere#random_key' with a parameter which specify the length of the key :

```ruby
  key.random_key 5
  # => true
  key.encrypt "INVASIONOFNORMANDY"
  # => "JSFPWJTXDJOTBBEOII"
  key.decrypt "JSFPWJTXDJOTBBEOII"
  # => "INVASIONOFNORMANDY"
```