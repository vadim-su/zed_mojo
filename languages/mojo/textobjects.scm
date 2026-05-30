(function_definition
  body: (block) @function.inside) @function.around

(class_definition
  body: (block) @class.inside) @class.around

(struct_definition
  body: (block) @class.inside) @class.around

(trait_definition
  body: (block) @class.inside) @class.around

(comment)+ @comment.around
