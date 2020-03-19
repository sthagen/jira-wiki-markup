# Changelog

`jira-wiki-markup` uses [PVP Versioning][1].
The changelog is available [on GitHub][2].

1.1.2
=====

Released 2020-03-18

* Don't escape colon/semicolon unless necessary: it is necessary
  to escape colons or semicolons only if they could otherwise
  become part of a smiley.

1.1.1
=====

Released 2020-03-18

* Colon `:` and semicolon `;` are now parsed as special
  characters, since they can be the first characters of an emoji.
* Fixed parsing of words which contain non-special symbol
  characters: word boundaries were not set correctly if a word
  contained a dot `.` or similar chars.
* Fixed incorrect emphasis parsing: digits were erroneously
  allows as the first characters after closing emphasis
  characters.

1.1.0
=====

Released 2020-03-13.

* Lists are now allowed to be indented; i.e., lists are still recognized
  if list markers are preceded by spaces.
* Support for colored inlines has been added.
* New constructor `ColorInline` for type `Inline` (API change).

1.0.0
=====

Released 2019-12-17.

* Add `Doc` datatype representing a full document; `parse` now returns
  this type.
* Improve parsing:
  - double-backslash is recognized as linebreak;
  - emoticons are parsed as `Emoji`;
  - special sequences of dashes are translated into their unicode
    representation;
  - naked URLs are parsed as `AutoLink`;
  - blocks of colored text are parsed as `Color`;
  - interpretation of special characters as markup can be forced by
    surrounding them with curly braces.
* A parser `plainText` was made available to read markup-less text.
* *Inline*-parser `symbol` was renamed to `specialChar`.
* Add printer module to render the document AST as Jira markup.
* Markup datatype changes:
  - new *Block* elements `Color` and `HorizontalRule`.
  - new *Inline* elements `Emoji`, and `Styled`.
  - *Inline* constructors `Subscript`, `Superscript`, `Emph`, `Strong`,
    `Inserted`, and `Deleted` have been remove. Use `Styled` instead.
  - Constructor `Image` now takes a list of parameters as an additional
    argument.
* CI runs also test GHC 8.8.

0.1.1
=====

* Ensure proper parsing of backslash-escaped characters.

0.1.0
=====

* Initially created.

[1]: https://pvp.haskell.org
[2]: https://github.com/tarleb/jira-wiki-markup/releases
