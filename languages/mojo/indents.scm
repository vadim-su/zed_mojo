(_
  "["
  "]" @end) @indent

(_
  "{"
  "}" @end) @indent

(_
  "("
  ")" @end) @indent

(function_definition) @start.def

(class_definition) @start.class

(struct_definition) @start.struct

(trait_definition) @start.trait

(if_statement) @start.if

(elif_clause) @start.elif

(else_clause) @start.else

(for_statement) @start.for

(while_statement) @start.while

(with_statement) @start.with

(match_statement) @start.match

(try_statement) @start.try

(except_clause) @start.except

(finally_clause) @start.finally

(case_clause) @start.case
