import VersoManual
import SFLMeta.TeX

open Lean Elab
open Verso ArgParse Doc Elab Genre.Manual

namespace SFLMeta

/-!
`Block.ignore` marks content that the saver should skip when emitting the generated
`.lean` files. HTML and TeX rendering pass the contents through unchanged, so the
block is invisible in the published book — it only affects extraction. -/

block_extension Block.ignore where
  data := Json.null
  traverse _ _ _ := pure none
  toHtml := some fun _ goB _ _ contents => contents.mapM goB
  toTeX  := some fun _ goB _ _ contents => texBlocks goB contents

/--
A `:::ignore` directive: wrap content that should appear in the HTML book but not
in the generated `.lean` files. -/
@[directive]
def ignore : DirectiveExpanderOf Unit
  | (), contents => do
    let blocks ← contents.mapM elabBlock
    ``(Verso.Doc.Block.other SFLMeta.Block.ignore #[$blocks,*])

end SFLMeta
