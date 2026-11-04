import VersoManual
import SFLMeta.Comment

open Lean Elab
open Verso ArgParse Doc Elab Genre.Manual
open Verso.Output.Html

namespace SFLMeta

/-!
`Block.hide` wraps regions marked `-- HIDE ... -- /HIDE` in the code-forward
source.  Its Verso processing is *identical* to `:::dev` / `:::instructor`: the
directive body is dropped at elaboration (via the shared `noopDirectiveFor`
expander), so it renders nothing and never reaches the generated outputs, while
the original text survives verbatim in the generated `…Verso.lean` source.  It
is emitted as a container directive (`::::hide`) because it wraps a region of
content rather than a single comment.  The block is kept under its own name so a
later build can treat hidden regions differently. -/
block_extension Block.hide where
  data := Json.null
  traverse _ _ _ := pure none
  toHtml := some fun _ _ _ _ _ => pure .empty
  toTeX := some fun _ _ _ _ _ => pure .empty

@[directive]
def hide : DirectiveExpanderOf Unit
  | args, contents => noopDirectiveFor ``Block.hide args contents

end SFLMeta
