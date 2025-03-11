open config
open reporter
open rules

let () =
  let test_content = "let BadVar = 42\nlet good_var = 43  \n" in
  let cfg = { default_config with fix_mode = false; verbose = true } in
  let issues = rules.run_all cfg test_content in
  reporter.report_issues "sample.ml" cfg issues
