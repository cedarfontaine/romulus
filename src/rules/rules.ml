open rule
open naming
open spacing
open max_line_length
open complexity
open unused_variable

let rules = [ naming.rule; spacing.rule; max_line_length.rule; complexity.rule; unused_variable.rule ]

let run_all config content =
  List.concat (List.map (fun r ->
    if r.enabled config then r.apply content else []
  ) rules)
