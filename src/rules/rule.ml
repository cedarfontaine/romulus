open config

type issue = {
  line : int;
  column : int;
  message : string;
}

type t = {
  name : string;
  apply : string -> issue list;
  fix : string -> string;
  enabled : config -> bool;
}

let make_rule ~name ~apply ~fix ~enabled = { name; apply; fix; enabled }
