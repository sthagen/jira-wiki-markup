{-# LANGUAGE LambdaCase #-}
{-|
Module      : Text.Jira.Markup
Copyright   : © 2019 Albert Krewinkel
License     : MIT

Maintainer  : Albert Krewinkel <tarleb@zeitkraut.de>
Stability   : alpha
Portability : portable

Jira markup types.
-}
module Text.Jira.Markup
  ( Block (..)
  , Inline (..)
  , ListStyle (..)
  , URL (..)
  , Row (..)
  , Cell (..)
  , Language (..)
  , Parameter (..)
  , normalizeInlines
  ) where

import Data.Text (Text)

-- | Inline Jira markup elements.
data Inline
  = Anchor Text              -- ^ anchor for internal links
  | Deleted [Inline]         -- ^ deleted (struk-out) text
  | Emph [Inline]            -- ^ emphasized text
  | Image URL                -- ^ an image
  | Inserted [Inline]        -- ^ text marked as having been inserted
  | Linebreak                -- ^ hard linebreak
  | Link [Inline] URL        -- ^ hyperlink with alias
  | Monospaced [Inline]      -- ^ text rendered with monospaced font
  | Str Text                 -- ^ simple, markup-less string
  | Space                    -- ^ space between words
  | Strong [Inline]          -- ^ strongly emphasized text
  | Subscript [Inline]       -- ^ subscript text
  | Superscript [Inline]     -- ^ superscript text
  deriving (Eq, Ord, Show)

-- | Blocks of text.
data Block
  = Code Language [Parameter] Text      -- ^ Code block with panel parameters
  | Header Int [Inline]                 -- ^ Header with level and text
  | List ListStyle [[Block]]            -- ^ List
  | NoFormat [Parameter] Text           -- ^ Unformatted text
  | Panel [Parameter] [Block]           -- ^ Formatted panel
  | Para [Inline]                       -- ^ Paragraph of text
  | Table [Row]                         -- ^ Table
  deriving (Eq, Ord, Show)

-- | Style used for list items.
data ListStyle
  = CircleBullets            -- ^ List with round bullets
  | SquareBullets            -- ^ List with square bullets
  | Enumeration              -- ^ Enumeration, i.e., numbered items
  deriving (Eq, Ord, Show)

-- | Unified resource location
newtype URL = URL { fromURL :: Text }
  deriving (Eq, Ord, Show)

-- | Table row, containing an arbitrary number of cells.
newtype Row = Row { fromRow :: [Cell] }
  deriving (Eq, Ord, Show)

-- | Table cell with block content
data Cell
  = BodyCell [Block]
  | HeaderCell [Block]
  deriving (Eq, Ord, Show)

-- | Programming language used for syntax highlighting.
newtype Language = Language Text
  deriving (Eq, Ord, Show)

-- | Panel parameter
data Parameter = Parameter
  { parameterKey :: Text
  , parameterValue :: Text
  } deriving (Eq, Ord, Show)

-- | Normalize a list of inlines, merging elements where possible.
normalizeInlines :: [Inline] -> [Inline]
normalizeInlines = \case
  []                     -> []
  [Space]                -> []
  [Linebreak]            -> []
  Space : Space : xs     -> Space : normalizeInlines xs
  Space : Linebreak : xs -> Linebreak : normalizeInlines xs
  Linebreak : Space : xs -> Linebreak : normalizeInlines xs
  Str s1 : Str s2 : xs   -> Str (s1 <> s2) : normalizeInlines xs
  x : xs                 -> x : normalizeInlines xs
