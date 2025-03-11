open ounit2
open config
open rules

let test_naming _ =
  let content = "let BadVar = 42\n" in
  let issues = rules.run_all default_config content in
  assert_bool "naming rule triggered" (List.length issues > 0)

let suite =
  "romulus_tests" >::: [
    "test_naming" >:: test_naming;
  ]

let () =
  run_test_tt_main suite
