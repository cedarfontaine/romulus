open config
open rules.rules

let apply_fixes config content =
  List.fold_left (fun acc rule ->
    if rule.enabled config then rule.fix acc else acc
  ) content rules
